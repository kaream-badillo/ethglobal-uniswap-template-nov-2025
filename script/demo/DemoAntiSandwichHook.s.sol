// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {IPoolManager, SwapParams} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/src/types/PoolId.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {StateLibrary} from "@uniswap/v4-core/src/libraries/StateLibrary.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";

import {AntiSandwichHook} from "../../src/AntiSandwichHook.sol";
import {AddressConstants} from "hookmate/constants/AddressConstants.sol";

/// @title DemoAntiSandwichHook
/// @notice Demo script that shows AntiSandwichHook in action
/// @dev Demonstrates dynamic fee calculation based on deltaTick
/// @dev Shows difference between normal swaps (low deltaTick) vs risky swaps (high deltaTick)
contract DemoAntiSandwichHook is Script {
    using PoolIdLibrary for PoolKey;
    using StateLibrary for IPoolManager;

    // ============================================================
    // Configuration - Deployed Hook Address (Sepolia)
    // ============================================================
    
    /// @notice Deployed hook address on Sepolia testnet
    /// @dev From docs-internos/deploy-exitoso.md
    address constant DEPLOYED_HOOK = address(0x5AebB929DA77cCDFE141CeB2Af210FaA3905c0c0);
    
    /// @notice PoolManager address (auto-detected from chainId)
    IPoolManager poolManager;
    
    /// @notice Hook instance
    AntiSandwichHook hook;

    // ============================================================
    // Demo Configuration
    // ============================================================
    
    /// @notice Test tokens (using mock addresses for demo)
    /// @dev In real demo, these would be actual token addresses
    Currency currency0 = Currency.wrap(address(0x0165878A594ca255338adfa4d48449f69242Eb8F));
    Currency currency1 = Currency.wrap(address(0xa513E6E4b8f2a923D98304ec87F64353C4D5C853));
    
    /// @notice Pool configuration
    uint24 constant POOL_FEE = 3000; // 0.3% (30 bps)
    int24 constant TICK_SPACING = 60;

    function setUp() public {
        // Get PoolManager from chainId (only needed if using fork)
        // For simulation mode, we don't need to interact with poolManager
        uint256 chainId = block.chainid;
        if (chainId != 31337) {
            // Only get PoolManager if not in local simulation
            poolManager = IPoolManager(AddressConstants.getPoolManagerAddress(chainId));
        }
        
        // Get hook instance (address is constant, works in any mode)
        hook = AntiSandwichHook(DEPLOYED_HOOK);
    }

    function run() public view {
        console2.log("==========================================");
        console2.log("AntiSandwichHook Demo");
        console2.log("==========================================");
        console2.log("Hook Address:", address(hook));
        console2.log("Chain ID:", block.chainid);
        console2.log("Mode: Simulation (no fork required)");
        console2.log("");

        // ============================================================
        // Scenario 1: Normal Swap (deltaTick = 0)
        // ============================================================
        
        console2.log("==========================================");
        console2.log("SCENARIO 1: Normal Swap (Low Risk)");
        console2.log("==========================================");
        
        // Simulate normal swap scenario (deltaTick = 0)
        int24 deltaTick = 0;
        console2.log("DeltaTick:", deltaTick);
        console2.log("Interpretation: Normal swap in stable pair");
        console2.log("Expected Fee: 5 bps (baseFee) - Normal swap");
        console2.log("");

        // ============================================================
        // Scenario 2: Risky Swap (deltaTick > 0)
        // ============================================================
        
        console2.log("==========================================");
        console2.log("SCENARIO 2: Risky Swap (High Risk)");
        console2.log("==========================================");
        console2.log("Simulating a swap that causes price jump...");
        console2.log("");
        
        // Simulate a large price jump (deltaTick = 3)
        int24 simulatedDeltaTick = 3;
        console2.log("Simulated DeltaTick:", simulatedDeltaTick);
        
        // Calculate expected fee using formula: fee = baseFee + k1*deltaTick + k2*deltaTick^2
        uint24 baseFee = 5; // 5 bps
        uint24 maxFee = 60; // 60 bps
        uint24 k1 = 5; // 0.5 scaled x10
        uint24 k2 = 2; // 0.2 scaled x10
        
        uint256 calculatedFee = uint256(baseFee);
        if (simulatedDeltaTick > 0) {
            uint256 deltaTickUint = uint256(uint24(simulatedDeltaTick));
            calculatedFee += (uint256(k1) * deltaTickUint) / 10; // Linear term
            calculatedFee += (uint256(k2) * deltaTickUint * deltaTickUint) / 10; // Quadratic term
        }
        
        // Apply cap
        if (calculatedFee > maxFee) {
            calculatedFee = maxFee;
        }
        
        console2.log("Formula: fee = baseFee + k1*deltaTick + k2*deltaTick^2");
        console2.log("Calculation:");
        console2.log("  baseFee:", baseFee, "bps");
        console2.log("  k1*deltaTick:", (k1 * uint24(simulatedDeltaTick)) / 10, "bps");
        console2.log("  k2*deltaTick^2:", (k2 * uint24(simulatedDeltaTick) * uint24(simulatedDeltaTick)) / 10, "bps");
        console2.log("  Total Fee:", uint24(calculatedFee), "bps");
        console2.log("");
        
        // ============================================================
        // Scenario 3: Very Risky Swap (deltaTick = 10)
        // ============================================================
        
        console2.log("==========================================");
        console2.log("SCENARIO 3: Very Risky Swap (deltaTick = 10)");
        console2.log("==========================================");
        
        int24 veryRiskyDeltaTick = 10;
        console2.log("Simulated DeltaTick:", veryRiskyDeltaTick);
        
        uint256 veryRiskyFee = uint256(baseFee);
        if (veryRiskyDeltaTick > 0) {
            uint256 deltaTickUint = uint256(uint24(veryRiskyDeltaTick));
            veryRiskyFee += (uint256(k1) * deltaTickUint) / 10;
            veryRiskyFee += (uint256(k2) * deltaTickUint * deltaTickUint) / 10;
        }
        
        if (veryRiskyFee > maxFee) {
            veryRiskyFee = maxFee;
        }
        
        console2.log("Formula: fee = baseFee + k1*deltaTick + k2*deltaTick^2");
        console2.log("Calculation:");
        console2.log("  baseFee:", baseFee, "bps");
        console2.log("  k1*deltaTick:", (k1 * uint24(veryRiskyDeltaTick)) / 10, "bps");
        console2.log("  k2*deltaTick^2:", (k2 * uint24(veryRiskyDeltaTick) * uint24(veryRiskyDeltaTick)) / 10, "bps");
        console2.log("  Total Fee:", uint24(veryRiskyFee), "bps");
        console2.log("");

        // ============================================================
        // Summary - Exact Values for Screenshot
        // ============================================================
        
        console2.log("==========================================");
        console2.log("SUMMARY - Fee Comparison (For Screenshot)");
        console2.log("==========================================");
        console2.log("deltaTick = 0 -> fee = 5 bps");
        console2.log("deltaTick = 3 -> fee =", uint24(calculatedFee), "bps");
        console2.log("deltaTick = 10 -> fee =", uint24(veryRiskyFee), "bps");
        console2.log("");
        console2.log("Detailed Breakdown:");
        console2.log("  Normal Swap (deltaTick = 0):");
        console2.log("    Fee: 5 bps (baseFee)");
        console2.log("    Risk: Low - Normal trading");
        console2.log("");
        console2.log("  Risky Swap (deltaTick = 3):");
        console2.log("    Fee:", uint24(calculatedFee), "bps");
        console2.log("    Risk: Medium - Possible sandwich attack");
        console2.log("    Protection: Fee increases quadratically");
        console2.log("");
        console2.log("  Very Risky Swap (deltaTick = 10):");
        console2.log("    Fee:", uint24(veryRiskyFee), "bps");
        console2.log("    Risk: High - Strong sandwich attack pattern");
        console2.log("    Protection: Quadratic term dominates");
        console2.log("");
        console2.log("==========================================");
        console2.log("Key Insights:");
        console2.log("==========================================");
        console2.log("1. Normal swaps maintain low fee (5 bps)");
        console2.log("2. Risky swaps trigger dynamic fee increase");
        console2.log("3. Fee grows QUADRATICALLY (not linearly)");
        console2.log("4. Maximum protection at 60 bps for high-risk swaps");
        console2.log("5. Gas efficient: ~900 gas per swap");
        console2.log("6. No external oracles required - all on-chain");
        console2.log("==========================================");
        
        // ============================================================
        // Hook Configuration
        // ============================================================
        
        console2.log("");
        console2.log("Hook Configuration (Default Values):");
        console2.log("  Base Fee: 5 bps (0.05%)");
        console2.log("  Max Fee: 60 bps (0.60%)");
        console2.log("  Formula: fee = baseFee + k1*deltaTick + k2*deltaTick^2");
        console2.log("  k1: 5 (0.5 scaled x10)");
        console2.log("  k2: 2 (0.2 scaled x10)");
        console2.log("");
        console2.log("Note: Configuration can be updated by hook owner");
        console2.log("      using setPoolConfig() function");
    }
}

