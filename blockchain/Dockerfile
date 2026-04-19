# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Compile Hardhat contracts
RUN npm run compile

# Production stage
FROM node:20-alpine

WORKDIR /app

# Reuse installed dependencies from builder
COPY package*.json ./
COPY --from=builder /app/node_modules ./node_modules

# Copy compiled contracts and scripts from builder
COPY --from=builder /app/artifacts ./artifacts
COPY --from=builder /app/cache ./cache
COPY contracts ./contracts
COPY hardhat.config.js ./hardhat.config.js
COPY scripts ./scripts

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
RUN chown -R nodejs:nodejs /app
USER nodejs

EXPOSE 8545 8546

# Default command to run Hardhat node
CMD ["npx", "hardhat", "node", "--hostname", "0.0.0.0"]
