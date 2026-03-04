# Smart Contract Testing Configuration

## Test Structure

```
blockchain/test/
├── unit/
│   ├── AkreditasiRegistry.test.js
│   ├── AsesmenKecukupan.test.js
│   ├── AsesmenLapangan.test.js
│   └── DokumenIPFS.test.js
├── integration/
│   ├── blockchain-ipfs.test.js
│   └── contracts-interaction.test.js
└── fixtures/
    └── sample-data.js
```

## Running Tests

```bash
# All tests
npm test

# Specific test file
npm test -- test/unit/AkreditasiRegistry.test.js

# Watch mode
npm test -- --watch

# Coverage report
npm test -- --coverage
```

## Test Template

```javascript
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AkreditasiRegistry", function () {
  let contract;
  let owner, addr1, addr2;

  beforeEach(async function () {
    // Setup
    [owner, addr1, addr2] = await ethers.getSigners();
    const AkreditasiRegistry = await ethers.getContractFactory("AkreditasiRegistry");
    contract = await AkreditasiRegistry.deploy();
    await contract.deployed();
  });

  describe("Deployment", function () {
    it("Should deploy successfully", async function () {
      expect(contract.address).to.not.equal(ethers.constants.AddressZero);
    });
  });

  describe("Core Functions", function () {
    it("Should register akreditasi", async function () {
      const tx = await contract.registerAkreditasi("ACC-001", "ipfs://QmXx");
      expect(tx).to.emit(contract, "AkreditasiRegistered");
    });

    it("Should reject invalid input", async function () {
      await expect(
        contract.registerAkreditasi("", "")
      ).to.be.revertedWith("Invalid input");
    });
  });

  describe("Access Control", function () {
    it("Should revert unauthorized access", async function () {
      await expect(
        contract.connect(addr1).adminFunction()
      ).to.be.revertedWith("Unauthorized");
    });
  });
});
```

## Coverage Goals

| Component | Target Coverage |
|-----------|-----------------|
| AkreditasiRegistry | 95%+ |
| AsesmenKecukupan | 95%+ |
| AsesmenLapangan | 95%+ |
| DokumenIPFSRegistry | 95%+ |
| Overall | 90%+ |

## Gas Optimization Tests

```bash
# Run tests with gas reporter
REPORT_GAS=true npm test
```

Expected gas limits:
- Deploy contract: < 2,000,000
- Register record: < 150,000
- Update record: < 100,000
- Query record: < 50,000

## Continuous Integration

Tests automatically run on:
- Every push to `main` or `develop`
- Every pull request
- Before deployment

See `.github/workflows/ci-blockchain.yml` for configuration.

---

**Last Updated:** March 4, 2026
