# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Compile Hardhat contracts
RUN npm run build 2>/dev/null || true

# Production stage
FROM node:20-alpine

WORKDIR /app

# Install production dependencies only
COPY package*.json ./
RUN npm ci --only=production

# Copy compiled contracts and scripts from builder
COPY --from=builder /app/artifacts ./artifacts 2>/dev/null || true
COPY --from=builder /app/cache ./cache 2>/dev/null || true
COPY contracts ./contracts
COPY hardhat.config.js ./hardhat.config.js
COPY scripts ./scripts

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs

EXPOSE 8545 8546

# Default command to run Hardhat node
CMD ["npx", "hardhat", "node", "--hostname", "0.0.0.0"]
