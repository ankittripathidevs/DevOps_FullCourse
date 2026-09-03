# 🐳 Node.js + MongoDB + Mongo Express

## 1. 🌐 Create Network

```bash
docker network create mongo-network
docker network inspect mongo-network
```

---

## 2. 🟢 Build & Run Node.js

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
```

---

## 3. 🍃 Create MongoDB

```bash
docker run -d \
  --name mongo-container \
  --network mongo-network \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=qwerty \
  mongo:8.2
```

Check:

```bash
docker ps
docker logs mongo-container
```

---

## 4. 🔐 Enter MongoDB

```bash
docker exec -it mongo-container mongosh \
  -u admin \
  -p qwerty
```

Create database and insert data:

```javascript
use ankit-db

db.users.insertOne({
  username: "ankit",
  email: "ankit@example.com"
})
```

> `ankit-db` appears in `show databases` only after data is inserted.

Find users:

```javascript
db.users.find().pretty()
```

---

## 5. 🔗 Node.js MongoDB Connection

```javascript
const MONGO_URL = "mongodb://admin:qwerty@mongo-container:27017";
```

> Do not use `localhost` because Node.js and MongoDB are running in separate containers.

---

## 6. 👥 Get Users

API:

```text
GET /getUsers
```

```bash
curl http://localhost:5050/getUsers
```

---

## 7. ➕ Add User

API:

```text
POST /addUser
```

Example:

```bash
curl -X POST http://localhost:5050/addUser \
  -H "Content-Type: application/json" \
  -d '{"username":"ram123","email":"ram@gmail.com"}'
```

---

## 8. 🖥️ Mongo Express

```bash
docker run -d \
  --name mongo-express \
  --network mongo-network \
  -p 8081:8081 \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=qwerty \
  -e ME_CONFIG_MONGODB_SERVER=mongo-container \
  -e ME_CONFIG_BASICAUTH_ENABLED=true \
  -e ME_CONFIG_BASICAUTH_USERNAME=admin \
  -e ME_CONFIG_BASICAUTH_PASSWORD=qwerty \
  mongo-express
```

Check:

```bash
docker ps
docker logs mongo-express
```

Open:

```text
http://<EC2-PUBLIC-IP>:8081
```

Login:

```text
Username: admin
Password: qwerty
```

---

## 🔄 Application Flow

```text
POST /addUser
      ↓
Node.js :5050
      ↓
MongoDB :27017
      ↓
ankit-db
      ↓
users
```

Mongo Express:

```text
Browser
   ↓
EC2 :8081
   ↓
Mongo Express
   ↓
ankit-db → users
```

