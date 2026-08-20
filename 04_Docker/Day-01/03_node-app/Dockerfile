# 1. Use Node.js official image
FROM node:22-alpine

# 2. Set working directory inside container
WORKDIR /app

# 3. Copy package files first
COPY package*.json ./

# 4. Install dependencies
RUN npm install

# 5. Copy application code
COPY . .

# 6. Expose application port
EXPOSE 3000

# 7. Start the application
CMD ["node", "server.js"]

