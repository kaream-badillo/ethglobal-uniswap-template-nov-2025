// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseHook} from "@openzeppelin/uniswap-hooks/src/base/BaseHook.sol";

import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {IPoolManager, SwapParams} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/src/types/PoolId.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "@uniswap/v4-core/src/types/BeforeSwapDelta.sol";
import {StateLibrary} from "@uniswap/v4-core/src/libraries/StateLibrary.sol";

/// @title AntiSandwichHook
/// @notice Uniswap v4 Hook that detects sandwich attack patterns in stable asset markets
/// @dev Implements risk score calculation and dynamic fee adjustment to protect LPs and users
contract AntiSandwichHook is BaseHook {
    using PoolIdLibrary for PoolKey;
    using StateLibrary for IPoolManager;

    // ============================================================
    // Constants
    // ============================================================

    /// @notice Weights for risk score calculation
    /// @dev These weights determine the importance of each metric in the risk score
    uint8 private constant W1_RELATIVE_SIZE = 50;      // Weight for relative trade size
    uint8 private constant W2_DELTA_PRICE = 30;       // Weight for price delta
    uint8 private constant W3_SPIKE_COUNT = 20;       // Weight for consecutive spikes

    /// @notice Threshold for considering a trade as a "spike"
    /// @dev If relativeSize > SPIKE_THRESHOLD, increment recentSpikeCount
    uint256 private constant SPIKE_THRESHOLD = 5;

    // ============================================================
    // Storage Structure
    // ============================================================

    /// @notice Storage structure per pool
    /// @dev Each pool has its own risk tracking and configuration
    struct PoolStorage {
        uint160 lastPrice;              // Last pool price (sqrtPriceX96)
        uint256 lastTradeSize;           // Size of the previous swap
        uint256 avgTradeSize;            // Simple moving average of trade sizes
        uint8 recentSpikeCount;          // Counter of consecutive large trades
        uint24 lowRiskFee;               // Fee for low risk (default: 5 bps = 0.05%)
        uint24 mediumRiskFee;            // Fee for medium risk (default: 20 bps = 0.20%)
        uint24 highRiskFee;              // Fee for high risk (default: 60 bps = 0.60%)
        uint8 riskThresholdLow;          // Low risk threshold (default: 50)
        uint8 riskThresholdHigh;         // High risk threshold (default: 150)
    }

    /// @notice Storage mapping per pool
    mapping(PoolId => PoolStorage) public poolStorage;

    // ============================================================
    // Access Control
    // ============================================================

    /// @notice Owner address with permission to configure pools
    address public owner;

    /// @notice Modifier to restrict function access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "AntiSandwichHook: caller is not the owner");
        _;
    }

    // ============================================================
    // Events
    // ============================================================

    /// @notice Emitted when pool configuration is updated
    event PoolConfigUpdated(
        PoolId indexed poolId,
        uint24 lowRiskFee,
        uint24 mediumRiskFee,
        uint24 highRiskFee,
        uint8 riskThresholdLow,
        uint8 riskThresholdHigh
    );

    /// @notice Emitted when dynamic fee is applied based on risk score
    event DynamicFeeApplied(
        PoolId indexed poolId,
        uint8 riskScore,
        uint24 appliedFee,
        uint256 relativeSize,
        uint160 deltaPrice,
        uint8 recentSpikeCount
    );

    /// @notice Emitted when metrics are updated after a swap
    event MetricsUpdated(
        PoolId indexed poolId,
        uint160 newPrice,
        uint256 newAvgTradeSize,
        uint8 newSpikeCount
    );

    // ============================================================
    // Constructor
    // ============================================================

    /// @notice Constructor sets the pool manager and initializes owner
    /// @param _poolManager The Uniswap v4 PoolManager contract address
    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {
        owner = msg.sender;
    }

    // ============================================================
    // Hook Permissions
    // ============================================================

    /// @notice Returns the hook permissions
    /// @dev Only beforeSwap and afterSwap are enabled for MVP
    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: false,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: true,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    // ============================================================
    // Hook Functions (Placeholders - to be implemented in next steps)
    // ============================================================

    /// @notice Hook called before a swap
    /// @dev Implemented in Paso 1.4
    /// @dev Calculates risk score and applies dynamic fee based on detected sandwich patterns
    /// @param sender The address initiating the swap
    /// @param key The pool key
    /// @param params Swap parameters including amountSpecified
    /// @param hookData Additional hook data (unused for now)
    /// @return selector The function selector
    /// @return delta The swap delta (always zero - we don't modify swap amounts)
    /// @return fee The dynamic fee to apply (calculated based on risk score)
    function _beforeSwap(
        address sender,
        PoolKey calldata key,
        SwapParams calldata params,
        bytes calldata hookData
    ) internal override returns (bytes4, BeforeSwapDelta, uint24) {
        PoolId poolId = key.toId();
        
        // ============================================================
        // 1. Get current price from pool (sqrtPriceX96)
        // ============================================================
        (uint160 sqrtPriceX96,,,) = poolManager.getSlot0(poolId);
        
        // Edge case: If pool is not initialized (sqrtPriceX96 == 0), use default fee
        if (sqrtPriceX96 == 0) {
            return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
        }
        
        // ============================================================
        // 2. Get tradeSize from params.amountSpecified
        // ============================================================
        // amountSpecified is int256 (can be positive or negative depending on swap direction)
        // We need the absolute value to get the trade size
        uint256 tradeSize;
        if (params.amountSpecified < 0) {
            tradeSize = uint256(-params.amountSpecified);
        } else {
            tradeSize = uint256(params.amountSpecified);
        }
        
        // Edge case: If tradeSize is 0, use default fee
        if (tradeSize == 0) {
            return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
        }
        
        // ============================================================
        // 3. Calculate risk score based on current metrics
        // ============================================================
        uint8 riskScore = _calculateRiskScore(poolId, sqrtPriceX96, tradeSize);
        
        // ============================================================
        // 4. Calculate dynamic fee based on risk score
        // ============================================================
        uint24 dynamicFee = _calculateDynamicFee(poolId, riskScore);
        
        // ============================================================
        // 5. Get metrics for event emission
        // ============================================================
        PoolStorage storage storage_ = poolStorage[poolId];
        uint256 avgTradeSize = storage_.avgTradeSize;
        uint256 relativeSize = (avgTradeSize > 0) ? (tradeSize * 100) / avgTradeSize : 0;
        uint160 lastPrice = storage_.lastPrice;
        uint160 deltaPrice = (lastPrice > 0 && sqrtPriceX96 > lastPrice) 
            ? sqrtPriceX96 - lastPrice 
            : (lastPrice > sqrtPriceX96) ? lastPrice - sqrtPriceX96 : 0;
        uint8 recentSpikeCount = storage_.recentSpikeCount;
        
        // ============================================================
        // 6. Emit event for logging and monitoring
        // ============================================================
        emit DynamicFeeApplied(
            poolId,
            riskScore,
            dynamicFee,
            relativeSize,
            deltaPrice,
            recentSpikeCount
        );
        
        // ============================================================
        // 7. Return hook response with dynamic fee
        // ============================================================
        return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, dynamicFee);
    }

    /// @notice Hook called after a swap
    /// @dev Implemented in Paso 1.5
    /// @dev Updates historical metrics for risk calculation in next swaps
    /// @dev This is critical for the hook's functionality - metrics must be updated after each swap
    /// @param sender The address that initiated the swap
    /// @param key The pool key
    /// @param params Swap parameters
    /// @param delta The balance delta from the swap
    /// @param hookData Additional hook data (unused for now)
    /// @return selector The function selector
    /// @return amount The amount to return (always zero - we don't modify swap amounts)
    function _afterSwap(
        address sender,
        PoolKey calldata key,
        SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) internal override returns (bytes4, int128) {
        PoolId poolId = key.toId();
        PoolStorage storage storage_ = poolStorage[poolId];
        
        // ============================================================
        // 1. Get current price from pool after swap (sqrtPriceX96)
        // ============================================================
        (uint160 sqrtPriceX96,,,) = poolManager.getSlot0(poolId);
        
        // Edge case: If pool is not initialized, skip update
        if (sqrtPriceX96 == 0) {
            return (BaseHook.afterSwap.selector, 0);
        }
        
        // ============================================================
        // 2. Get tradeSize from params.amountSpecified
        // ============================================================
        // amountSpecified is int256 (can be positive or negative depending on swap direction)
        // We need the absolute value to get the trade size
        uint256 tradeSize;
        if (params.amountSpecified < 0) {
            tradeSize = uint256(-params.amountSpecified);
        } else {
            tradeSize = uint256(params.amountSpecified);
        }
        
        // Edge case: If tradeSize is 0, skip update
        if (tradeSize == 0) {
            return (BaseHook.afterSwap.selector, 0);
        }
        
        // ============================================================
        // 3. Update lastPrice = current price
        // ============================================================
        storage_.lastPrice = sqrtPriceX96;
        
        // ============================================================
        // 4. Update avgTradeSize using simple moving average
        // ============================================================
        // Formula: avgTradeSize = (avgTradeSize * 9 + tradeSize) / 10
        // This gives a 90% weight to historical average and 10% to current trade
        // If avgTradeSize is 0 (first swap), use tradeSize directly
        uint256 currentAvgTradeSize = storage_.avgTradeSize;
        if (currentAvgTradeSize == 0) {
            // First swap: initialize with current trade size
            storage_.avgTradeSize = tradeSize;
        } else {
            // Moving average: (avgTradeSize * 9 + tradeSize) / 10
            // To prevent overflow, we calculate: (currentAvgTradeSize * 9 + tradeSize) / 10
            // Using unchecked for gas optimization (we know the values are bounded)
            unchecked {
                storage_.avgTradeSize = (currentAvgTradeSize * 9 + tradeSize) / 10;
            }
        }
        
        // ============================================================
        // 5. Calculate relativeSize = tradeSize / avgTradeSize
        // ============================================================
        // This is used to determine if this is a "spike" (large trade)
        uint256 relativeSize = 0;
        uint256 updatedAvgTradeSize = storage_.avgTradeSize;
        if (updatedAvgTradeSize > 0) {
            // Calculate relative size: how many times larger than average
            relativeSize = (tradeSize * 100) / updatedAvgTradeSize; // Scale by 100 for precision
            relativeSize = relativeSize / 100; // Normalize back
        }
        
        // ============================================================
        // 6. Update recentSpikeCount based on relativeSize
        // ============================================================
        // If relativeSize > SPIKE_THRESHOLD (5), increment counter
        // Otherwise, reset counter (no consecutive spikes)
        if (relativeSize > SPIKE_THRESHOLD) {
            // Large trade detected: increment spike count
            // Cap at 255 to prevent overflow (uint8 max)
            if (storage_.recentSpikeCount < 255) {
                storage_.recentSpikeCount++;
            }
        } else {
            // Normal trade: reset spike count
            storage_.recentSpikeCount = 0;
        }
        
        // ============================================================
        // 7. Update lastTradeSize for future reference
        // ============================================================
        storage_.lastTradeSize = tradeSize;
        
        // ============================================================
        // 8. Emit event for logging and monitoring
        // ============================================================
        emit MetricsUpdated(
            poolId,
            sqrtPriceX96,
            storage_.avgTradeSize,
            storage_.recentSpikeCount
        );
        
        // ============================================================
        // 9. Return hook response
        // ============================================================
        return (BaseHook.afterSwap.selector, 0);
    }

    // ============================================================
    // Internal Helper Functions (Placeholders - to be implemented)
    // ============================================================

    /// @notice Calculates the risk score based on trade size, price delta, and consecutive spikes
    /// @dev Implemented in Paso 1.2
    /// @dev Formula from docs-internos/idea-general.md: riskScore = w1*relativeSize + w2*deltaPrice + w3*recentSpikeCount
    /// @param poolId The pool identifier
    /// @param currentPrice The current pool price (sqrtPriceX96)
    /// @param tradeSize The size of the current trade
    /// @return riskScore The calculated risk score (0-255, clamped to uint8 max)
    /// 
    /// @notice Risk score components:
    /// - relativeSize: tradeSize / avgTradeSize (if avgTradeSize = 0, use tradeSize as base)
    /// - deltaPrice: abs(currentPrice - lastPrice) normalized
    /// - recentSpikeCount: from poolStorage (already uint8)
    /// 
    /// @notice Weights (constants):
    /// - W1_RELATIVE_SIZE = 50 (trade size impact)
    /// - W2_DELTA_PRICE = 30 (price volatility)
    /// - W3_SPIKE_COUNT = 20 (consecutive large trades)
    function _calculateRiskScore(
        PoolId poolId,
        uint160 currentPrice,
        uint256 tradeSize
    ) internal view returns (uint8 riskScore) {
        PoolStorage storage storage_ = poolStorage[poolId];
        
        // ============================================================
        // 1. Calculate relativeSize = tradeSize / avgTradeSize
        // ============================================================
        uint256 relativeSize;
        uint256 avgTradeSize = storage_.avgTradeSize;
        
        if (avgTradeSize == 0) {
            // First swap: no historical data, use tradeSize as base
            // Set relativeSize = 1 to indicate normal size (no spike detected yet)
            relativeSize = 1;
        } else {
            // Calculate relative size: how many times larger than average
            // relativeSize = tradeSize / avgTradeSize
            // Example: if tradeSize = 1000 and avgTradeSize = 100, relativeSize = 10 (10x larger)
            relativeSize = tradeSize / avgTradeSize;
            
            // Cap relativeSize to prevent overflow in riskScore calculation
            // Max relativeSize = 10 (10x larger than average is already very suspicious)
            // This prevents: W1 * relativeSize from exceeding uint8 range
            if (relativeSize > 10) {
                relativeSize = 10;
            }
        }
        
        // ============================================================
        // 2. Calculate deltaPrice = abs(P_current - lastPrice)
        // ============================================================
        uint256 deltaPriceNormalized;
        uint160 lastPrice = storage_.lastPrice;
        
        if (lastPrice == 0) {
            // First swap: no previous price to compare
            deltaPriceNormalized = 0;
        } else {
            // Calculate absolute difference in sqrtPriceX96
            uint256 deltaPriceRaw;
            if (currentPrice > lastPrice) {
                deltaPriceRaw = uint256(currentPrice) - uint256(lastPrice);
            } else {
                deltaPriceRaw = uint256(lastPrice) - uint256(currentPrice);
            }
            
            // Normalize deltaPrice to a manageable scale
            // sqrtPriceX96 is Q64.96 fixed point (2^96 * sqrt(price))
            // For stable assets, price changes are small, so we normalize by dividing
            // We use a scaling factor to convert to a 0-10 scale
            // Typical price changes in stables: ~0.1% = deltaPriceRaw ~ 1e15
            // Normalize: divide by 1e14 to get a 0-10 scale
            if (deltaPriceRaw > 0) {
                deltaPriceNormalized = deltaPriceRaw / 1e14;
                // Cap to prevent overflow (max 10 for uint8 calculations)
                if (deltaPriceNormalized > 10) {
                    deltaPriceNormalized = 10;
                }
            } else {
                deltaPriceNormalized = 0;
            }
        }
        
        // ============================================================
        // 3. Read recentSpikeCount from storage
        // ============================================================
        uint8 recentSpikeCount = storage_.recentSpikeCount;
        
        // Cap recentSpikeCount to prevent overflow (max ~10 for uint8 calculations)
        if (recentSpikeCount > 10) {
            recentSpikeCount = 10;
        }
        
        // ============================================================
        // 4. Calculate riskScore using the formula
        // riskScore = (W1 * relativeSize) + (W2 * deltaPrice) + (W3 * recentSpikeCount)
        // ============================================================
        uint256 calculatedScore = (uint256(W1_RELATIVE_SIZE) * relativeSize) +
                                  (uint256(W2_DELTA_PRICE) * deltaPriceNormalized) +
                                  (uint256(W3_SPIKE_COUNT) * uint256(recentSpikeCount));
        
        // ============================================================
        // 5. Clamp to uint8 range (0-255) to prevent overflow
        // ============================================================
        if (calculatedScore > 255) {
            riskScore = 255;
        } else {
            riskScore = uint8(calculatedScore);
        }
        
        return riskScore;
    }

    /// @notice Calculates the dynamic fee based on risk score
    /// @dev Implemented in Paso 1.3
    /// @dev Fee tiers from docs-internos/idea-general.md:
    ///      - Low risk (< 50): 5 bps
    ///      - Medium risk (50-150): 20 bps
    ///      - High risk (>= 150): 60 bps (anti-sandwich mode)
    /// @param poolId The pool identifier
    /// @param riskScore The calculated risk score
    /// @return fee The dynamic fee in basis points
    /// 
    /// @notice Fee logic:
    /// - If riskScore < riskThresholdLow: return lowRiskFee (default: 5 bps)
    /// - Else if riskScore < riskThresholdHigh: return mediumRiskFee (default: 20 bps)
    /// - Else: return highRiskFee (default: 60 bps) - anti-sandwich mode
    /// 
    /// @notice If fees not configured (0), return default values
    function _calculateDynamicFee(
        PoolId poolId,
        uint8 riskScore
    ) internal view returns (uint24 fee) {
        PoolStorage storage storage_ = poolStorage[poolId];
        
        // ============================================================
        // Read thresholds and fees from storage
        // ============================================================
        uint8 riskThresholdLow = storage_.riskThresholdLow;
        uint8 riskThresholdHigh = storage_.riskThresholdHigh;
        uint24 lowRiskFee = storage_.lowRiskFee;
        uint24 mediumRiskFee = storage_.mediumRiskFee;
        uint24 highRiskFee = storage_.highRiskFee;
        
        // ============================================================
        // Validate configuration and use defaults if not configured
        // ============================================================
        // If thresholds are not configured (0), use default values
        if (riskThresholdLow == 0) {
            riskThresholdLow = 50; // Default low threshold
        }
        if (riskThresholdHigh == 0) {
            riskThresholdHigh = 150; // Default high threshold
        }
        
        // If fees are not configured (0), use default values
        if (lowRiskFee == 0) {
            lowRiskFee = 5; // Default: 5 bps (0.05%)
        }
        if (mediumRiskFee == 0) {
            mediumRiskFee = 20; // Default: 20 bps (0.20%)
        }
        if (highRiskFee == 0) {
            highRiskFee = 60; // Default: 60 bps (0.60%) - anti-sandwich mode
        }
        
        // ============================================================
        // Apply dynamic fee logic based on risk score
        // ============================================================
        // Low risk: riskScore < riskThresholdLow (default: < 50)
        // - Normal trading conditions, minimal fee
        if (riskScore < riskThresholdLow) {
            fee = lowRiskFee;
        }
        // Medium risk: riskThresholdLow <= riskScore < riskThresholdHigh (default: 50-150)
        // - Moderate suspicious activity, increased fee
        else if (riskScore < riskThresholdHigh) {
            fee = mediumRiskFee;
        }
        // High risk: riskScore >= riskThresholdHigh (default: >= 150)
        // - High probability of sandwich attack, maximum fee (anti-sandwich mode)
        else {
            fee = highRiskFee;
        }
        
        return fee;
    }

    // ============================================================
    // Configuration Functions (Placeholders - to be implemented in Paso 1.6)
    // ============================================================

    /// @notice Sets the configuration for a pool
    /// @dev Only owner can call. Validates all parameters before updating.
    /// @param key The pool key
    /// @param _lowRiskFee Fee for low risk swaps (in basis points, must be > 0 and <= 10000)
    /// @param _mediumRiskFee Fee for medium risk swaps (in basis points, must be > 0 and <= 10000)
    /// @param _highRiskFee Fee for high risk swaps (in basis points, must be > 0 and <= 10000)
    /// @param _riskThresholdLow Low risk threshold (must be < riskThresholdHigh)
    /// @param _riskThresholdHigh High risk threshold (must be > riskThresholdLow)
    function setPoolConfig(
        PoolKey calldata key,
        uint24 _lowRiskFee,
        uint24 _mediumRiskFee,
        uint24 _highRiskFee,
        uint8 _riskThresholdLow,
        uint8 _riskThresholdHigh
    ) external onlyOwner {
        // ============================================================
        // 1. Validate fee parameters
        // ============================================================
        // Fees must be > 0 and <= 10000 (100%)
        require(_lowRiskFee > 0 && _lowRiskFee <= 10000, "AntiSandwichHook: invalid lowRiskFee");
        require(_mediumRiskFee > 0 && _mediumRiskFee <= 10000, "AntiSandwichHook: invalid mediumRiskFee");
        require(_highRiskFee > 0 && _highRiskFee <= 10000, "AntiSandwichHook: invalid highRiskFee");
        
        // Fees must be in ascending order: lowRiskFee < mediumRiskFee < highRiskFee
        require(_lowRiskFee < _mediumRiskFee, "AntiSandwichHook: lowRiskFee must be < mediumRiskFee");
        require(_mediumRiskFee < _highRiskFee, "AntiSandwichHook: mediumRiskFee must be < highRiskFee");
        
        // ============================================================
        // 2. Validate threshold parameters
        // ============================================================
        // Thresholds must be in ascending order: riskThresholdLow < riskThresholdHigh
        require(_riskThresholdLow < _riskThresholdHigh, "AntiSandwichHook: riskThresholdLow must be < riskThresholdHigh");
        
        // ============================================================
        // 3. Update pool storage
        // ============================================================
        PoolId poolId = key.toId();
        PoolStorage storage storage_ = poolStorage[poolId];
        
        storage_.lowRiskFee = _lowRiskFee;
        storage_.mediumRiskFee = _mediumRiskFee;
        storage_.highRiskFee = _highRiskFee;
        storage_.riskThresholdLow = _riskThresholdLow;
        storage_.riskThresholdHigh = _riskThresholdHigh;
        
        // ============================================================
        // 4. Emit event for logging and monitoring
        // ============================================================
        emit PoolConfigUpdated(
            poolId,
            _lowRiskFee,
            _mediumRiskFee,
            _highRiskFee,
            _riskThresholdLow,
            _riskThresholdHigh
        );
    }

    /// @notice Gets the current configuration for a pool
    /// @param poolId The pool identifier
    /// @return config The pool configuration
    function getPoolConfig(PoolId poolId) external view returns (PoolStorage memory config) {
        return poolStorage[poolId];
    }

    /// @notice Gets the current metrics for a pool
    /// @param poolId The pool identifier
    /// @return lastPrice The last recorded price
    /// @return avgTradeSize The current average trade size
    /// @return recentSpikeCount The current spike count
    function getPoolMetrics(PoolId poolId)
        external
        view
        returns (uint160 lastPrice, uint256 avgTradeSize, uint8 recentSpikeCount)
    {
        PoolStorage storage storage_ = poolStorage[poolId];
        return (storage_.lastPrice, storage_.avgTradeSize, storage_.recentSpikeCount);
    }
}


