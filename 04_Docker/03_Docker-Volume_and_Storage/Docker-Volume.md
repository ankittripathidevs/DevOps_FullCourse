# 🌼 DAY-3: Docker Volume & Storage

Docker Volume is used to store **persistent data** outside the container.

If a container is deleted, the data inside the container can be lost.

A Docker Volume allows the data to survive even if the container is deleted and recreated.

---

# 🌼 1. Docker Volume

## (1) List Docker Volumes

```bash
docker volume ls
```

---

## (2) Create a Docker Volume

```bash
docker volume create mysql-data
```

Here:

```text
mysql-data = Volume Name
```

---

## (3) Inspect a Docker Volume

```bash
docker volume inspect mysql-data
```

This shows information about the volume, including its mount point.

---

## (4) Remove a Docker Volume

```bash
docker volume rm mysql-data
```

> ⚠️ **Warning:** Removing a volume can permanently delete the data stored inside it.

---

## (5) Remove Unused Volumes

```bash
docker volume prune
```

> ⚠️ **Warning:** This removes unused Docker volumes. Make sure you don't need the data before running this command.

---

# 🌼 2. Complete Two-Tier Flask + MySQL Docker Setup

Our application has two tiers:

```text
Flask Application
       ↓
     MySQL
```

Both containers communicate through a Docker network.

MySQL uses a Docker Volume for persistent data.

---

## (1) Create Docker Network

```bash
docker network create two-tier
```

Check the network:

```bash
docker network ls
```

You should see:

```text
two-tier
```

---

## (2) Create MySQL Volume

```bash
docker volume create mysql-data
```

Check:

```bash
docker volume ls
```

You should see:

```text
mysql-data
```

---

## (3) Create MySQL Container

```bash
docker run -d \
  --name mysql-container \
  -p 3306:3306 \
  --network two-tier \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  -v mysql-data:/var/lib/mysql \
  mysql:latest
```

### Explanation
(i) Sets the MySQL container name.

```text
--name mysql-container
```

(ii) Maps:

```text
-p 3306:3306
```

```text
Host Port 3306 → Container Port 3306
```

(iii) Connects the MySQL container to the `two-tier` Docker network.

```text
--network two-tier
```

(iv) Sets the MySQL root password.

```text
-e MYSQL_ROOT_PASSWORD=root
```

(v) Creates a database named:

```text
-e MYSQL_DATABASE=devops
```

```text
devops
```

(vi) Mounts the Docker volume to MySQL's data directory.

```text
-v mysql-data:/var/lib/mysql
```


### Important

```text
Docker Volume                MySQL Container
     │                              │
     │                              │
mysql-data ───────────────→ /var/lib/mysql
```

This allows MySQL data to persist even if the MySQL container is deleted.

```text
Container = MySQL Application
Volume    = Persistent MySQL Data
```

---


# 🌼 3. Create Flask Container

Run the Flask container:

```bash
docker run -d \
  --name flask-container \
  -p 5000:5000 \
  --network two-tier \
  -e MYSQL_HOST=mysql-container \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=root \
  -e MYSQL_DB=devops \
  flask-app
```

### Flask Environment Variables

```text
MYSQL_HOST=mysql-container
MYSQL_USER=root
MYSQL_PASSWORD=root
MYSQL_DB=devops
```

### Important

The Flask application uses:

```text
MYSQL_HOST=mysql-container
```

NOT:

```text
MYSQL_HOST=localhost
```

Because Flask and MySQL are running in separate containers.

Docker's internal network allows Flask to communicate with MySQL using:

```text
mysql-container
```

---

# 🌼 4. Two-Tier Architecture

```text
                         two-tier network
                                │
                ┌───────────────┴───────────────┐
                │                               │
                ▼                               ▼
       ┌─────────────────┐             ┌─────────────────┐
       │ Flask Container │             │ MySQL Container │
       │                 │             │                 │
       │ Flask App       │────────────→│ MySQL           │
       │ Port: 5000      │             │ Port: 3306      │
       └─────────────────┘             └────────┬────────┘
                                                │
                                                │
                                         /var/lib/mysql
                                                │
                                                ▼
                                        ┌────────────────┐
                                        │   mysql-data   │
                                        │ Docker Volume  │
                                        └────────────────┘
```

### Data Flow

```text
User
 │
 │ HTTP :5000
 ▼
Flask Container
 │
 │ MySQL Connection
 │ Host = mysql-container
 ▼
MySQL Container
 │
 │ Stores Data
 ▼
mysql-data Docker Volume
```

---

# 🌼 5. Enter Data from the UI

Open the Flask application in your browser:

```text
http://YOUR_EC2_PUBLIC_IP:5000
```

Enter some test data through the UI.

Example:

```text
hello
namaste
```

The data should be stored in the MySQL database.

---

# 🌼 6. Connect to MySQL Container

## (a) Enter the MySQL Container

```bash
docker exec -it mysql-container bash
```

## (b) Connect to MySQL

```bash
mysql -u root -p
```

## (c) Enter the Password

```text
root
```

---

# 🌼 7. Check the Database

## (a) Show Databases

Inside MySQL:

```sql
SHOW DATABASES;
```

You should see:

```text
devops
```

---

## (b) Select the Database

```sql
USE devops;
```

---

## (c) Check Tables

```sql
SHOW TABLES;
```

---

## (d) Check the Data

If your Flask application stores data in a table called `messages`:

```sql
SELECT * FROM messages;
```

You should see the data entered from the Flask UI.

Example:

```text
hello
namaste
```

Exit MySQL:

```sql
exit;
```

Then exit the container:

```bash
exit
```

---

