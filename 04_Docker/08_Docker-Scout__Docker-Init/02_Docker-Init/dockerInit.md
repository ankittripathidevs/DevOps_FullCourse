# Docker Init

## What is Docker Init?

`docker init` helps create basic Docker files for an existing project.

For a Node.js project, it can create:

```text
Dockerfile
.dockerignore
compose.yaml
README.Docker.md
```

## Docker Desktop

Check Docker Init:

```bash
docker init --help
```

Go inside your project:

```bash
cd node-cicd
```

Run:

```bash
docker init
```

Answer the questions according to your application.

---

## Example

Suppose my project already has:

```text
node-cicd/
├── app.js
├── package.json
├── package-lock.json
├── Dockerfile
├── compose.yaml
└── README.md
```

If I want to recreate the Docker files using `docker init`:

### 1. Go to the project

```bash
cd node-cicd
```

### 2. Delete existing Docker files

```bash
rm -f Dockerfile compose.yaml .dockerignore README.Docker.md
```

### 3. Run Docker Init

```bash
docker init
```

### 4. Check the generated files

```bash
ls -la
```

Docker Init will generate files such as:

```text
Dockerfile
.dockerignore
compose.yaml
README.Docker.md
```

### 5. Build and run

```bash
docker compose up --build -d
```

### 6. Check the container

```bash
docker ps
```

### 7. Stop the application

```bash
docker compose down
```

---

## Ubuntu Server

Normal Docker Engine on Ubuntu Server may not include `docker init`.

You may get:

```text
docker: unknown command: docker init
```

For learning Docker Init, use **Docker Desktop** to generate the Docker files.

After generating them, push the project to GitHub and use the generated files on the Ubuntu server.

On Ubuntu Server, use:

```bash
docker compose up -d
```

---

## Quick Reminder

```text
docker init
      ↓
Creates Docker files
      ↓
Dockerfile
compose.yaml
.dockerignore
      ↓
docker compose up
      ↓
Application runs
```

**Docker Init creates Docker configuration files; it does not run the application by itself.**

