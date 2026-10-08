# 🐳 Docker Init

`docker init` helps create basic Docker configuration files for an existing project.

For a Node.js project, it can generate:

```text
Dockerfile
.dockerignore
compose.yaml
README.Docker.md
```

> **Note:** `docker init` is an interactive command. It asks a series of questions about your application before generating the Docker files.

---

## 1. 🚀 Run Docker Init

Go inside your existing project:

```bash
cd node-cicd
```

Run:

```bash
docker init
```

Docker Init will ask questions such as:

```text
? What application platform does your project use?
? What version of Node do you want to use?
? What command do you use to start your application?
? What port does your application listen on?
```

The exact questions can vary depending on the project and Docker Init version.

Answer the questions according to your application.

---

## 2. 📁 Example Project

Suppose the project already contains:

```text
node-cicd/
├── app.js
├── package.json
├── package-lock.json
└── README.md
```

Go inside the project:

```bash
cd node-cicd
```

Then run:

```bash
docker init
```

Answer the questions according to your Node.js application.

Docker Init can generate:

```text
Dockerfile
.dockerignore
compose.yaml
README.Docker.md
```

Check the generated files:

```bash
ls -la
```

---

## 3. 🔄 Recreate Docker Files

If Docker files already exist and you want Docker Init to generate them again:

```bash
rm -f Dockerfile compose.yaml .dockerignore README.Docker.md
```

Then:

```bash
docker init
```

> ⚠️ Make sure you have a backup or Git commit before deleting existing Docker files.

---

## 4. 🏗️ Build & Run

After Docker Init generates the files:

```bash
docker compose up --build -d
```

Check the application:

```bash
docker compose ps
```

Or:

```bash
docker ps
```

Check logs:

```bash
docker compose logs
```

Stop the application:

```bash
docker compose down
```

---

# 🖥️ Docker Desktop

Docker Init is commonly available with newer Docker Desktop installations.

Check:

```bash
docker init
```

If available, it will start the interactive setup.

---

# ☁️ Ubuntu Server

On an Ubuntu server using Docker Engine, `docker init` may not be available depending on how Docker was installed/version.

You may see:

```text
docker: unknown command: docker init
```

For learning Docker Init, you can use Docker Desktop to generate the Docker files.

Then commit those generated files to Git and use them on your Ubuntu server.

On Ubuntu:

```bash
docker compose up -d
```

---

# 🔄 Docker Init Workflow

```text
Existing Project
       ↓
   docker init
       ↓
Interactive Questions
       ↓
Answer according to application
       ↓
Dockerfile
compose.yaml
.dockerignore
README.Docker.md
       ↓
docker compose up
       ↓
Application Runs
```

## 🎯 Key Concept

**Docker Init creates Docker configuration files; it does not build or run the application automatically.**

The basic workflow is:

```text
docker init
      ↓
Answer Questions
      ↓
Review Generated Files
      ↓
docker compose up --build -d
      ↓
Application Runs
```

