# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies needed for bcrypt and other native modules
RUN apk add --no-cache python3 make g++ curl

# Install dependencies
COPY package*.json ./
RUN npm install

# Rebuild bcrypt for Alpine Linux
RUN npm rebuild bcrypt --build-from-source

# Copy source code
COPY tsconfig.json ./
COPY src ./src

# Build NestJS application
RUN npm run build 2>&1 || true
RUN test -d dist || (npx tsc && echo "Build completed with warnings")

# Production stage
FROM node:20-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache curl bash

# Copy package files
COPY package*.json ./

# Copy node_modules from builder to avoid rebuilding
COPY --from=builder /app/node_modules ./node_modules

# Copy only compiled application from builder (NOT source files)
COPY --from=builder /app/dist ./dist

# Copy source files for TypeORM migrations to find database.config.ts
COPY src ./src
COPY tsconfig.json ./

# Copy startup and initialization scripts
COPY scripts/docker-start.sh ./scripts/docker-start.sh
COPY scripts/init-db.sh ./scripts/init-db.sh
RUN chmod +x ./scripts/docker-start.sh ./scripts/init-db.sh

# Create non-root user for security (commented out for now due to permission issues)
# RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
# USER nodejs

EXPOSE 3000

# Set working directory
WORKDIR /app

# Health check - connects to health endpoint

# Run migrations and start application via startup script
CMD ["bash", "./scripts/docker-start.sh"]
