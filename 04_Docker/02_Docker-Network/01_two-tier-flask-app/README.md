# 2-Tier Flask + MySQL — Docker Network

A simple **2-tier application** where a Flask backend connects to a MySQL database using a custom Docker network.

The Flask application accepts messages and stores them in MySQL.

## Tech Stack

* Python 3.9
* Flask
* MySQL
* Docker
* Docker Network
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
 │  Docker Network: two-tier
 ▼
MySQL Container
```

## Docker Images

```bash
docker images
```

* `flaskapp:latest`
* `mysql:latest`

## Create Docker Network

```bash
docker network create two-tier
```

Check:

```bash
docker network ls
```

## Run MySQL Container

```bash
docker run -d \
  --name mysql-container \
  --network=two-tier \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  -p 3306:3306 \
  mysql:latest
```

## Build Flask Image

```bash
docker build -t flaskapp .
```

## Run Flask Container

```bash
docker run -d \
  --name flask-conatiner \
  --network=two-tier \
  -e MYSQL_HOST=mysql-container \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=root \
  -e MYSQL_DB=devops \
  -p 5000:5000 \
  flaskapp:latest
```

> `MYSQL_HOST` uses the **MySQL container name** because both containers are connected to the same Docker network.

## Check Containers

```bash
docker ps
```

## Check Network

```bash
docker network inspect two-tier
```

Both `flask-conatiner` and `mysql-container` should appear in the network.

## Verify MySQL Data

Enter the MySQL container:

```bash
docker exec -it mysql-container mysql -u root -p
```

Enter password:

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

## Access Application

### Local

```text
http://localhost:5000
```

### AWS EC2

```text
http://<EC2-PUBLIC-IP>:5000
```

> Make sure **port 5000** is allowed in the EC2 Security Group.

## Important

This project uses Docker containers and a custom Docker network for communication.

