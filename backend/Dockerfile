FROM node:20-alpine

WORKDIR /app

# Install build dependencies needed for bcrypt
RUN apk add --no-cache python3 make g++

# Install dependencies
COPY package*.json ./
RUN npm install

# Rebuild bcrypt for Alpine Linux
RUN npm rebuild bcrypt --build-from-source

# Copy source
COPY . .

# Build
RUN npm run build

# Health check dependencies
RUN apk add --no-cache curl

EXPOSE 3000

CMD ["npm", "run", "start:dev"]
