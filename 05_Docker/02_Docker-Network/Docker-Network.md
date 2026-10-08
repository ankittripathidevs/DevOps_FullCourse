# 🚀 DAY-2 — Docker Network & Flask + MySQL

---

## 🌸 Docker Network

Docker networks allow containers to communicate with each other and with external systems.

### Docker Network Drivers

| Driver                | Use Case                                                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `bridge`              | Default network driver. Used for communication between containers on the same Docker host.                               |
| `user-defined bridge` | Custom bridge network that provides better container-to-container communication and DNS-based container-name resolution. |
| `host`                | Container shares the host's network stack.                                                                               |
| `none`                | Disables networking for the container.                                                                                   |
| `macvlan`             | Gives containers their own MAC address and makes them appear as physical devices on the network.                         |
| `ipvlan`              | Provides network connectivity using the host's network interface with less MAC-address overhead.                         |
| `overlay`             | Used for communication between containers across multiple Docker hosts, commonly with Docker Swarm.                      |

> **Note:** `macvlan`, `ipvlan`, and `overlay` are more advanced networking options. They are not limited to Docker Swarm.

---

## 🌸 List Docker Networks

To see all available Docker networks:

```bash
docker network ls
```

---

## 🌸 Create a Docker Network

```bash
docker network create -d bridge ankit_network
```

Where:

* `-d` → specifies the network driver
* `bridge` → network driver
* `ankit_network` → network name

You can also create a network using:

```bash
docker network create two-tier
```

Docker will use the `bridge` driver by default if `-d bridge` is not specified.

---

## 🌸 Remove a Docker Network

```bash
docker network rm network_name
```

Example:

```bash
docker network rm two-tier
```

> The network cannot be removed while containers are still connected to it.

---

# ✅ Flask App with MySQL Docker Setup

This project demonstrates a simple **two-tier Flask application** that communicates with a MySQL database.

The application allows users to submit messages. These messages are stored in MySQL and displayed on the frontend.

### Architecture

```text
User
  │
  ▼
Flask Backend Container
  │
  │ Docker Network
  ▼
MySQL Container
```

---

# ✅ Prerequisites

Before starting, make sure the following are installed:

* Docker
* Git (optional, if cloning the repository)

---

# ✅ Setup

## 1. Clone the Repository

```bash
git clone https://github.com/ankittripathe/two-tier-flaskapp-docker-network.git
```

---

## 2. Navigate to the Project Directory

```bash
cd two-tier-flask-app
```

> Use the actual directory name created by your cloned repository if it differs.

---

# 🐬 MySQL Container Configuration

The following environment variables are used by the **MySQL Docker image**.

| Variable              | Purpose                                                                   |
| --------------------- | ------------------------------------------------------------------------- |
| `MYSQL_ROOT_PASSWORD` | Sets the MySQL root user's password.                                      |
| `MYSQL_DATABASE`      | Creates a database automatically when the MySQL container is initialized. |
| `MYSQL_USER`          | Creates an additional MySQL user.                                         |
| `MYSQL_PASSWORD`      | Sets the password for the additional MySQL user.                          |

### Example

```bash
-e MYSQL_ROOT_PASSWORD=root
-e MYSQL_DATABASE=devops
```

---

# 🚀 Backend Container Configuration

The Flask backend needs MySQL connection information.

```bash
-e MYSQL_HOST=mysql-docker
-e MYSQL_USER=root
-e MYSQL_PASSWORD=root
-e MYSQL_DB=devops
```

### Important

`MYSQL_HOST` should contain the **MySQL container name** when both containers are connected to the same user-defined Docker network.

For example:

```bash
--name mysql-docker
```

Therefore:

```bash
-e MYSQL_HOST=mysql-docker
```

Docker's internal DNS allows the Flask container to resolve `mysql-docker` to the MySQL container's IP address.

---

## 🔹 MySQL vs Backend Environment Variables

| Container            | Environment Variables                                                   |
| -------------------- | ----------------------------------------------------------------------- |
| 🐬 MySQL Container   | `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` |
| 🚀 Backend Container | `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DB`                |

