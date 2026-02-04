FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build
RUN npm run build

# Health check dependencies
RUN apk add --no-cache curl

EXPOSE 3000

CMD ["npm", "run", "start:dev"]
