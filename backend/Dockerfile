# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies needed for bcrypt
RUN apk add --no-cache python3 make g++

# Install dependencies
COPY package*.json ./
RUN npm ci

# Rebuild bcrypt for Alpine Linux
RUN npm rebuild bcrypt --build-from-source

# Copy source
COPY . .

# Build
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache curl

# Install production dependencies only
COPY package*.json ./
RUN npm ci --only=production

# Rebuild bcrypt for production  
RUN npm rebuild bcrypt --build-from-source

# Copy built application from builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src ./src

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["node", "dist/main"]
