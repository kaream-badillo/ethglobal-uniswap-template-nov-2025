# 🪝 Anti-LVR Hook for Uniswap v4

> **A Uniswap v4 Hook that reduces Loss Versus Rebalancing (LVR) for Liquidity Providers by smoothing price movements and applying dynamic fees based on volatility.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-^0.8.0-blue.svg)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Foundry-Stable-green.svg)](https://getfoundry.sh/)

---

## 🎯 Problem Statement

Liquidity Providers (LPs) lose money due to **Loss Versus Rebalancing (LVR)** when:
- Pool prices move with sudden jumps
- Arbitrageurs exploit these jumps
- LPs sell low and buy high

This happens frequently in volatile pairs (ETH/USDC, BTC/USDC, etc.).

## 💡 Solution

This Uniswap v4 Hook:
1. **Smooths internal price** during swaps (amortized price)
2. **Adjusts fees dynamically** based on detected volatility
3. **Reduces LVR** without external oracles
4. **Preserves UX** - doesn't block swaps or modify the AMM curve

---

## 🏗️ How It Works

### Price Smoothing

The hook tracks the last pool price and calculates price movements. When volatility exceeds a threshold, it applies smoothing:

```solidity
if (delta > volatilityThreshold) {
    P_effective = (P_current + lastPrice) / 2  // Smoothing
} else {
    P_effective = P_current  // No changes
}
```

### Dynamic Fees

Fees increase with volatility to compensate LPs:

```solidity
volatilityFee = baseFee + (delta * volatilityMultiplier)
volatilityFee = clamp(volatilityFee, minFee, maxFee)
```

### Implementation

- **`beforeSwap()`** - Applies amortized price and dynamic fee
- **`afterSwap()`** - Updates `lastPrice` in storage

---

## 🚀 Quick Start

### Prerequisites

- [Foundry](https://getfoundry.sh/) (stable version)
- Git

### Installation

```bash
# Clone the repository
git clone <YOUR_REPO_URL>
cd ethglobal-uniswap-template-nov-2025

# Install dependencies
forge install

# Run tests
forge test
```

### Local Development

1. **Start Anvil** (local blockchain):

```bash
anvil
```

Or fork a testnet:

```bash
anvil --fork-url <YOUR_RPC_URL>
```

2. **Deploy the hook**:

```bash
forge script script/deploy/DeployAntiLVRHook.s.sol \
  --rpc-url http://localhost:8545 \
  --private-key <PRIVATE_KEY> \
  --broadcast
```

### Testing

```bash
# Run all tests
forge test

# Run with gas report
forge test --gas-report

# Run fork tests (requires RPC_URL)
forge test --fork-url $RPC_URL
```

---

## 📋 Configuration

The hook can be configured with the following parameters:

- **`baseFee`**: Base fee in basis points (default: 5 bps = 0.05%)
- **`volatilityMultiplier`**: Volatility multiplier (default: 1)
- **`volatilityThreshold`**: Threshold for applying smoothing (calculated)
- **`minFee`**: Minimum fee (default: 5 bps)
- **`maxFee`**: Maximum fee (default: 50 bps)

### Setting Parameters

```solidity
// Only owner can update
hook.setBaseFee(5);  // 5 bps
hook.setVolatilityMultiplier(2);
hook.setVolatilityThreshold(1000);
```

---

## 🧪 Testing

The project includes comprehensive tests:

- **Unit tests**: Core logic (price smoothing, fee calculation)
- **Integration tests**: Full swap flow with Uniswap v4
- **Edge cases**: Zero price, extreme volatility, reentrancy
- **Security tests**: Access control, parameter validation

### Running Tests

```bash
# All tests
forge test

# Specific test
forge test --match-test test_CalculateAmortizedPrice

# Fork tests
forge test --fork-url $RPC_URL
```

---

## 📊 Expected Results

### Metrics

- **LVR Reduction**: 20-40% in volatile pairs (estimated)
- **Dynamic Fee**: 5 bps (base) → 15-20 bps (high volatility)
- **Gas Cost**: <100k gas per swap (target)

### Use Cases

1. **Volatile Pair (ETH/USDC)**
   - Hook detects large price jump
   - Applies price smoothing
   - Increases fee based on volatility
   - LP suffers less LVR

2. **Stable Pair**
   - Hook detects small change
   - No smoothing applied
   - Fee stays at baseFee
   - Normal behavior

---

## 🔒 Security

- ✅ Input validation on all configuration functions
- ✅ Access control (onlyOwner) for parameter updates
- ✅ Reentrancy protection
- ✅ Edge case handling
- ✅ Comprehensive test coverage

---

## 📚 Documentation

- **Internal Docs**: See `docs-internos/` for detailed architecture and roadmap
- **Project Context**: See `.cursor/project-context.md` for technical details
- **Uniswap v4 Docs**: [docs.uniswap.org](https://docs.uniswap.org/contracts/v4/overview)

---

## 🛠️ Tech Stack

- **Solidity**: ^0.8.0
- **Foundry**: Testing and deployment
- **Uniswap v4**: Official hook template
- **Testnet**: Sepolia or Base Sepolia

---

## 📝 Project Structure

```
.
├── src/
│   └── AntiLVRHook.sol          # Main hook contract
├── test/
│   ├── AntiLVRHook.t.sol        # Unit tests
│   └── integration/             # Integration tests
├── script/
│   └── deploy/
│       └── DeployAntiLVRHook.s.sol
├── docs-internos/               # Internal documentation
└── README.md                    # This file
```

---

## 🎯 Hackathon Submission

**Event**: ETHGlobal Buenos Aires (Nov 2025)  
**Track**: Track 2 - Volatile-Pairs Hooks ($10,000 prize pool)  
**Organizer**: Uniswap Foundation

### Deliverables

- ✅ TxIDs of transactions (testnet/mainnet)
- ✅ Public GitHub repository
- ✅ Complete README.md
- ✅ Functional demo or installation instructions
- ✅ Demo video (max 3 minutes, English with subtitles)

---

## 🤝 Contributing

This is a hackathon project. Contributions and feedback are welcome!

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Uniswap Foundation](https://www.uniswapfoundation.org/) for the v4 template and hackathon
- [ETHGlobal](https://ethglobal.com/) for organizing the event
- Uniswap v4 community for documentation and resources

---

## 📞 Contact

For questions or feedback, please open an issue in the repository.

---

**Built with ❤️ for ETHGlobal Buenos Aires 2025**

