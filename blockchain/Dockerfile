# ============================================================
# REPO: blockchain — Hardhat 1 node + IPFS (kubo) dalam 1 container.
# Base = Debian (node:20-slim) karena binary kubo dynamic-linked glibc
# (tidak jalan di alpine/musl). Builder & production harus sama libc agar
# native module Hardhat cocok.
# ============================================================

# Build stage
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run compile

# Production stage — Hardhat node + IPFS (kubo).
FROM node:20-slim
WORKDIR /app

# ca-certificates untuk kubo.
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Binary IPFS (kubo) dari image resmi (glibc -> cocok dengan Debian).
COPY --from=ipfs/kubo:latest /usr/local/bin/ipfs /usr/local/bin/ipfs

# IPFS menyimpan repo di sini (dimiliki user node).
ENV IPFS_PATH=/app/.ipfs

# Reuse dependencies & artefak dari builder.
COPY package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/artifacts ./artifacts
COPY --from=builder /app/cache ./cache
COPY contracts ./contracts
COPY hardhat.config.js ./hardhat.config.js
COPY scripts ./scripts

RUN chmod +x ./scripts/docker-entrypoint.sh

# node:20-slim sudah punya user non-root "node".
RUN chown -R node:node /app
USER node

EXPOSE 8545 8546 5001 8080

# Start IPFS daemon + Hardhat node + auto-deploy contracts on boot.
CMD ["sh", "./scripts/docker-entrypoint.sh"]
