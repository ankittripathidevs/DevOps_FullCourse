# 1. Use official Node.js image
FROM node

# 2. Env variables (not secure, but ok for learning)
ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PASSWORD=qwerty

# 3. Create folder inside container
RUN mkdir -p dockerizing-node-app

# 4. Copy project to container
COPY . /dockerizing-node-app

# 5. Start the app
CMD ["node", "/dockerizing-node-app/server.js"]