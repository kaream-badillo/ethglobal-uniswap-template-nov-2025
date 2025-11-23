# 🚀 Demo Setup Instructions - AntiSandwichHook

**Step-by-step guide to run the functional demo of the Anti-Sandwich Hook**

This demo shows how the hook detects sandwich attack patterns and applies dynamic fees based on `deltaTick`.

---

## 📋 Prerequisites

### Required Software

1. **Foundry** (stable version)
   ```bash
   # Install Foundry
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   
   # Verify installation
   forge --version
   cast --version
   ```

2. **Git**
   ```bash
   git --version
   ```

3. **Node.js** (optional, for some tools)
   ```bash
   node --version
   ```

### Account and Access

- **RPC URL** for testnet (Infura or Alchemy)
  - Sepolia: `https://sepolia.infura.io/v3/YOUR_KEY` or `https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY`
  - See `docs-internos/VARIABLES-ENTORNO.md` for more details (internal doc)

---

## 🔧 Installation

### 1. Clone the Repository

```bash
git clone <YOUR_REPO_URL>
cd ethglobal-uniswap-template-nov-2025
```

### 2. Install Dependencies

```bash
# Install Foundry dependencies
forge install

# Verify everything compiles
forge build
```

### 3. Configure Environment Variables (Optional)

If you want to run the demo on a testnet fork:

```bash
# Create .env file (if it doesn't exist)
cp .env.example .env

# Edit .env and add:
RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
```

**Note:** The demo can run without `.env` by using `--fork-url` directly.

---

## 🎬 Run the Demo

### Option 1: Local Demo (Simulation)

Run the demo script without needing RPC:

```bash
forge script script/demo/DemoAntiSandwichHook.s.sol
```

**Expected output:**
- Deployed hook information
- Fee comparison in different scenarios
- deltaTick metrics and applied fees

### Option 2: Testnet Fork Demo (Recommended)

Run the demo using Sepolia fork to see the deployed hook:

```bash
# With RPC_URL in .env
forge script script/demo/DemoAntiSandwichHook.s.sol \
  --fork-url $RPC_URL

# Or directly
forge script script/demo/DemoAntiSandwichHook.s.sol \
  --fork-url https://sepolia.infura.io/v3/YOUR_INFURA_KEY
```

**Windows PowerShell:**
```powershell
$env:RPC_URL = "https://sepolia.infura.io/v3/YOUR_KEY"
forge script script/demo/DemoAntiSandwichHook.s.sol --fork-url $env:RPC_URL
```

---

## 📊 What the Demo Shows

The demo runs **3 scenarios** that demonstrate how the hook works:

### Scenario 1: Normal Swap (Low Risk)
- **DeltaTick:** ≈ 0
- **Applied Fee:** 5 bps (baseFee)
- **Interpretation:** Normal swap in stable pair, no sandwich risk

### Scenario 2: Risky Swap (Medium Risk)
- **DeltaTick:** 3
- **Applied Fee:** Calculated with quadratic formula
- **Interpretation:** Possible sandwich pattern, fee increases

### Scenario 3: Very Risky Swap (High Risk)
- **DeltaTick:** ≥ 4
- **Applied Fee:** 60 bps (maxFee)
- **Interpretation:** Clear sandwich pattern, maximum protection

### Demo Output

The script shows:
- ✅ Deployed hook address
- ✅ Pool configuration
- ✅ deltaTick calculation
- ✅ Applied fee formula
- ✅ Comparison between scenarios
- ✅ Key metrics for judges

---

## 🔍 Understanding the Output

### Hook Information

```
Hook Address: 0x5AebB929DA77cCDFE141CeB2Af210FaA3905c0c0
PoolManager: 0xE03A1074c86CFeDd5C142C4F04F1a1536e203543
Chain ID: 11155111
```

### Fee Comparison

```
Normal Swap (deltaTick ≈ 0):
  Fee: 5 bps (baseFee)
  Risk: Low - Normal trading

Risky Swap (deltaTick = 3):
  Fee: [calculated] bps
  Risk: Medium - Possible sandwich attack
  Protection: Fee increases quadratically

Very Risky Swap (deltaTick ≥ 4):
  Fee: 60 bps (maxFee)
  Risk: High - Strong sandwich attack pattern
  Protection: Maximum fee applied
```

### Applied Formula

```
Formula: fee = baseFee + k1*deltaTick + k2*deltaTick²
Calculation:
  baseFee: 5 bps
  k1*deltaTick: [calculated] bps
  k2*deltaTick²: [calculated] bps
  Total Fee: [total] bps
```

---

## 🐛 Troubleshooting

### Error: "Hook address not found"

**Solution:** Verify that the hook is deployed on the correct network. The demo uses the hook deployed on Sepolia (`0x5AebB929DA77cCDFE141CeB2Af210FaA3905c0c0`).

### Error: "PoolManager not found"

**Solution:** PoolManager is auto-detected from `chainId`. Verify you're using Sepolia (chainId: 11155111).

### Error: "RPC URL not accessible"

**Solution:**
1. Verify your RPC URL is correct
2. Verify you have internet access
3. Try another RPC provider (Alchemy if using Infura, or vice versa)

### Error: "Compilation failed"

**Solution:**
```bash
# Clean cache
forge clean

# Reinstall dependencies
forge install

# Recompile
forge build
```

### Demo doesn't show output

**Solution:** Make sure to use `--fork-url` if you want to see real data from the deployed hook. Without fork, the demo shows simulated calculations.

---

## 📚 Additional Resources

- **Deployed Hook:** [Etherscan Sepolia](https://sepolia.etherscan.io/address/0x5AebB929DA77cCDFE141CeB2Af210FaA3905c0c0)
- **Complete Documentation:** See `README.md`
- **Technical Architecture:** See `docs/TECHNICAL-ARCHITECTURE.md`

---

## ✅ Verification Checklist

Before considering the demo successful, verify:

- [ ] Foundry installed and working
- [ ] Dependencies installed (`forge install`)
- [ ] Script compiles without errors (`forge build`)
- [ ] Demo runs correctly
- [ ] Output shows the 3 scenarios
- [ ] Fees are calculated correctly
- [ ] Comparison between scenarios is clear

---

## 🎯 Next Steps

After running the demo:

1. **Review the code:** See `script/demo/DemoAntiSandwichHook.s.sol`
2. **Run tests:** `forge test` to see complete tests
3. **Check deployment:** Review deployment information in README
4. **Prepare video demo:** Use this output for the 3-minute video

---

**Last updated:** 2025-01-XX
