# 🐳 Docker Registry — Short Notes

## 1. Login to Docker Hub

```bash
docker login
```

Check existing images:

```bash
docker images
```

---

## 2. Tag Docker Image

Docker Hub image format:

```text
<username>/<repository>:<tag>
```

Example:

```bash
docker image tag two-tier-flask-app-flask-app:latest ankittripathidocker/two-tier-backend:latest
```

> `docker image tag` creates another reference to the same image. It does not duplicate the image.

Check:

```bash
docker images
```

---

## 3. Push Image to Docker Hub

```bash
docker push ankittripathidocker/two-tier-backend:latest
```

Now the image is stored in Docker Hub and can be used from another machine.

---

## 4. Pull Image from Docker Hub

```bash
docker pull ankittripathidocker/two-tier-backend:latest
```

Useful when deploying on another server or EC2 instance.

---

## 5. Use Docker Hub Image in Compose

### Before — Build locally

```yaml
flask-app:
  build:
    context: .
```

### After — Pull from Docker Hub

```yaml
flask-app:
  image: ankittripathidocker/two-tier-backend:latest
```

Then:

```bash
docker compose up -d
```

Docker Compose will use the Docker Hub image instead of building the Flask image locally.

---

## 6. Important Commands

```bash
# Login
docker login

# List images
docker images

# Tag image
docker image tag OLD_IMAGE USERNAME/REPOSITORY:TAG

# Push image
docker push USERNAME/REPOSITORY:TAG

# Pull image
docker pull USERNAME/REPOSITORY:TAG

# Start Compose
docker compose up -d
```

---

## 🎯 Key Concept

**Docker Registry = Store and distribute Docker images.**

```text
Build Image
     ↓
Tag Image
     ↓
Push to Docker Hub
     ↓
Pull from another machine
     ↓
Run Container
```

### Main Benefit

You **build the image once** and can deploy the same image on multiple machines/servers without rebuilding it.

This is especially useful for **CI/CD and deployments**.

