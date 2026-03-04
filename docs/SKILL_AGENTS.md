# Skill Agents & GitHub Automation Setup Guide

## Overview

This guide describes the skill agents and GitHub automation configured for automatic codebase improvement and quality assurance.

---

## 🤖 Skill Agents

### 1. Smart Contract Security Agent
**Purpose:** Automated security analysis of smart contracts

**Triggers:**
- Changes to files in `blockchain/contracts/`
- Manual trigger on demand

**What it does:**
- ✓ Compiles Solidity contracts
- ✓ Runs Slither security scanner
- ✓ Checks contract sizes
- ✓ Generates gas reports
- ✓ Validates IBFT2/Clique configurations

**Output:**
- Gas consumption per function
- Security vulnerability report
- Contract size analysis

**How to use:**
```bash
# Manually trigger
bash scripts/analyze-contracts.sh

# View results
cat gas-report.txt
```

---

### 2. Backend Quality Agent
**Purpose:** Continuous quality monitoring of Node.js backend

**Triggers:**
- Changes to files in `backend/src/`
- Pull requests to backend code

**What it does:**
- ✓ TypeScript compilation check
- ✓ ESLint code style analysis
- ✓ NPM dependency audit
- ✓ Unit test execution
- ✓ Docker image building

**Coverage Requirements:**
- Minimum 80% code coverage
- All new code must have tests

**How to use:**
```bash
# Local testing before push
npm run lint --prefix backend
npm test --prefix backend
npm run build --prefix backend
```

---

### 3. Integration Validator Agent
**Purpose:** Validate blockchain-API-IPFS integration

**Triggers:**
- Changes to blockchain or backend
- Scheduled daily run

**What it does:**
- ✓ Tests Besu RPC connectivity
- ✓ IPFS API validation
- ✓ Contract deployment testing
- ✓ Transaction finality checks
- ✓ Gateway availability

**Endpoints tested:**
```
Besu RPC:        http://localhost:8545
WebSocket:       ws://localhost:8546
IPFS API:        http://localhost:5001
IPFS Gateway:    http://localhost:8888
```

**How to use:**
```bash
# Run integration tests
npm run test:integration --prefix backend
```

---

### 4. Security Scanner Agent
**Purpose:** Comprehensive security vulnerability detection

**Triggers:**
- Before each release
- On dependency updates
- Weekly scheduled scan

**What it does:**
- ✓ Dependency vulnerability scan (npm audit)
- ✓ Secret detection (prevent hardcoded keys)
- ✓ SAST analysis (code vulnerabilities)
- ✓ Container image scanning
- ✓ Configuration validation

**Report includes:**
- High/Medium/Low severity issues
- Remediation suggestions
- Patch availability

**How to use:**
```bash
# Manual security audit
npm audit --prefix backend
npm audit --prefix blockchain

# Check for hardcoded secrets
grep -r "PRIVATE_KEY\|SECRET\|PASSWORD" . --exclude-dir=node_modules
```

---

### 5. Performance Profiler Agent
**Purpose:** Track and optimize performance metrics

**Triggers:**
- After test runs
- On deployment
- Weekly performance analysis

**What it does:**
- ✓ Gas usage tracking per function
- ✓ API response time analysis
- ✓ IPFS operation benchmarks
- ✓ Database query performance
- ✓ Memory leak detection

**Metrics tracked:**
| Metric | Target | Alert if > |
|--------|--------|-----------|
| Contract deployment | 2M gas | 2.5M |
| Record registration | 150K gas | 200K |
| API response time | 200ms | 500ms |
| IPFS upload | 5s | 10s |
| Memory usage | 500MB | 800MB |

**How to use:**
```bash
# Generate detailed performance report
REPORT_GAS=true npm test --prefix blockchain
npm run profile --prefix backend
```

---

## 🔄 GitHub Actions Workflows

### CI Blockchain (`ci-blockchain.yml`)
```yaml
on:
  push:
    branches: [main, develop]
    paths: [blockchain/**]
  pull_request:
    branches: [main, develop]
    paths: [blockchain/**]
```

**Jobs:**
1. `test-contracts` - Compile and test smart contracts
2. `security-audit` - Run Slither analysis
3. `code-quality` - Lint and format checks

