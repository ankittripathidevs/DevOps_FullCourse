# 🐳 Docker Compose — Node.js + MongoDB + Mongo Express

Docker Compose runs **Node.js, MongoDB, and Mongo Express** together using one `docker-compose.yml`.

## 1. 🔍 Validate Compose File

```bash
docker compose config
```

## 2. 🚀 Build & Start

```bash
docker compose up -d --build
```

* `-d` → Run in background
* `--build` → Build Node.js image

## 3. 📦 Check Containers

```bash
docker compose ps
```

Expected services:

```text
mongo
node-app
mongo-express
```

## 4. 📋 Check Logs

All services:

```bash
docker compose logs
```

Specific service:

```bash
docker compose logs mongo
docker compose logs node-app
docker compose logs mongo-express
```

## 5. 🛑 Stop & Remove

```bash
docker compose down
```

> This removes containers and the Compose network, but the MongoDB bind-mounted data remains.

## 6. 💾 MongoDB Bind Mount

MongoDB uses:

```yaml
volumes:
  - ./mongo-database:/data/db
```

Meaning:

```text
./mongo-database
       ↓
MongoDB /data/db
```

The database files are stored in the project directory:

```text
./mongo-database/
```

Add it to `.gitignore`:

```gitignore
# MongoDB database data (Docker bind mount)
mongo-database/
```

## 7. 🌐 Docker Network

All three services use:

```yaml
networks:
  - mongo-network
```

Node.js connects to MongoDB using the **Compose service name**:

```text
mongo
```

Example:

```javascript
mongodb://admin:qwerty@mongo:27017
```

> ❌ Do not use `localhost` between containers.

## 8. 🖥️ Mongo Express

Open:

```text
http://<EC2-PUBLIC-IP>:8081
```

Login:

```text
Username: admin
Password: qwerty
```

Mongo Express connects to:

```text
mongo:27017
```

## 9. 🌐 Node.js API

Node.js runs on:

```text
http://<EC2-PUBLIC-IP>:5050
```

Example:

```bash
curl http://localhost:5050/getUsers
```

## 🔄 Application Flow

```text
Browser / curl
      ↓
Node.js :5050
      ↓
MongoDB :27017
      ↓
./mongo-database
```

Mongo Express:

```text
Browser
   ↓
:8081
   ↓
Mongo Express
   ↓
mongo:27017
```

## 📌 Quick Commands

```bash
docker compose config
docker compose up -d --build
docker compose ps
docker compose logs
docker compose down
```

