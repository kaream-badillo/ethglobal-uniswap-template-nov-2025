# 🚀 Demo Setup Instructions - AntiSandwich Hook

**Step-by-step guide to run the functional demo of the AntiSandwich Hook**

This demo shows how the hook predicts price impact using `deltaTick` before swap execution and applies dynamic fees using a continuous quadratic formula.

**MVP Name:** AntiSandwich Hook  
**Technical Implementation:** AntiSandwichHook (contract name)

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

### Optional: RPC URL for Testnet Fork

**Note:** The demo works **without RPC URL** (simulation mode). RPC URL is only needed if you want to fork Sepolia testnet to interact with the deployed hook.

If you want to use testnet fork, you'll need an RPC URL from:
- **Infura:** `https://sepolia.infura.io/v3/YOUR_INFURA_KEY`
- **Alchemy:** `https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY`
- **Public RPC:** `https://rpc.sepolia.org` (free, but may have rate limits)

**Important:** RPC URL is for blockchain connection, NOT for Etherscan API. Etherscan API key is only needed for contract verification (not required for demo).

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

### 3. Configure RPC URL (Optional - Only for Testnet Fork)

**The demo works without RPC URL!** It runs in simulation mode by default.

If you want to fork Sepolia testnet to interact with the deployed hook, you can pass the RPC URL directly:

**No need to create .env file** - just use `--fork-url` flag directly (see below).

---

## 🎬 Run the Demo

### Option 1: Local Demo (Simulation) - **RECOMMENDED**

Run the demo script **without needing RPC** - works out of the box:

```bash
forge script script/demo/DemoAntiSandwichHook.s.sol
```

**Expected output:**
- Hook address information
- Fee comparison in 3 different scenarios
- deltaTick calculations and applied fees
- Summary with exact values for screenshot

**This is the simplest way** - no configuration needed!

### Option 2: Testnet Fork Demo (Optional)

If you want to interact with the actual deployed hook on Sepolia:

```bash
# Pass RPC URL directly (no .env needed)
forge script script/demo/DemoAntiSandwichHook.s.sol \
  --fork-url https://sepolia.infura.io/v3/YOUR_INFURA_KEY
```

**Or use public RPC (free, no API key needed):**
```bash
forge script script/demo/DemoAntiSandwichHook.s.sol \
  --fork-url https://rpc.sepolia.org
```

**Windows PowerShell:**
```powershell
# Option A: Direct URL (public RPC, no API key needed)
forge script script/demo/DemoAntiSandwichHook.s.sol --fork-url "https://rpc.sepolia.org"

# Option B: With Infura/Alchemy key (if you have one)
forge script script/demo/DemoAntiSandwichHook.s.sol --fork-url "https://sepolia.infura.io/v3/YOUR_KEY"
```

**Important Notes:**
- **Fork mode is optional** - The demo works perfectly in simulation mode (Option 1)
- **No API keys required** - Simulation mode doesn't need RPC URL
- **No .env file needed** - Just run the command directly
- **RPC URL is for blockchain connection** - NOT for Etherscan API (Etherscan API is only for contract verification, not needed for demo)

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
- **DeltaTick:** >= 4 (or deltaTick = 10 in demo)
- **Applied Fee:** 30 bps (for deltaTick=10) or 60 bps (maxFee cap)
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

Very Risky Swap (deltaTick >= 4):
  Fee: 60 bps (maxFee)
  Risk: High - Strong sandwich attack pattern
  Protection: Maximum fee applied
```

### Applied Formula

```
Formula: fee = baseFee + k1*deltaTick + k2*deltaTick^2
Calculation:
  baseFee: 5 bps
  k1*deltaTick: [calculated] bps
  k2*deltaTick^2: [calculated] bps
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

**Solution:** The demo works in simulation mode by default. If you want to see real data from the deployed hook, use `--fork-url` with a Sepolia RPC URL. However, simulation mode is sufficient for demonstrating the hook's functionality.

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
