# 1. Use Node.js official Alpine image
FROM node:22-alpine

# 2. Set working directory
WORKDIR /app

# 3. Install curl for Docker container healthcheck
RUN apk add --no-cache curl

# 4. Copy package files
COPY package*.json ./

# 5. Install dependencies
RUN npm install

# 6. Copy application code
COPY . .

# 7. Expose Node.js application port
EXPOSE 5050

# 8. Start the application
CMD ["node", "server.js"]
