# 🐳 Docker Scout — Ubuntu Workflow

## 1. 🚀 Run the Docker Compose Application

Go to the project directory:

```bash
cd ~/DevOps_FullCourse/04_Docker/08_Docker-Scout__Docker-Init/01_Docker-Scout/node-todo-cicd
```

Start the application:

```bash
docker compose up -d
```

> Docker Compose will pull the image from Docker Hub if it is not already available locally.

The Compose file uses:

```yaml
image: ankittripathidocker/node-todo-cicd:latest
```

Check the container:

```bash
docker compose ps
```

Or:

```bash
docker ps
```

---

## 2. 🔍 Check the Pulled Docker Image

List local images:

```bash
docker images
```

You should see:

```text
ankittripathidocker/node-todo-cicd
```

The image came from **Docker Hub** and is now available locally on the Ubuntu server.

---

## 3. 🛡️ Scan the Image with Docker Scout

Check Docker Scout:

```bash
docker scout version
```

### Quick Overview

```bash
docker scout quickview ankittripathidocker/node-todo-cicd:latest
```

### Check Vulnerabilities

```bash
docker scout cves ankittripathidocker/node-todo-cicd:latest
```

### Check Recommendations

```bash
docker scout recommendations ankittripathidocker/node-todo-cicd:latest
```

---

## 4. 🔄 Complete Workflow

```text
Docker Desktop
      ↓
Build Node.js Image
      ↓
Push Image to Docker Hub
      ↓
ankittripathidocker/node-todo-cicd:latest
      ↓
Ubuntu EC2
      ↓
docker compose up -d
      ↓
Docker pulls image
      ↓
Container starts
      ↓
Docker Scout scans image
      ↓
Check CVEs & Recommendations
```

---

## 📌 Important Commands

```bash
# Start application
docker compose up -d

# Check container
docker compose ps

# Check images
docker images

# Check Scout
docker scout version

# Quick scan
docker scout quickview ankittripathidocker/node-todo-cicd:latest

# Vulnerabilities
docker scout cves ankittripathidocker/node-todo-cicd:latest

# Recommendations
docker scout recommendations ankittripathidocker/node-todo-cicd:latest
```

### 🎯 Key Concept

The Ubuntu server **does not build the application image**.

It pulls the already-built image from Docker Hub and then Docker Scout scans that same image:

```text
Build → Push → Docker Hub → Pull → Run → Scan
```

