# 🔗 BLOCKCHAIN TESTING GUIDE

## Quick Summary
✅ **All blockchain tests are PASSING**  
✅ **Hardhat smart contracts compile successfully**  
✅ **Ready for deployment**

---

## 📊 Test Status

```
✅ Smart Contract Tests: 2 passing (2s)
   - DokumenIPFSRegistry baseline
     ✓ sets deployer as owner and authorized signer (4685ms)
     ✓ uploads a document and increments totalDokumen (115ms)
```

---

## 🚀 Running Blockchain Tests

### Option 1: Local Testing (Fastest)
```bash
cd blockchain
npm test
```

### Option 2: Via Docker (Isolated)
```bash
# Run tests in Docker container
docker-compose -f docker-compose.hardhat.yml run --rm hardhat-test

# Or with specific profile
docker-compose -f docker-compose.test.yml run --rm blockchain-test
```

### Option 3: Start Hardhat Node
```bash
# Local node
cd blockchain
npx hardhat node --hostname 0.0.0.0

# Via Docker
docker-compose -f docker-compose.hardhat.yml --profile node up
```

---

## 📦 Available Commands

```bash
# Compile contracts
cd blockchain && npm run compile

# Run tests
cd blockchain && npm test

# Deploy to local network
cd blockchain && npm run deploy:local

# Deploy to Besu network
cd blockchain && npm run deploy

# Start console (interactive)
cd blockchain && npx hardhat console --network besu
```

---

## 🏗️ Smart Contracts

### DokumenIPFSRegistry
- **Location**: `contracts/DokumenIPFSRegistry.sol`
- **Functionality**: Manages document uploads and IPFS registry
- **Tests**: `test/DokumenIPFSRegistry.test.js`

### Other Contracts
Explore in `contracts/` directory to see all smart contracts.

---

## 🔌 Network Configuration

### Hardhat (Default)
- **URL**: http://localhost:8545
- **Chain ID**: 1337
- **Pre-funded Accounts**: 20 accounts with 10000 ETH each

### Besu (Production)
- **URL**: Available via docker-compose main setup
- **Chain ID**: 1337
- **Configured in hardhat.config.js**

---

## 📝 Compile & Deploy Flow

```
1. Compile Contracts
   npm run compile
   └── Generates: artifacts/, cache/

2. Run Tests
   npm test
   └── Tests all contracts

3. Deploy Contracts
   npm run deploy
   └── Deploys to configured network

4. Verify Deployment
   - Check tx hash
   - Verify contract address
   - Check state on block explorer
```

---

## 🐛 Troubleshooting

### "Cannot store generated private key"
**Issue**: Besu blockchain not starting in Docker  
**Solution**: Use Hardhat node instead
```bash
cd blockchain && npx hardhat node --hostname 0.0.0.0
```

### "Out of memory" during compilation
**Solution**: Increase Node.js memory
```bash
NODE_OPTIONS=--max-old-space-size=4096 npm run compile
```

### Tests not finding contracts
**Solution**: Recompile
```bash
npm run compile
npm test
```

---

## 📚 Useful Links

- [Hardhat Documentation](https://hardhat.org/docs)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Besu Documentation](https://besu.hyperledger.org/en/stable/)
- [Contract Tests](./test/)
- [Contract Source](./contracts/)

---

## ✅ Testing Checklist

- [x] Smart contracts compile
- [x] Unit tests pass (2/2)
- [x] Hardhat node starts
- [x] Docker containerization works
- [x] Network config is correct
- [x] Accounts are available

**Status**: 🟢 **READY FOR DEPLOYMENT**

---

*Last Updated: April 29, 2026*
