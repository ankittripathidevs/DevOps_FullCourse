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

# 🌼 2. Named Volume vs Bind Mount

Docker provides two common ways to persist container data:

1. **Named Volume**
2. **Bind Mount**

---

## (1) Named Volume

A Named Volume is managed by Docker.

Example:

```bash
-v mysql-data:/var/lib/mysql
```

Here:

```text
Docker Volume                MySQL Container
     │                              │
     │                              │
mysql-data ───────────────→ /var/lib/mysql
```

Docker manages the storage location.

Typically, the volume is stored at:

```text
/var/lib/docker/volumes/mysql-data/_data
```

---

## (2) Bind Mount

A Bind Mount uses a normal directory from the Docker host.

First create the directory:

```bash
mkdir -p /home/ubuntu/volumes/mysql
```

Then mount it into the MySQL container:

```bash
-v /home/ubuntu/volumes/mysql:/var/lib/mysql
```

This means:

```text
Docker Host                         MySQL Container
    │                                     │
    │                                     │
/home/ubuntu/volumes/mysql ──────→ /var/lib/mysql
```

The MySQL data is stored directly in:

```text
/home/ubuntu/volumes/mysql
```

### Key Difference

```text
Named Volume
    ↓
Docker manages the storage location

Bind Mount
    ↓
You choose the storage location
```

---

## Named Volume vs Bind Mount

| Named Volume | Bind Mount |
|---|---|
| `mysql-data:/var/lib/mysql` | `/home/ubuntu/volumes/mysql:/var/lib/mysql` |
| Docker manages the storage location | You choose the storage location |
| Managed using `docker volume` commands | Managed as a normal host directory |
| Good for Docker-managed persistent data | Useful when direct host-path access is needed |
| Stored under Docker's volume storage | Stored at the host path you specify |

---

# 🌼 3. Complete Two-Tier Flask + MySQL Docker Setup

Our application has two tiers:

```text
Flask Application
       ↓
     MySQL
```

Both containers communicate through a Docker network.

MySQL uses persistent storage.

You can use either:

```text
Named Volume
     OR
Bind Mount
```

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

If using a **Named Volume**:

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

> If you are using a **Bind Mount**, you do not need to create a Docker volume. Instead, create the host directory:
>
> ```bash
> mkdir -p /home/ubuntu/volumes/mysql
> ```

---

## (3) Create MySQL Container Using Named Volume

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

### (i) Set the MySQL container name

```text
--name mysql-container
```

### (ii) Map the MySQL port

```text
-p 3306:3306
```

```text
Host Port 3306 → Container Port 3306
```

### (iii) Connect the MySQL container to the network

```text
--network two-tier
```

### (iv) Set the MySQL root password

```text
-e MYSQL_ROOT_PASSWORD=root
```

### (v) Create a database

```text
-e MYSQL_DATABASE=devops
```

This creates:

```text
devops
```

### (vi) Mount the Named Volume

```text
-v mysql-data:/var/lib/mysql
```

This means:

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

# 🌼 4. Create MySQL Container Using Bind Mount

Instead of a Named Volume, you can use a directory on the host.

### (i) Create the Host Directory

```bash
mkdir -p /home/ubuntu/volumes/mysql
```

### (ii) Run MySQL

```bash
docker run -d \
  --name mysql-container \
  -p 3306:3306 \
  --network two-tier \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  -v /home/ubuntu/volumes/mysql:/var/lib/mysql \
  mysql:latest
```

The important part is:

```text
-v /home/ubuntu/volumes/mysql:/var/lib/mysql
```

This means:

```text
Docker Host                         MySQL Container
    │                                     │
    │                                     │
/home/ubuntu/volumes/mysql ──────→ /var/lib/mysql
```

MySQL data is stored directly on the host at:

```text
/home/ubuntu/volumes/mysql
```

---

# 🌼 5. Create Flask Container

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

# 🌼 6. Two-Tier Architecture

## Using Named Volume

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

## Using Bind Mount

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
                                                │ /var/lib/mysql
                                                │
                                                ▼
                                  /home/ubuntu/volumes/mysql
                                      Docker Bind Mount
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
Persistent Storage
 │
 ├── Named Volume
 │     mysql-data
 │
 └── Bind Mount
       /home/ubuntu/volumes/mysql