---

### CI Backend (`ci-backend.yml`)
```yaml
on:
  push:
    branches: [main, develop]
    paths: [backend/**]
  pull_request:
    branches: [main, develop]
    paths: [backend/**]
```

**Jobs:**
1. `lint-and-test` - Code quality and unit tests
2. `docker-build` - Build Docker image
3. `security-scan` - Dependency and code scanning

---

## ✅ Pre-commit Hooks

Automatic checks before committing code:

```bash
# Install hooks
bash scripts/setup-dev-env.sh

# Hooks will auto-run on git commit
git commit -m "feat: new feature"
```

**What gets checked:**
- ✓ Trailing whitespace
- ✓ File endings
- ✓ YAML syntax
- ✓ JSON validity
- ✓ Code formatting (Prettier)
- ✓ Smart contract compilation

---

## 📋 Code Review Agents

### Automated Review Checklist
GitHub bot automatically checks:
- ✓ PR description completeness
- ✓ Commit message format
- ✓ Test coverage maintenance
- ✓ No breaking changes
- ✓ Documentation updates

### Required Reviews
- [ ] Code quality CI passes
- [ ] Security scan passes
- [ ] At least 1 human approves
- [ ] All conversations resolved

---

## 🚀 Using the Automation

### For Feature Development
```bash
# 1. Create feature branch
git checkout -b feat/new-feature

# 2. Make changes and commit
git add .
git commit -m "feat(blockchain): add new feature"

# 3. Pre-commit hooks run automatically
# 4. Push to GitHub
git push origin feat/new-feature

# 5. GitHub Actions run automatically
# 6. Create Pull Request
# 7. AI agents review code automatically
# 8. Fix any issues found
# 9. Merge when all checks pass
```

### For Bug Fixes
```bash
git checkout -b fix/bug-description
git commit -m "fix(backend): resolve api timeout issue"
git push origin fix/bug-description
```

### For Documentation
```bash
git checkout -b docs/update-readme
git commit -m "docs: add deployment guide"
git push origin docs/update-readme
```

---

## 📊 Monitoring Agents

### View Workflow Results
1. Go to **GitHub Actions** tab
2. Select workflow (ci-blockchain, ci-backend)
3. Click on run to see details
4. Check individual job logs

### View Code Quality
1. **Codecov** integration (after setup)
2. **Report artifacts** in Actions
3. **Pull request comments** with results

### View Security Reports
1. **GitHub Security** tab
2. **Dependabot alerts** (if enabled)
3. **Security scan artifacts**

---

## 🔧 Troubleshooting

### CI Failing?
1. Check workflow logs in GitHub Actions
2. Run local checks: `bash scripts/code-quality.sh`
3. Fix issues locally before pushing
4. Ensure pre-commit hooks are installed

### Agent Not Triggering?
1. Check file paths match workflow `paths` filter
2. Verify branch is `main` or `develop`
3. Manually trigger workflow if needed
4. Check logs for errors

### Performance Issues?
1. Review Performance Profiler report
2. Optimize gas-heavy functions
3. Cache dependencies in CI
4. Use incremental builds

---

## 📚 Documentation

### Developer Guides
- [Development Guidelines](./DEVELOPMENT.md)
- [Testing Standards](./TESTING.md)
- [Code Quality Tools](./CODE_QUALITY.md)

### Setup Scripts
- `bash scripts/setup-dev-env.sh` - Initialize dev environment
- `bash scripts/analyze-contracts.sh` - Analyze smart contracts
- `bash scripts/code-quality.sh` - Full codebase analysis

---

## 🎯 Next Steps

1. **Install Developer Tools**
   ```bash
   bash scripts/setup-dev-env.sh
   ```

2. **Review Guidelines**
   - Read [DEVELOPMENT.md](./DEVELOPMENT.md)
   - Review commit message standards
   - Understand testing requirements

3. **Make Your First Contribution**
   - Create feature branch
   - Make changes
   - Ensure all checks pass
   - Create pull request

4. **Monitor Quality**
   - Watch GitHub Actions runs
   - Review agent reports
   - Fix issues found

---

**Last Updated:** March 4, 2026
**Maintained by:** Development Team
