# 🐳 Docker Registry — Node.js + MongoDB + Mongo Express

Docker Registry allows us to **build the Node.js image once, push it to Docker Hub, and use the same image on another machine/EC2 instance** without rebuilding.

---

## 1. 🔐 Login to Docker Hub

```bash
docker login
```

---

## 2. 🏗️ Build Node.js Image

Build the Node.js application image:

```bash
docker build -t node-mongo-app .
```

Check the image:

```bash
docker images
```

---

## 3. 🏷️ Tag Image for Docker Hub

Docker Hub format:

```text
<username>/<repository>:<tag>
```

Example:

```bash
docker image tag node-mongo-app:latest ankittripathidocker/node-mongo-app:latest
```

Verify:

```bash
docker images
```

You should see:

```text
node-mongo-app
ankittripathidocker/node-mongo-app
```

---

## 4. 📤 Push Image to Docker Hub

```bash
docker push ankittripathidocker/node-mongo-app:latest
```

The Node.js image is now stored in Docker Hub.

---

## 5. 📥 Pull Image on Another Machine

On another EC2/server:

```bash
docker login
```

Then:

```bash
docker pull ankittripathidocker/node-mongo-app:latest
```

Check:

```bash
docker images
```

---

## 6. 🚀 Use Docker Hub Image in Compose

Instead of building locally:

### Before

```yaml
node-app:
  build:
    context: .
```

### After

```yaml
node-app:
  image: ankittripathidocker/node-mongo-app:latest
```

Now Compose uses the image from Docker Hub.

```bash
docker compose up -d
```

If the image isn't available locally, Docker Compose pulls it automatically.

---

## 7. 🗄️ MongoDB Does Not Need to Be Pushed

You **do not push the MongoDB container image that you use**.

Your Compose file can continue using:

```yaml
mongo:
  image: mongo:latest
```

MongoDB's official image is already available from Docker Hub.

The custom image you build and push is your **Node.js application**.

---

## 8. 💾 MongoDB Data

Your MongoDB data uses a bind mount:

```yaml
volumes:
  - ./mongo-database:/data/db
```

The database data stays on the server.

```text
MongoDB container
       ↓
/data/db
       ↓
./mongo-database
```

Pushing the Node.js image to Docker Hub **does not push your MongoDB database data**.

---

## 🔄 Docker Registry Workflow

```text
             Development Machine
                    │
                    ▼
             Build Node Image
                    │
                    ▼
                  Tag
                    │
                    ▼
              Docker Hub
                    │
             ┌──────┴──────┐
             ▼             ▼
          EC2 #1         EC2 #2
             │             │
           Pull          Pull
             │             │
             ▼             ▼
          Node.js        Node.js
             │             │
             └──────┬──────┘
                    ▼
                MongoDB
```

---

## 📌 Important Commands

### Login

```bash
docker login
```

### Build

```bash
docker build -t node-mongo-app .
```

### Tag

```bash
docker tag node-mongo-app:latest ankittripathidocker/node-mongo-app:latest
```

### Push

```bash
docker push ankittripathidocker/node-mongo-app:latest
```

### Pull

```bash
docker pull ankittripathidocker/node-mongo-app:latest
```

### Run Compose

```bash
docker compose up -d
```

### Check Images

```bash
docker images
```

### Check Containers

```bash
docker compose ps
```

---

## 🎯 Key Concept

**Docker Registry = Store and distribute Docker images.**

```text
Build → Tag → Push → Docker Hub → Pull → Run
```

For this project:

```text
Node.js application
       ↓
Docker Image
       ↓
Docker Hub
       ↓
Another EC2
       ↓
docker compose up
```

The advantage is that the deployment server can **pull the pre-built Node.js image instead of building it again**.