```

---

# 🌼 7. Enter Data from the UI

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

# 🌼 8. Connect to MySQL Container

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

# 🌼 9. Check the Database

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

# 🌼 10. Test Persistent Storage

This is the most important test.

We will:

1. Add data
2. Delete the MySQL container
3. Keep the persistent storage
4. Create MySQL again using the same storage
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

## Step 3: Check the Persistent Storage

### If using Named Volume

```bash
docker volume ls
```

You should still see:

```text
mysql-data
```

We deleted:

```text
mysql-container
```

but we did **NOT** delete:

```text
mysql-data
```

Therefore, the data should still exist.

### If using Bind Mount

Check the host directory:

```bash
ls -la /home/ubuntu/volumes/mysql
```

The MySQL data should still be present because the directory belongs to the host, not the container.

---

## Step 4: Create MySQL Again Using the Same Storage

### Using Named Volume

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

### Using Bind Mount

```bash
docker run -d \
  --name mysql-container \
  -p 3306:3306 \
  --network two-tier \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  -v /home/ubuntu/volumes/mysql:/var/lib/mysql \
  mysql:latest
```

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
Persistent Storage
        │
        ▼
New MySQL Container
        │
        ▼
Previous Data Still Exists
```

### Conclusion

> **Named Volumes and Bind Mounts provide persistent storage independently of the container lifecycle.**

---

# 🌼 11. How to See Where Named Volume Data Is Stored

Docker volumes are stored on the Docker host machine.

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

# 🌼 12. How to See Bind Mount Data

For a Bind Mount, you already know the host storage location because you created it.

```bash
ls -la /home/ubuntu/volumes/mysql
```

You can also inspect the container:

```bash
docker inspect mysql-container
```

Look for the `Mounts` section.

You should see:

```text
Source:
/home/ubuntu/volumes/mysql

Destination:
/var/lib/mysql
```

This confirms that:

```text
/home/ubuntu/volumes/mysql
```

on the host is mounted to:

```text
/var/lib/mysql
```

inside the MySQL container.

---

# 🌼 13. Storage Flow

## Named Volume

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

## Bind Mount

```text
Host Directory
        ↓
/home/ubuntu/volumes/mysql
        ↓
Bind Mount
        ↓
/var/lib/mysql
        ↓
MySQL Container
```

---

# 🌼 14. Important Docker Commands

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

# 🌼 15. Docker Network Commands

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

# 🌼 16. Docker Volume Commands

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

# ⚠️ 17. Important Warning

Do **not** manually modify or delete MySQL files while MySQL is running.

For a Named Volume:

```text
/var/lib/docker/volumes/mysql-data/_data
```

For a Bind Mount:

```text
/home/ubuntu/volumes/mysql
```

These files are managed by MySQL.

Manually modifying or deleting them can corrupt the database.

Use MySQL commands instead:

```bash
docker exec -it mysql-container mysql -u root -p
```

---

# 🧠 18. Key Concepts

## Container

```text
Container = Application Environment
```

A container is replaceable.

```bash
docker rm -f mysql-container
```

deletes the container.

---

## Named Volume

```text
Named Volume = Docker-managed Persistent Storage
```

Example:

```bash
-v mysql-data:/var/lib/mysql
```

---

## Bind Mount

```text
Bind Mount = Host-managed Persistent Storage
```

Example:

```bash
-v /home/ubuntu/volumes/mysql:/var/lib/mysql
```

---

# ⭐ 19. Most Important Concept

```text
Container Lifecycle ≠ Data Lifecycle
```

```text
        Container
            │
            │ uses
            ▼
   Persistent Storage
            │
      ┌─────┴─────┐
      │           │
 Named Volume  Bind Mount
```

The container can be deleted and recreated while the persistent data remains.

---

# 🌼 20. Final Architecture

```text
                         Internet
                            │
                            │ :5000
                            ▼
                  ┌───────────────────┐
                  │  Flask Container  │
                  │                   │
                  │    Flask App      │
                  └─────────┬─────────┘
                            │
                            │
                     two-tier network
                            │
                            ▼
                  ┌───────────────────┐
                  │  MySQL Container  │
                  │                   │
                  │   MySQL :3306     │
                  └─────────┬─────────┘
                            │
                            │ /var/lib/mysql
                            ▼
                  ┌───────────────────────┐
                  │   Persistent Storage  │
                  │                       │
                  │ Named Volume OR       │
                  │ Bind Mount             │
                  └───────────────────────┘
```

# 🌟 Final Summary

```text
Docker Network
      ↓
  two-tier
      ↓
Connects Flask + MySQL

Flask
      ↓
MYSQL_HOST=mysql-container
      ↓
MySQL

MySQL
      ↓
/var/lib/mysql
      ↓
Persistent Storage

Named Volume:
mysql-data:/var/lib/mysql

OR

Bind Mount:
/home/ubuntu/volumes/mysql:/var/lib/mysql
```

### Remember

```text
Named Volume
→ Docker manages the storage location

Bind Mount
→ You choose/manage the host storage location

Both
→ Can persist data beyond the container lifecycle
```

