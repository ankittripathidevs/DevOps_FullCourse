# Dockerizing-Node-App


# Old Dockerfile – Explained Step by Step
```bash
✅ 1. Use official Node.js image
FROM node

- start from an official Node.js image from Docker Hub.

✅ 2. Set Environment Variables
ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PASSWORD=qwerty

- ENV creates environment variables inside the container.

✅ 3. Create a folder inside the container
RUN mkdir -p dockerizing-node-app

- RUN executes a command in the container.
  This creates a folder: /dockerizing-node-app

✅ 4. Copy project files into the container
COPY . /dockerizing-node-app

- . → local project folder
- /dockerizing-node-app → folder inside container

✅ 5. Start the Node.js app
CMD ["node", "/dockerizing-node-app/server.js"]

- This runs server.js when the container starts.




🎯 Summary of Old Dockerfile
Line	              Meaning
FROM node      	Start from official Node.js image
ENV ...        	Set environment variables
RUN mkdir -p	Create directory in container
COPY .       	Copy project
CMD [...]     	Start Node.js server

```

# Best / Recommended Dockerfile (Clean Version)
```bash
FROM node

WORKDIR /dockerizing-node-app

COPY package*.json .
RUN npm install

COPY . .

CMD ["node", "server.js"]

```

# Understanding -t (Tagging)
```bash
 docker build -t dockerizing-node-app:1.0  .

 Breakdown:
Part	                   Meaning
docker build	        Build a Docker image
-t	                    Tag (name + version)
dockerizing-node-app	Image name
1.0                  	Image version
.	                    Build from current folder
```

```bash
✔ Without tag version
docker build -t dockerizing-node-app .
```

# 🚀 How to Build & Run the App
STEP 1 — Build the Image
docker build -t dockerizing-node-app:v1 .

STEP 2 — Run the Container
docker run --name node-container -p 3000:3000 dockerizing-node-app:v1


Breakdown:
--name node-container → container name
-p 3000:3000 → hostPort : containerPort
dockerizing-node-app:v1 → image to run

STEP 3 — Run in Background (Detached Mode)
docker run -d --name node-container -p 3000:3000 dockerizing-node-app:v1

Check containers:
docker ps

Stop container:
docker stop node-container

Remove container:
docker rm node-container


# 📝 Notes
```bash
✔ Running Without Ports

If you don’t need browser access:
docker run --name node-container dockerizing-node-app:v1

Start with bash:
docker run -it dockerizing-node-app:1.0 bash

```bash
📁 Project Structure (Example)
📦 dockerizing-node-app
├── server.js
├── package.json
├── package-lock.json
├── Dockerfile
└── README.md
```

# Instructor 
- Apna College