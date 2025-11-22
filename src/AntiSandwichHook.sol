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

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

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
    /// @dev Will implement risk score calculation and dynamic fee in Paso 1.4
    /// @dev Based on Uniswap v4 template and best practices from README-INTERNO.md
    /// @param sender The address initiating the swap
    /// @param key The pool key
    /// @param params Swap parameters including amountIn/amountOut
    /// @param hookData Additional hook data (unused for now)
    /// @return selector The function selector
    /// @return delta The swap delta (zero for now)
    /// @return fee The dynamic fee to apply (to be calculated)
    /// 
    /// @notice Implementation notes (Paso 1.4):
    /// - Get current price: (uint160 sqrtPriceX96,,,) = poolManager.getSlot0(key.toId())
    /// - Get tradeSize: params.amountSpecified (int256, convert to uint256 with abs)
    /// - Calculate riskScore using _calculateRiskScore()
    /// - Calculate dynamicFee using _calculateDynamicFee()
    /// - Return fee to override pool's base fee
    function _beforeSwap(
        address sender,
        PoolKey calldata key,
        SwapParams calldata params,
        bytes calldata hookData
    ) internal override returns (bytes4, BeforeSwapDelta, uint24) {
        // TODO: Implement in Paso 1.4
        // 1. Get current price from pool using poolManager.getSlot0(key.toId())
        //    Example: (uint160 sqrtPriceX96,,,) = poolManager.getSlot0(key.toId());
        // 2. Get tradeSize from params.amountSpecified (int256, use abs() to convert to uint256)
        // 3. Call _calculateRiskScore(poolId, currentPrice, tradeSize) (to be implemented in Paso 1.2)
        // 4. Call _calculateDynamicFee(poolId, riskScore) (to be implemented in Paso 1.3)
        // 5. Return (selector, BeforeSwapDelta.ZERO_DELTA, dynamicFee)
        // 6. Emit DynamicFeeApplied event with all metrics
        
        return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }

    /// @notice Hook called after a swap
    /// @dev Will implement metrics update in Paso 1.5
    /// @dev Updates historical metrics for risk calculation in next swaps
    /// @param sender The address that initiated the swap
    /// @param key The pool key
    /// @param params Swap parameters
    /// @param delta The balance delta from the swap
    /// @param hookData Additional hook data (unused for now)
    /// @return selector The function selector
    /// @return amount The amount to return (zero for now)
    /// 
    /// @notice Implementation notes (Paso 1.5):
    /// - Get current price after swap: (uint160 sqrtPriceX96,,,) = poolManager.getSlot0(key.toId())
    /// - Get tradeSize: abs(params.amountSpecified) converted to uint256
    /// - Update storage: lastPrice, avgTradeSize (moving average), recentSpikeCount
    /// - Moving average formula: avgTradeSize = (avgTradeSize * 9 + tradeSize) / 10
    function _afterSwap(
        address sender,
        PoolKey calldata key,
        SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) internal override returns (bytes4, int128) {
        // TODO: Implement in Paso 1.5
        // 1. Get current price from pool after swap using poolManager.getSlot0(key.toId())
        // 2. Get tradeSize from params.amountSpecified (convert int256 to uint256 with abs)
        // 3. Update poolStorage[key.toId()].lastPrice = currentPrice
        // 4. Update avgTradeSize using moving average:
        //    - If avgTradeSize == 0: avgTradeSize = tradeSize
        //    - Else: avgTradeSize = (avgTradeSize * 9 + tradeSize) / 10
        // 5. Calculate relativeSize = tradeSize / avgTradeSize (handle division by zero)
        // 6. Update recentSpikeCount:
        //    - If relativeSize > SPIKE_THRESHOLD (5): recentSpikeCount++
        //    - Else: recentSpikeCount = 0 (reset counter)
        // 7. Update poolStorage[key.toId()].lastTradeSize = tradeSize
        // 8. Emit MetricsUpdated event
        
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
    /// @dev To be implemented in Paso 1.3
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
        // TODO: Implement in Paso 1.3
        // 1. Read poolStorage[poolId] to get thresholds and fees
        // 2. Check if configuration exists (lowRiskFee != 0)
        // 3. Apply fee logic:
        //    if (riskScore < riskThresholdLow) {
        //        fee = lowRiskFee != 0 ? lowRiskFee : 5; // Default 5 bps
        //    } else if (riskScore < riskThresholdHigh) {
        //        fee = mediumRiskFee != 0 ? mediumRiskFee : 20; // Default 20 bps
        //    } else {
        //        fee = highRiskFee != 0 ? highRiskFee : 60; // Default 60 bps
        //    }
        // 4. Return fee
        return 0;
    }

    // ============================================================
    // Configuration Functions (Placeholders - to be implemented in Paso 1.6)
    // ============================================================

    /// @notice Sets the configuration for a pool
    /// @dev Only owner can call (to be implemented with access control in Paso 1.6)
    /// @param key The pool key
    /// @param _lowRiskFee Fee for low risk swaps (in basis points)
    /// @param _mediumRiskFee Fee for medium risk swaps (in basis points)
    /// @param _highRiskFee Fee for high risk swaps (in basis points)
    /// @param _riskThresholdLow Low risk threshold
    /// @param _riskThresholdHigh High risk threshold
    function setPoolConfig(
        PoolKey calldata key,
        uint24 _lowRiskFee,
        uint24 _mediumRiskFee,
        uint24 _highRiskFee,
        uint8 _riskThresholdLow,
        uint8 _riskThresholdHigh
    ) external {
        // TODO: Implement in Paso 1.6
        // 1. Add onlyOwner modifier
        // 2. Validate parameters:
        //    - Fees > 0 and <= 10000 (100%)
        //    - lowRiskFee < mediumRiskFee < highRiskFee
        //    - riskThresholdLow < riskThresholdHigh
        // 3. Update poolStorage[key.toId()]
        // 4. Emit PoolConfigUpdated event
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


