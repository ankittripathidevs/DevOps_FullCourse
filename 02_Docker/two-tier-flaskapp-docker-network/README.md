# ✅ Flask App with MySQL Docker Setup

A simple Flask app that interacts with a MySQL database. The app allows users to submit messages, which are then stored in the database and displayed on the frontend.

## ✅ Prerequisites

Before you begin, make sure you have the following installed:

- Docker
- Git (optional, for cloning the repository)

## ✅ Setup

##### 1️⃣ Clone this repository (if you haven't already)

```bash
git clone https://github.com/ankittripathe/two-tier-flaskapp-docker-network.git
```

##### 2️⃣ Navigate to the project directory

```bash
cd two-tier-flaskapp-docker-network
```

##### 3️⃣ MySQL Container Setup

```bash
This is used when you run the MySQL Docker container.

docker run -d \
 --name mysql-docker \ (docker customName)
-e MYSQL_ROOT_PASSWORD=root \
 -e MYSQL_DATABASE=devops \
 -p 3306:3306 \
 mysql:8

🔹 These variables are for MySQL image only.
```

| Variable              | Purpose                          |
| --------------------- | -------------------------------- |
| `MYSQL_ROOT_PASSWORD` | Sets root password               |
| `MYSQL_DATABASE`      | Creates database automatically   |
| `MYSQL_USER`          | (optional) create new user       |
| `MYSQL_PASSWORD`      | (optional) password for new user |

##### 4️⃣ MySQL configuration For Backend Container (Flask / Node / Java)

```bash
-e MYSQL_HOST=mysql-conatinerName
-e MYSQL_USER=your_username (example:- root)
-e MYSQL_PASSWORD=your_password (example:- root)
-e MYSQL_DB=your_database (example:- devops)
```

| Where Used           | Variables                                                               |
| -------------------- | ----------------------------------------------------------------------- |
| 🐬 MySQL Container   | `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` |
| 🚀 Backend Container | `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DB`                |

## ✅ To run this two-tier application using without docker-compose

##### 1️⃣ First create a docker image from Dockerfile

```bash
docker build -t flaskapp .
```

##### 2️⃣ Now, make sure that you have created a network using following command

```bash
docker network create custom-NetworkName

# Example
  docker network create two-tier

# Check network list
  docker network ls

# Remove network
 docker network rm network-Name

# shows complete details about Docker network.
 docker network inspect network_name
```

##### 3️⃣ Attach both the containers in the same network, so that they can communicate with each other

(1) MySQL container

```bash
docker run -d \
    --name mysql-docker \
    --network=two-tier \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=devops \
    -p 3306:3306 \
    mysql:latest
```

(2) flaskapp (Backend container)

```bash
docker run -d \
    --name flaskapp-docker \
    --network=two-tier \
    -e MYSQL_HOST=mysql-docker \ (This should be the container name of mysql)
    -e MYSQL_USER=root \
    -e MYSQL_PASSWORD=root \
    -e MYSQL_DB=devops \
    -p 5000:5000 \
    flaskapp:latest
```

### ✅ Steps to Check Whether Data Is Stored in MySQL Database

##### 1️⃣ Check Docker Container Logs

Use this to verify if MySQL or backend container has any errors.

```bash
docker logs container_Name/Id
```

##### 2️⃣ Verify Both Containers Are in the Same Network

This ensures backend can connect to MySQL.

```bash
docker network inspect network_Name
```

##### 3️⃣ Login to MySQL Container

Use this command to enter MySQL shell.

```bash
docker exec -it mysql-docker

🔹 Now you are inside the container.
mysql -u root -p

Then it will ask:
Enter password:
root
```

##### 4️⃣ Show All Databases

```bash
SHOW DATABASES;

You should see something like:
+--------------------+
| Database           |
+--------------------+
| devops             |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
🔹 This confirms your devops database is created.
```

#### 5️⃣ Select Your Database

```bash
USE devops;

🔹 This switches to your project database.
```

#### 6️⃣ View All Messages (Check Table Data)

```bash
SELECT * FROM messages;

🔹 This shows all rows stored inside the messages table.
```

#### 7️⃣ Restart Docker Container

```bash
docker restart mysql-docker

🔹 Useful if MySQL gets stuck or you changed environment variables.
```

#### 8️⃣ Stop & Remove Container

```bash
docker stop mysql-docker && docker rm mysql-docker

🔹 Stops and deletes the container
(Your data will be lost if you're not using a volume!)
```

#### 9️ Refresh Frontend (Flask)

```bash
# If the backend cannot connect to MySQL, you might see:
  OperationalError
```

#### 🔟 Here term volume comes in.
- we will study in seperate project 
