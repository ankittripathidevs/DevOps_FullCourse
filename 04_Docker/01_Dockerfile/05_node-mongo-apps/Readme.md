# 🐳 Node.js + MongoDB + Mongo Express

## 1. 🌐 Create Network

```bash
docker network create mongo-network
docker network inspect mongo-network
```

---

## 2. 🍃 Create MongoDB

```bash
docker run -d \
  --name mongo-container \
  --network mongo-network \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=qwerty \
  mongo
```

Check:

```bash
docker ps
docker inspect mongo-container
docker logs mongo-container
```

---

## 3. 🔐 Enter MongoDB

```bash
docker exec -it mongo-container mongosh \
  -u admin \
  -p qwerty \
  --authenticationDatabase admin
```

Inside MongoDB:

```javascript
show dbs
use ankit-db
show collections
```

Add user directly:

```javascript
db.users.insertOne({
  username: "ankit",
  email: "ankit@example.com"
})
```

Find users:

```javascript
db.users.find().pretty()
```

Find one:

```javascript
db.users.findOne({ username: "ankit" })
```

Exit:

```javascript
exit
```

---

## 4. 🟢 Node.js

### Dockerfile

```dockerfile
FROM node

WORKDIR /dockerizing-node-app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5050

CMD ["node", "server.js"]
```

### MongoDB Connection in `server.js`

```javascript
const MONGO_URL = "mongodb://admin:qwerty@mongo-container:27017";
```

> Do not use `localhost` because Node.js is running inside its own container.

### Build

```bash
docker build -t node-app .
```

### Run

```bash
docker run -d \
  --name node-container \
  --network mongo-network \
  -p 5050:5050 \
  node-app
```

Check:

```bash
docker ps
docker logs node-container
```

---

## 5. 👤 Add User Using Node.js + curl

API:

```text
POST /addUser
```

```bash
curl -X POST http://localhost:5050/addUser \
  -H "Content-Type: application/json" \
  -d '{"username":"ankit","email":"ankit@example.com"}'
```

Data is stored in:

```text
ankit-db
└── users
```

---

## 6. 👥 Find Users Using Node.js + curl

API:

```text
GET /getUsers
```

```bash
curl http://localhost:5050/getUsers
```

---

## 7. 🖥️ Mongo Express

Run:

```bash
docker run -d \
  --name mongo-express \
  --network mongo-network \
  -p 8081:8081 \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=qwerty \
  -e ME_CONFIG_MONGODB_SERVER=mongo-container \
  mongo-express
```

Check:

```bash
docker ps
docker logs mongo-express
```

---

## 8. 🌐 Access Mongo Express

Open:

```text
http://YOUR_EC2_PUBLIC_IP:8081
```

Example:

```text
http://32.185.250.15:8081
```

Make sure the EC2 Security Group allows TCP port:

```text
8081
```

Then:

```text
Mongo Express
    ↓
ankit-db
    ↓
users
    ↓
Documents
```

---

## 🔄 Complete Flow

### Add using MongoDB CMD

```text
mongosh
  ↓
use ankit-db
  ↓
db.users.insertOne(...)
  ↓
db.users.find().pretty()
```

### Add using Node.js

```text
curl POST /addUser
  ↓
Node.js :5050
  ↓
MongoDB :27017
  ↓
ankit-db.users
```

### View using Mongo Express

```text
Browser
  ↓
EC2:8081
  ↓
Mongo Express
  ↓
ankit-db
  ↓
users
  ↓
Documents
```

---

## 🔍 Useful Docker Commands

```bash
# Running containers
docker ps

# All containers
docker ps -a

# Logs
docker logs mongo-container
docker logs node-container
docker logs mongo-express

# Follow logs
docker logs -f node-container

# Network
docker network ls
docker network inspect mongo-network

# Inspect MongoDB
docker inspect mongo-container

# Stop
docker stop mongo-container node-container mongo-express

# Remove
docker rm mongo-container node-container mongo-express
```

---

## 💾 MongoDB Data Location

Inside the MongoDB container:

```text
/data/db
```

Check:

```bash
docker exec -it mongo-container ls -lah /data/db
```

Check Docker volume:

```bash
docker inspect mongo-container \
  --format '{{range .Mounts}}{{.Name}} -> {{.Destination}}{{"\n"}}{{end}}'
```

---

## 📌 Final Setup

| Service | Port | Purpose |
|---|---:|---|
| Node.js | 5050 | Application/API |
| MongoDB | 27017 | Database |
| Mongo Express | 8081 | Web UI |

```text
Network:    mongo-network
Database:   ankit-db
Collection: users

MongoDB:
Username: admin
Password: qwerty
```

> ⚠️ Credentials are for learning only. Use environment variables/secrets in production.
