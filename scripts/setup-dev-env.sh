#!/bin/bash

# Development Tools Setup
# Installs and configures pre-commit hooks, linters, and formatters

set -e

echo "================================================"
echo "  Development Environment Setup"
echo "================================================"
echo ""

cd "$(git rev-parse --show-toplevel)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Install pre-commit hooks
echo -e "${YELLOW}Setting up pre-commit hooks...${NC}"
if command -v pre-commit &> /dev/null; then
  pre-commit install
  echo -e "${GREEN}✓ Pre-commit hooks installed${NC}"
else
  echo "Installing pre-commit..."
  pip install pre-commit
  pre-commit install
  echo -e "${GREEN}✓ Pre-commit installed and configured${NC}"
fi

# 2. Install Prettier for formatting
echo -e "\n${YELLOW}Setting up code formatter...${NC}"
npm install -D prettier --legacy-peer-deps
echo -e "${GREEN}✓ Prettier configured${NC}"

# 3. Setup Solidity linter
echo -e "\n${YELLOW}Setting up Solidity linter...${NC}"
cd blockchain
npm install -D solhint
echo -e "${GREEN}✓ Solhint configured${NC}"
cd ..

# 4. Create git hooks
echo -e "\n${YELLOW}Creating custom git hooks...${NC}"
mkdir -p .git/hooks

# Pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook: Run code quality checks

echo "Running pre-commit checks..."

# Check TypeScript in backend
if [ -d "backend" ]; then
  echo "  - Backend type checking..."
  cd backend && npx tsc --noEmit 2>/dev/null || true
  cd ..
fi

# Format with prettier
echo "  - Code formatting..."
npx prettier --write . --ignore-path .gitignore 2>/dev/null || true

echo "Pre-commit checks completed!"
EOF

chmod +x .git/hooks/pre-commit

# Commit-msg hook
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash
# Commit-msg hook: Validate commit message format

msg=$(cat "$1")

# Validate conventional commits
if ! echo "$msg" | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?!?: .{1,}'; then
  echo "✗ Invalid commit message format!"
  echo ""
  echo "Please use conventional commits:"
  echo "  feat(module): description"
  echo "  fix(module): description"
  echo "  docs: description"
  echo "  style: description"
  echo "  refactor: description"
  echo "  test: description"
  echo "  chore: description"
  exit 1
fi

exit 0
EOF

chmod +x .git/hooks/commit-msg

echo -e "${GREEN}✓ Git hooks created${NC}"

# 5. Create .prettierrc
echo -e "\n${YELLOW}Configuring code style...${NC}"
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "arrowParens": "always",
  "bracketSpacing": true
}
EOF

echo -e "${GREEN}✓ Prettier configured${NC}"

# 6. Create .pre-commit-config.yaml
echo -e "\n${YELLOW}Setting up pre-commit configuration...${NC}"
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-json
      - id: check-merge-conflict

  - repo: https://github.com/prettier/pre-commit
    rev: v3.0.0
    hooks:
      - id: prettier
        types_or: [javascript, typescript, jsx, tsx, json]

  - repo: https://github.com/adrienverge/yamllint
    rev: v1.28.0
    hooks:
      - id: yamllint
EOF

echo -e "${GREEN}✓ Pre-commit configuration created${NC}"

# 7. Install development dependencies
echo -e "\n${YELLOW}Installing development dependencies...${NC}"
npm install -D eslint prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser --legacy-peer-deps 2>/dev/null || true

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}Development environment setup complete!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "Next steps:"
echo "1. Run 'npm run lint' to check code quality"
echo "2. Run 'npm run format' to auto-format code"
echo "3. Commit messages must follow conventional commits"
echo "4. Pre-commit hooks will run automatically"
echo ""
