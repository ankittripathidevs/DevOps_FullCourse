# Docker Scout

Docker Scout is used to scan Docker images for security vulnerabilities (CVEs).

It helps us check whether the packages inside our Docker image have known security issues.

---

## 1. Docker Scout with Docker Desktop

Docker Scout CLI is already available with Docker Desktop.

### Check Docker Scout

```bash
docker scout version
```

### Check Docker Images

```bash
docker images
```

My Docker Hub image:

```text
ankittripathidocker/two-tier-flask:latest
```

### Scan the Image

```bash
docker scout quickview ankittripathidocker/two-tier-flask:latest
```

### Check Vulnerabilities

```bash
docker scout cves ankittripathidocker/two-tier-flask:latest
```

### Check Recommendations

```bash
docker scout recommendations ankittripathidocker/two-tier-flask:latest
```

---

# 2. Docker Scout on Ubuntu Server

My Ubuntu server project:

```text
node-cicd
```

Ubuntu uses **Docker Engine**, so Docker Scout needs to be installed separately.

### Check Docker Scout

```bash
docker scout version
```

If Scout is not installed:

### Install Docker Scout

```bash
curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh
```

```bash
sh install-scout.sh
```

Verify:

```bash
docker scout version
```

---

## 3. Scan `node-cicd` Docker Image

First check the images:

```bash
docker images
```

Find the image name created by the `node-cicd` project.

Then run:

```bash
docker scout quickview IMAGE_NAME
```

For detailed vulnerabilities:

```bash
docker scout cves IMAGE_NAME
```

For recommendations:

```bash
docker scout recommendations IMAGE_NAME
```

---

# 4. Important Docker Scout Commands

| Command                              | Purpose                  |
| ------------------------------------ | ------------------------ |
| `docker scout version`               | Check Scout installation |
| `docker scout quickview IMAGE`       | Quick security scan      |
| `docker scout cves IMAGE`            | Check vulnerabilities    |
| `docker scout recommendations IMAGE` | Check recommendations    |

---

# 5. Basic Workflow

```text
Docker Image
     ↓
docker scout quickview IMAGE
     ↓
docker scout cves IMAGE
     ↓
Check vulnerabilities
     ↓
Fix Dockerfile/dependencies
     ↓
Build image again
     ↓
Scan again
```

### Docker Desktop Image

```bash
docker scout quickview ankittripathidocker/two-tier-flask:latest
```

```bash
docker scout cves ankittripathidocker/two-tier-flask:latest
```

```bash
docker scout recommendations ankittripathidocker/two-tier-flask:latest
```

### Ubuntu `node-cicd`

```bash
docker images
```

```bash
docker scout quickview IMAGE_NAME
```

```bash
docker scout cves IMAGE_NAME
```

```bash
docker scout recommendations IMAGE_NAME
```

