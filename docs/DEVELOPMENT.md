# Blockchain Lamtek - Development Guidelines

## Quick Start

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Git

### Setup Development Environment

```bash
# Clone repository
git clone https://github.com/D4marp/Blockchain_lamtek.git
cd Saas_Blockchain_Lamtek

# Setup development tools
bash scripts/setup-dev-env.sh

# Start blockchain and services
docker-compose up -d besu-node1 besu-node2 ipfs-node

# Install dependencies
npm install --prefix backend
npm install --prefix blockchain

# Run tests
npm test --prefix blockchain
```

---

## Code Style & Standards

### Commit Message Format
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/modifications
- `chore`: Maintenance tasks

**Examples:**
```
feat(blockchain): add akreditasi contract
fix(ipfs): resolve gateway timeout issue
docs(api): update endpoint documentation
```

### TypeScript/JavaScript
- Use TypeScript for backend code
- Configure ESLint and Prettier
- Run `npm run lint` before committing
- Type annotate all function parameters

```typescript
// ✓ Good
async function deployContract(address: string): Promise<ContractDeployment> {
  const result = await contract.deploy();
  return result;
}

// ✗ Bad
async function deployContract(address) {
  return await contract.deploy();
}
```

### Smart Contracts (Solidity)
- Use Solidity ^0.8.0
- Follow [OpenZeppelin](https://docs.openzeppelin.com/) best practices
- Add NatSpec comments
- Test all public functions

```solidity
// ✓ Good
/// @notice Deploy new akreditasi record
/// @param _accreditationId Unique accreditation identifier
/// @param _data Accreditation data URI
/// @return Hash of the transaction
function registerAkreditasi(
    string calldata _accreditationId,
    string calldata _data
) external returns (bytes32) {
    // Implementation
}

// ✗ Bad
function register(string memory id, string memory data) public {
    // Unclear parameters and no documentation
}
```

---

## Testing Standards

### Unit Tests
```bash
# Backend tests
npm test --prefix backend

# Smart contract tests
npm test --prefix blockchain
```

**Coverage Requirements:**
- Minimum 80% code coverage
- All public functions must have test cases
- Test edge cases and error conditions

### Integration Tests
```bash
# Test blockchain interaction with IPFS
npm run test:integration --prefix backend
```

### Gas Optimization
```bash
# Generate gas report
npm run report:gas --prefix blockchain
```

---

## Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feat/feature-name
   ```

2. **Make Changes**
   - Follow code style guidelines
   - Add tests for new functionality
   - Update documentation

3. **Pre-Submission Checks**
   ```bash
   npm run lint
   npm run type-check
   npm test
   bash scripts/code-quality.sh
   ```

4. **Push and Create PR**
   ```bash
   git push origin feat/feature-name
   ```

5. **PR Checklist** (auto-generated)
   - Code review approved
   - Tests passing
   - No breaking changes
   - Documentation updated

---

## Smart Contract Deployment

### Local Development
```bash
npm run deploy:local --prefix blockchain
```

### Testnet
```bash
npm run deploy --prefix blockchain
```

Environment variables needed:
```
BESU_RPC_URL=http://localhost:8545
PRIVATE_KEY=your_private_key
```

---

## Common Tasks

### Add New Smart Contract
1. Create file: `blockchain/contracts/NewContract.sol`
2. Implement contract with NatSpec comments
3. Add tests: `blockchain/test/NewContract.test.js`
4. Generate deployment script
5. Update deployment documentation

### Add New API Endpoint
1. Create service: `backend/src/services/NewService.ts`
2. Create controller: `backend/src/controllers/NewController.ts`
3. Create routes: `backend/src/routes/new.routes.ts`
4. Add tests: `backend/test/new.test.ts`
5. Document in API.md

### Debug Blockchain
```bash
# View Besu logs
docker-compose logs -f besu-node1

# Connect to Besu console
npm run console --prefix blockchain

# Test RPC endpoint
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

---

## Documentation

### Code Comments
- Use clear, concise English
- Explain WHY, not WHAT
- Add examples for complex logic

```typescript
// ✓ Good
// Retry with exponential backoff to handle temporary network issues
// e.g., service may be temporarily unavailable
async function retryWithBackoff(fn, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    const delay = Math.pow(2, i) * 1000; // 1s, 2s, 4s
    // ...
  }
}

// ✗ Bad
// Retry the function
function retry(fn, maxRetries) {
  // ...
}
```

### API Documentation
- Update `/docs/API.md` when changing endpoints
- Include request/response examples
- Document error cases

### README Files
- Keep updated with latest changes
- Include setup instructions
- Link to relevant documentation

---

## Performance & Security

### Code Review Checklist
- [ ] No hardcoded secrets or private keys
- [ ] Input validation on all endpoints
- [ ] Error handling for all async operations
- [ ] No SQL injection vulnerabilities
- [ ] CORS properly configured
- [ ] Rate limiting implemented
- [ ] Logging doesn't expose sensitive data

### Smart Contract Security
- [ ] Use OpenZeppelin audited libraries
- [ ] No reentrancy vulnerabilities
- [ ] Check-effects-interactions pattern
- [ ] Proper access control
- [ ] No integer overflow/underflow
- [ ] Events logged for important actions

### Blockchain Best Practices
- [ ] Genesis configuration validated
- [ ] Network connectivity tested
- [ ] Backup and recovery tested
- [ ] Monitoring alerts configured
- [ ] Transaction finality verified

---

## Troubleshooting

### Container Issues
```bash
# Restart all services
docker-compose restart

# View container logs
docker-compose logs -f [service-name]

# Reset blockchain (WARNING: clears data)
rm -rf blockchain/besu/node*/data/*
docker-compose restart besu-node1
```

### Development Issues
```bash
# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Rebuild TypeScript
npm run build
```

---

## Resources

- [Besu Documentation](https://besu.hyperledger.org/)
- [IPFS Documentation](https://docs.ipfs.io/)
- [OpenZeppelin Docs](https://docs.openzeppelin.com/)
- [Hardhat Docs](https://hardhat.org/)
- [Solidity Best Practices](https://docs.soliditylang.org/)

---

## Support & Questions

- GitHub Issues: Report bugs and request features
- Code Reviews: Ask questions during PR review
- Documentation: Check existing docs first
- Community: Join development discussions

---

**Last Updated:** March 4, 2026
