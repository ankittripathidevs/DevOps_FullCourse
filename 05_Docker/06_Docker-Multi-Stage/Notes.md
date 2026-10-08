## 🧣 DAY 6 — Docker Multi-Stage Builds

#### 1. What is Multi-Stage Docker Build?

A Multi-Stage Docker Build uses multiple `FROM` statements in one Dockerfile.

The main idea:

```text
Builder Stage
     ↓
Build / install dependencies
     ↓
Copy required files
     ↓
Final Production Stage
     ↓
Smaller final image
```

#### Benefits

- Smaller final image
- Fewer unnecessary tools
- Better security
- Faster image transfer
- Useful for CI/CD

---


#### 2. Single-Stage vs Multi-Stage

####  Single-Stage

```dockerfile
FROM python:3.14

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 80

CMD ["python", "run.py"]
```

Everything is built inside one image.

####  Multi-Stage

```dockerfile
FROM python:3.14 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt --target=/app/deps

COPY . .


FROM python:3.14-slim

WORKDIR /app

COPY --from=builder /app/deps /app/deps

ENV PYTHONPATH=/app/deps

COPY . .

EXPOSE 80

CMD ["python", "run.py"]
```

---



#### 3. Builder Stage

```dockerfile
FROM python:3.14 AS builder
```

`AS builder` gives a name to the first stage.

This allows us to copy files from this stage later:

```dockerfile
COPY --from=builder ...
```

---

#### 4. Install Dependencies

```dockerfile
RUN pip install --no-cache-dir -r requirements.txt --target=/app/deps
```

#### `--target=/app/deps`

Installs the Python packages into:

```text
/app/deps
```

The dependencies are stored separately from the application.

---

####  5. Final Production Stage

```dockerfile
FROM python:3.14-slim
```

This starts a new, smaller image.

Copy the dependencies from the builder stage:

```dockerfile
COPY --from=builder /app/deps /app/deps
```

Meaning:

```text
Builder Stage                    Final Stage

/app/deps  ──────────────────→  /app/deps
                 COPY
```

Since the dependencies are in `/app/deps`, tell Python to search there:

```dockerfile
ENV PYTHONPATH=/app/deps
```

---


#### 6. Complete Dockerfile

Create a file named:

```text
Dockerfile-multi
```

Content:

```dockerfile
# ============================================================
# Stage 1: Builder
# ============================================================

# Use Python image for installing dependencies
FROM python:3.14 AS builder

# Set the working directory
WORKDIR /app

# Copy dependency file
COPY requirements.txt .

# Install dependencies into a separate directory
RUN pip install --no-cache-dir -r requirements.txt --target=/app/deps

# Copy application files
COPY . .


# ============================================================
# Stage 2: Production
# ============================================================

# Use a smaller Python image for the final application
FROM python:3.14-slim

# Set the working directory
WORKDIR /app

# Copy dependencies from the builder stage
COPY --from=builder /app/deps /app/deps

# Tell Python where the dependencies are located
ENV PYTHONPATH=/app/deps

# Copy application files
COPY . .

# Application uses port 80
EXPOSE 80

# Start the application
CMD ["python", "run.py"]
```

---



#### 7. Build the Multi-Stage Image

Because the filename is `Dockerfile-multi`, specify it using `-f`:

```bash
docker build -f Dockerfile-multi -t flask-app:multi .
```

### Explanation

```text
-f Dockerfile-multi
    → Use Dockerfile-multi

-t flask-app:multi
    → Image name = flask-app
      Tag = multi/latest

.
    → Current directory is the build context
```

---



#### 8. Run the Container

```bash
docker run -d --name flask-app -p 80:80 flask-app:multi
```

Check the running container:

```bash
docker ps
```

Check logs:

```bash
docker logs flask-app
```

Test locally:

```bash
curl http://localhost
```

---


#### 9. Important Commands

#### Build

```bash
docker build -f Dockerfile-multi -t flask-app:multi .
```

#### Run

```bash
docker run -d --name flask-app -p 80:80 flask-app:multi
```

#### Check Images

```bash
docker images
```

#### Check Containers

```bash
docker ps
```

#### Stop Container

```bash
docker stop flask-app
```

#### Remove Container

```bash
docker rm flask-app
```

---

### 🎯 KEY CONCEPT

The most important multi-stage syntax is:

```dockerfile
FROM <image> AS <stage-name>
```

and:

```dockerfile
COPY --from=<stage-name> <source> <destination>
```

For this project:

```dockerfile
FROM python:3.14 AS builder

...

FROM python:3.14-slim

COPY --from=builder /app/deps /app/deps
```

The **builder stage** handles dependency installation, while the **final stage** contains what is required to run the application.

You do **not** need to build or run both Dockerfiles.

Use:

```bash
docker build -f Dockerfile-multi -t flask-app:multi .
```

to build the multi-stage image.

---
