# Use official Node.js image
FROM node:18

# Create app directory inside the container
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Expose the port
EXPOSE 3000

# Start the app
CMD ["node", "server.js"]