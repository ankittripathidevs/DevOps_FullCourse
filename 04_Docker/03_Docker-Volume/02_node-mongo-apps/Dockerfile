# 1. Use Node.js official Alpine image
FROM node:22-alpine

# 2. Set working directory
WORKDIR /app

# 3. Copy package files
COPY package*.json ./

# 4. Install dependencies
RUN npm install

# 5. Copy application code
COPY . .

# 6. Expose Node.js application port
EXPOSE 5050

# 7. Start the application
CMD ["node", "server.js"]
