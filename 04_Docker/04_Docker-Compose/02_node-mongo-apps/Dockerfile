# Use official Node.js image
FROM node

# Environment variables
ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PASSWORD=qwerty

# Create app directory
WORKDIR /dockerizing-node-app

# Copy project files
COPY . .

# Install dependencies
RUN npm install

# Expose application port
EXPOSE 5050

# Start application
CMD ["node", "server.js"]