# 🌼 8. Test Docker Volume Persistence

This is the most important test.

We will:

1. Add data
2. Delete the MySQL container
3. Keep the Docker volume
4. Create MySQL again using the same volume
5. Check whether the old data still exists

---

## Step 1: Check Existing Data

```bash
docker exec -it mysql-container bash
```

Then:

```bash
mysql -u root -p
```

Enter:

```text
root
```

Then:

```sql
USE devops;
SELECT * FROM messages;
```

Confirm that your data exists.

Exit MySQL:

```sql
exit;
```

Then:

```bash
exit
```

---

## Step 2: Delete the MySQL Container

```bash
docker rm -f mysql-container
```

Check:

```bash
docker ps
```

The MySQL container should no longer be running.

---

## Step 3: Check the Volume

```bash
docker volume ls
```

You should still see:

```text
mysql-data
```

### Important

We deleted:

```text
mysql-container
```

But we did **NOT** delete:

```text
mysql-data
```

Therefore, the data should still exist.

---

## Step 4: Create MySQL Again Using the Same Volume

```bash
docker run -d \
  --name mysql-container \
  -p 3306:3306 \
  --network two-tier \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  -v mysql-data:/var/lib/mysql \
  mysql:latest
```

The important part is:

```text
-v mysql-data:/var/lib/mysql
```

We are attaching the **same volume** to the new MySQL container.

---

## Step 5: Verify Previous Data

Enter the new MySQL container:

```bash
docker exec -it mysql-container bash
```

Connect to MySQL:

```bash
mysql -u root -p
```

Enter:

```text
root
```

Then:

```sql
USE devops;
```

Check the data:

```sql
SELECT * FROM messages;
```

The data that was entered before deleting the container should still be there.

### Result

```text
Old MySQL Container
        │
        ▼
    mysql-data
        │
        ▼
New MySQL Container
        │
        ▼
Previous Data Still Exists
```

### Conclusion

> **Docker Volume provides persistent storage independently of the container lifecycle.**

---

# 🌼 9. How to See Where Docker Volume Data Is Stored

Docker volumes are stored on the Docker host machine.

---

## (a) List Docker Volumes

```bash
docker volume ls
```

Example:

```text
DRIVER    VOLUME NAME
local     mysql-data
```

---

## (b) Inspect the Docker Volume

```bash
docker volume inspect mysql-data
```

You will see information similar to:

```json
[
    {
        "CreatedAt": "...",
        "Driver": "local",
        "Mountpoint": "/var/lib/docker/volumes/mysql-data/_data",
        "Name": "mysql-data"
    }
]
```

The important field is:

```text
Mountpoint:
/var/lib/docker/volumes/mysql-data/_data
```

This is the actual location where Docker stores the volume data on the Docker host.

---

## (c) Switch to Root User

The Docker volume directory normally requires root privileges.

```bash
sudo su
```

Your prompt will change to something similar to:

```text
root@ip-172-31-46-201:~#
```

---

## (d) Navigate to the Volume Directory

```bash
cd /var/lib/docker/volumes/mysql-data/_data
```

---

## (e) List the Stored Data

```bash
ls
```

You may see MySQL files and directories such as:

```text
auto.cnf
ibdata1
mysql
performance_schema
sys
devops
```

The exact files and directories may vary depending on the MySQL version and configuration.

---

# 🌼 10. Docker Volume Storage Flow

```text
Docker Volume Name
        ↓
    mysql-data
        ↓
Docker Mountpoint
        ↓
/var/lib/docker/volumes/mysql-data/_data
        ↓
Persistent MySQL Data
```

---

# 🌼 11. Important Docker Commands

## Container Commands

### View MySQL Logs

```bash
docker logs mysql-container
```

### View Flask Logs

```bash
docker logs flask-container
```

### Enter a Running Container

```bash
docker exec -it mysql-container bash
```

---

# 🌼 12. Docker Network Commands

### Create Network

```bash
docker network create two-tier
```

### List Networks

```bash
docker network ls
```

### Inspect Network

```bash
docker network inspect two-tier
```

### Remove Network

```bash
docker network rm two-tier
```

---

# 🌼 13. Docker Volume Commands

### Create Volume

```bash
docker volume create mysql-data
```

### List Volumes

```bash
docker volume ls
```

### Inspect Volume

```bash
docker volume inspect mysql-data
```

### Remove Volume

```bash
docker volume rm mysql-data
```

### Remove Unused Volumes

```bash
docker volume prune
```

> ⚠️ **Warning:** Removing a volume can permanently delete the data stored inside it.

---

# 🌼 Final Architecture

```text
                         Internet
                            │
                            │ :5000
                            ▼
                  ┌───────────────────┐
                  │  Flask Container   │
                  │                   │
                  │    Flask App      │
                  └─────────┬─────────┘
                            │
                            │
                     two-tier network
                            │
                            ▼
                  ┌───────────────────┐
                  │ MySQL Container   │
                  │                   │
                  │ MySQL :3306       │
                  └─────────┬─────────┘
                            │
                            │ /var/lib/mysql
                            ▼
                  ┌───────────────────┐
                  │    mysql-data     │
                  │   Docker Volume   │
                  └───────────────────┘
```

## Final Summary

```text
Network
   ↓
two-tier
   ↓
Connects Flask + MySQL

Volume
   ↓
mysql-data
   ↓
Stores persistent MySQL data

Flask
   ↓
Connects to MySQL using
MYSQL_HOST=mysql-container

MySQL
   ↓
Stores data in
/var/lib/mysql

Docker Volume
   ↓
/var/lib/docker/volumes/mysql-data/_data
   ↓
Persistent Storage
```