> These are application/environment variables used by the respective containers. They are not all variables recognized by the MySQL image itself.

---

# ✅ Run the Two-Tier Application Without Docker Compose

We will manually create:

1. Docker image for the Flask application
2. Docker network
3. MySQL container
4. Flask backend container

---

# 1. Build the Flask Docker Image

Make sure the `Dockerfile` is present in the project directory.

```bash
docker build -t flask-app .
```

Check the image:

```bash
docker images
```

You should see something similar to:

```text
flask-app
```

---

# 2. Create a Docker Network

Create a custom bridge network:

```bash
docker network create two-tier
```

Check available networks:

```bash
docker network ls
```

Inspect the network:

```bash
docker network inspect two-tier
```

---

# 3. Create the MySQL Container

Run MySQL first:

```bash
docker run -d \
    --name mysql-docker \
    --network=two-tier \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=devops \
    -p 3306:3306 \
    mysql:latest
```

### Port Mapping

```text
-p 3306:3306
```

Means:

```text
Host Port : Container Port
   3306   :      3306
```

The Flask container does **not** need to connect using the host's `3306` port.

Inside the Docker network, the Flask container connects to:

```text
mysql-docker:3306
```

---

# 4. Create the Flask Backend Container

Run the Flask container:

```bash
docker run -d \
    --name flaskapp-docker \
    --network=two-tier \
    -e MYSQL_HOST=mysql-docker \
    -e MYSQL_USER=root \
    -e MYSQL_PASSWORD=root \
    -e MYSQL_DB=devops \
    -p 5000:5000 \
    flask-app:latest
```

### Important

This line:

```bash
-e MYSQL_HOST=mysql-docker
```

works because:

```text
MySQL container name = mysql-docker
```

and both containers are connected to:

```text
two-tier
```

Therefore:

```text
Flask Container
      │
      │ mysql-docker:3306
      ▼
MySQL Container
```

---

# 🔍 Verify the Containers

Check running containers:

```bash
docker ps
```

You should see both:

```text
mysql-docker
flaskapp-docker
```

---

# 🔍 Check Container Logs

Logs are useful for finding application or database connection errors.

### MySQL logs

```bash
docker logs mysql-docker
```

### Flask logs

```bash
docker logs flaskapp-docker
```

To follow logs continuously:

```bash
docker logs -f flaskapp-docker
```

---

# 🔍 Verify Both Containers Are on the Same Network

Run:

```bash
docker network inspect two-tier
```

Under the `Containers` section, you should find both:

```text
mysql-docker
flaskapp-docker
```

This confirms that both containers are connected to the same Docker network.

---

# 🐬 Login to the MySQL Container

To open a shell inside the MySQL container:

```bash
docker exec -it mysql-docker bash
```

Then connect to MySQL:

```bash
mysql -u root -p
```

When prompted:

```text
Enter password:
```

Enter:

```text
root
```

### Shortcut

You can also connect directly without opening a bash shell:

```bash
docker exec -it mysql-docker mysql -u root -p
```

---

# 🗄️ Check the MySQL Database

## 1. Show All Databases

Inside MySQL:

```sql
SHOW DATABASES;
```

You should see something similar to:

```text
+--------------------+
| Database           |
+--------------------+
| devops             |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

The presence of `devops` confirms that the database was created.

---

## 2. Select the Database

```sql
USE devops;
```

You should get:

```text
Database changed
```

---

## 3. Show Tables

```sql
SHOW TABLES;
```

If your Flask application creates a `messages` table, you should see:

```text
messages
```

---

## 4. View Stored Messages

```sql
SELECT * FROM messages;
```

This displays the messages stored by the Flask application.

---

# 🔄 Restart a Docker Container

To restart the MySQL container:

```bash
docker restart mysql-docker
```

To restart the Flask container:

```bash
docker restart flaskapp-docker
```

> Restarting a container does not recreate it. However, restarting does not fix incorrect environment variables that were used when the container was created.

---

# 🛑 Stop and Remove Containers

Stop the MySQL container:

```bash
docker stop mysql-docker
```

Remove it:

```bash
docker rm mysql-docker
```

Or do both:

```bash
docker stop mysql-docker && docker rm mysql-docker
```

For the Flask container:

```bash
docker stop flaskapp-docker && docker rm flaskapp-docker
```

---

# ⚠️ Important: MySQL Data and Volumes

If you remove the MySQL container without using a Docker volume, the database data stored inside that container can be lost.

For example:

```bash
docker stop mysql-docker
docker rm mysql-docker
```

Without persistent storage, the data inside the container is not something you should rely on for production.

### Volume

Docker **volumes** are used to persist database data even when the MySQL container is removed.

> 📌 We will study Docker volumes separately in the next project/topic.

---

# 🌐 Access the Flask Application

If the Flask container exposes port `5000` and you mapped:

```bash
-p 5000:5000
```

you can access the application from the host using:

```text
http://localhost:5000
```

If the application is running on an AWS EC2 instance, access it using:

```text
http://<EC2-PUBLIC-IP>:5000
```

Make sure the EC2 Security Group allows inbound traffic on port `5000` if you are accessing it externally.

---

# ❌ Common Error: OperationalError

If the Flask application cannot connect to MySQL, you may see an error such as:

```text
OperationalError
```

Possible causes include:

1. MySQL container is not running.
2. Flask and MySQL are not on the same Docker network.
3. `MYSQL_HOST` is incorrect.
4. MySQL credentials are incorrect.
5. The database name is incorrect.
6. MySQL is still initializing.
7. The application is trying to connect before MySQL is ready.

### Useful checks

```bash
docker ps
```

```bash
docker logs mysql-docker
```

```bash
docker logs flaskapp-docker
```

```bash
docker network inspect two-tier
```

---

# 🧠 Key Concept

When containers are connected to the same **user-defined Docker bridge network**, they can communicate using container names.

For example:

```text
Flask
  │
  │ MYSQL_HOST=mysql-docker
  ▼
mysql-docker
```

You normally **do not use**:

```text
localhost
```

for the MySQL host inside the Flask container.

Why?

Because inside the Flask container:

```text
localhost = Flask container itself
```

not the MySQL container.

---

# 📌 Day-2 Summary

### Docker Network

```bash
docker network ls
```

```bash
docker network create two-tier
```

```bash
docker network inspect two-tier
```

```bash
docker network rm two-tier
```

### Build Image

```bash
docker build -t flask-app .
```

### Run MySQL

```bash
docker run -d \
    --name mysql-docker \
    --network=two-tier \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=devops \
    -p 3306:3306 \
    mysql:latest
```

### Run Flask

```bash
docker run -d \
    --name flaskapp-docker \
    --network=two-tier \
    -e MYSQL_HOST=mysql-docker \
    -e MYSQL_USER=root \
    -e MYSQL_PASSWORD=root \
    -e MYSQL_DB=devops \
    -p 5000:5000 \
    flask-app:latest
```

### Check Containers

```bash
docker ps
```

### Check Logs

```bash
docker logs mysql-docker
```

```bash
docker logs flaskapp-docker
```

### Check MySQL Data

```bash
docker exec -it mysql-docker mysql -u root -p
```

```sql
SHOW DATABASES;
USE devops;
SHOW TABLES;
SELECT * FROM messages;
```

---

## 🚀 Next Topic

**Docker Volumes — Persistent Storage for MySQL**

We will learn how to make MySQL data persistent so that database data survives container deletion and recreation.


---

# 🔍 Check Listening TCP Ports on EC2

To see all listening TCP ports on your EC2 instance:

```bash
sudo ss -ltnp
```

### Command Breakdown

| Option | Meaning                                   |
| ------ | ----------------------------------------- |
| `ss`   | Socket statistics — shows network sockets |
| `-l`   | Show only listening sockets               |
| `-t`   | Show TCP sockets                          |
| `-n`   | Show port numbers in numeric format       |
| `-p`   | Show the process using the port           |

### Example

```bash
sudo ss -ltnp
```

This is useful for checking whether your application, Docker container, MySQL, or another service is actually listening on the expected port.

---

