## 🧣 DAY 5 — Docker Registry

#### 1. Login to Docker Hub

First, log in to your Docker account from the terminal:

```bash
docker login
```

You may see:

```text
Authenticating with existing credentials... [Username: ankittripathidocker]
```

This confirms that Docker is using your existing Docker Hub credentials.

---

#### 2. Check Existing Docker Images

List the images available locally:

```bash
docker images
```

Example output:

```text
two-tier-flask-app-flask-app:latest
```

Here:

```text
two-tier-flask-app-flask-app:latest
│                          │
│                          └── Tag
└───────────────────────────── Image name
```

---

#### 3. Tag the Image for Docker Hub

To push an image to Docker Hub, give it a Docker Hub-compatible name:

```bash
docker image tag two-tier-flask-app-flask-app:latest ankittripathidocker/two-tier-backend:latest
```

### Image naming format

```text
<docker-username>/<repository-name>:<tag>
```

For this example:

```text
ankittripathidocker/two-tier-backend:latest
│                 │                 │
│                 │                 └── Tag
│                 └──────────────────── Repository name
└────────────────────────────────────── Docker Hub username
```

#### What changed?

Old/local image:

```text
two-tier-flask-app-flask-app:latest
```

New Docker Hub tag:

```text
ankittripathidocker/two-tier-backend:latest
```

> **Important:** `docker image tag` does not create a second copy of the image's data. It creates another tag/reference pointing to the same image.

---

#### 4. Verify the New Image Tag

Run:

```bash
docker images
```

You should now see something similar to:

```text
ankittripathidocker/two-tier-backend   latest
two-tier-flask-app-flask-app           latest
```

The important image is:

```text
ankittripathidocker/two-tier-backend:latest
```

---

#### 5. Push the Image to Docker Hub

Now push the tagged image:

```bash
docker push ankittripathidocker/two-tier-backend:latest
```

Docker will upload the image layers to your Docker Hub repository.

After a successful push, the image will be available in your Docker Hub account.

---

#### 6. Check the Image on Docker Hub

Open your Docker Hub repositories:

```text
https://hub.docker.com/repositories/ankittripathidocker
```

You should find the repository:

```text
two-tier-backend
```

with the tag:

```text
latest
```

---

#### 7. Pull the Image from Docker Hub

Once the image is available on Docker Hub, you can download it to another machine:

```bash
docker pull ankittripathidocker/two-tier-backend:latest
```

This is useful when deploying the application on another server or EC2 instance.

You do not need to build the image locally if the required image already exists in Docker Hub.

---

## 8. Using the Docker Hub Image in Docker Compose

Previously, the `docker-compose.yml` may build the Flask application locally:

```yaml
flask-app:
  build:
    context: .
```

Here, Docker Compose builds the image using the local Dockerfile and application source code.

Instead, you can use the image that has already been pushed to Docker Hub:

```yaml
flask-app:
  image: ankittripathidocker/two-tier-backend:latest
```

### Before

```yaml
flask-app:
  build:
    context: .
```

### After

```yaml
flask-app:
  image: ankittripathidocker/two-tier-backend:latest
```

Now Docker Compose can pull the image from Docker Hub instead of building it locally.

---

## 9. Important Commands

#### Login

```bash
docker login
```

#### Check images

```bash
docker images
```

#### Tag an image

```bash
docker image tag OLD_IMAGE USERNAME/REPOSITORY:TAG
```

Example:

```bash
docker image tag two-tier-flask-app-flask-app:latest ankittripathidocker/two-tier-backend:latest
```

#### Push image

```bash
docker push ankittripathidocker/two-tier-backend:latest
```

#### Pull image

```bash
docker pull ankittripathidocker/two-tier-backend:latest
```

#### Run Compose using the Docker Hub image

```bash
docker compose up -d
```

---

### 🎯 Key Concept

The main idea of a **Docker Registry** is that you don't have to build your Docker image on every machine.

You can:

1. Build the image once.
2. Tag it with your Docker Hub username and repository.
3. Push it to Docker Hub.
4. Pull it from any machine.
5. Use that image directly in Docker Compose.

This is especially useful for **CI/CD and deployment**, because the server can pull a pre-built image rather than rebuilding the application every time.
