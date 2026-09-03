# 🐍 2-Tier Flask + MySQL — Docker Network

A simple **2-tier application** where a Flask backend connects to a MySQL database using a custom Docker network and a **Named Docker Volume**.

## Tech Stack

* Python 3.9
* Flask
* MySQL
* Docker
* Docker Network
* Docker Named Volume
* AWS EC2

## Project Structure

```text
01_two-tier-flask-app/
├── Dockerfile
├── README.md
├── app.py
├── message.sql
├── requirements.txt
└── templates/
```

## Architecture

```text
User
 │
 ▼
EC2 :5000
 │
 ▼
Flask Container
 │
 │ Docker Network: two-tier
 ▼
MySQL Container
 │
 │ Named Volume: mysql-data
 ▼
Persistent MySQL Data
```

## 1. 💾 Create Named Volume — `mysql-data`

Create a Docker **Named Volume**:

```bash
docker volume create mysql-data
```

Check:

```bash
docker volume ls
```

Inspect:

```bash
docker volume inspect mysql-data
```

Check the stored files:

```bash
sudo ls -lah /var/lib/docker/volumes/mysql-data/_data
```

> `mysql-data` is a **Named Volume**, not a Bind Mount.

## 2. 🌐 Create Docker Network — `two-tier`

```bash
docker network create two-tier
```

Check:

```bash
docker network ls
```

## 3. 🍃 Run MySQL Container

```bash
docker run -d \
  --name mysql-container \
  --network=two-tier \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  -v mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:latest
```

Check:

```bash
docker ps
```

## 4. 🐍 Build Flask Image

```bash
docker build -t flaskapp .
```

## 5. 🚀 Run Flask Container

```bash
docker run -d \
  --name flask-container \
  --network=two-tier \
  -e MYSQL_HOST=mysql-container \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=root \
  -e MYSQL_DB=devops \
  -p 5000:5000 \
  flaskapp:latest
```

> `MYSQL_HOST` uses `mysql-container` because both containers are connected to the same Docker network.

## 6. 🔍 Check Containers

```bash
docker ps
```

## 7. 🌐 Check Network

```bash
docker network inspect two-tier
```

Both containers should appear:

```text
flask-container
mysql-container
```

## 8. 🗄️ Verify MySQL Data

Enter MySQL:

```bash
docker exec -it mysql-container mysql -u root -p
```

Password:

```text
root
```

Then:

```sql
SHOW DATABASES;
USE devops;
SHOW TABLES;
SELECT * FROM messages;
```

## 9. 🌐 Access Application

### Local

```text
http://localhost:5000
```

### AWS EC2

```text
http://<EC2-PUBLIC-IP>:5000
```

> Make sure port `5000` is allowed in the EC2 Security Group.

## 🔄 Data Persistence

The MySQL data is stored in the **Named Volume**:

```text
mysql-data
     ↓
/var/lib/docker/volumes/mysql-data/_data
     ↓
/var/lib/mysql
```

The data remains available even if the MySQL container is removed, as long as the `mysql-data` volume is not deleted.

## 📌 Named Volume vs Bind Mount

### Named Volume

```bash
-v mysql-data:/var/lib/mysql
```

Docker manages the storage location.

### Bind Mount

```bash
-v ./mysql-data:/var/lib/mysql
```

You provide the storage location on the host.

**This project uses a Named Volume: `mysql-data`.**

