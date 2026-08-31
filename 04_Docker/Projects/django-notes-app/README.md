# 📝 Django Notes App — SQLite & MySQL

A full-stack Notes application built with **React.js**, **Django REST Framework**, **MySQL**, **Nginx**, and **Docker**.

The application can be configured to use SQLite for simple development or MySQL for the Dockerized deployment.

---

# 🧰 Tech Stack

* React.js
* Django 4.1.5
* Django REST Framework
* Gunicorn 20.1.0
* MySQL
* Nginx
* Docker
* Docker Compose
* Docker Bind Mounts
* Docker Networks

---

# 📁 Project Structure

```text
django-notes-app/
│
├── api/
├── mynotes/
│
├── notesapp/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
│
├── nginx/
│   ├── Dockerfile
│   └── default.conf
│
├── data/
│   └── mysql/
│       └── db/              # MySQL database files
│
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env
├── .gitignore
└── manage.py
```

> `data/mysql/db/` is used as a Docker bind mount for persistent MySQL storage.

---

# 🐳 Docker Compose Services

The application contains three services:

| Service      | Container Name     | Port | Purpose        |
| ------------ | ------------------ | ---: | -------------- |
| `django_app` | `django_container` | 8000 | Django backend |
| `nginx`      | `nginx-container`  |   80 | Reverse proxy  |
| `mysql_db`   | `mysql-container`  | 3306 | MySQL database |

All services use the same Docker network:

```text
notes-app
```

---

# 🌐 Docker Network

All containers are connected to:

```yaml
networks:
  - notes-app
```

This allows containers to communicate using **Docker Compose service names**.

```text
Nginx
  │
  └── django_app:8000
          │
          └── mysql_db:3306
```

Do not use container IP addresses for normal service communication.

Docker provides internal DNS for service names.

---

# 🗄️ MySQL Configuration

MySQL is configured as:

```yaml
mysql_db:
  image: mysql
  container_name: mysql-container

  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: test_db
```

MySQL listens internally on:

```text
3306
```

---

# 💾 MySQL Persistent Storage

MySQL uses a **Docker bind mount** instead of a Docker named volume.

```yaml
volumes:
  - ./data/mysql/db:/var/lib/mysql
```

There are two important parts:

```text
./data/mysql/db
       │
       └── Directory on the EC2/project host

/var/lib/mysql
       │
       └── Directory INSIDE the MySQL container
```

Therefore:

```yaml
- ./data/mysql/db:/var/lib/mysql
```

means:

> Mount the `data/mysql/db` directory from the project into `/var/lib/mysql` inside the MySQL container.

---

## 📂 Bind Mount Architecture

```text
EC2 Host / Project
       │
       ▼
django-notes-app/
       │
       └── data/
            └── mysql/
                 └── db/
                      │
                      │ bind mount
                      ▼
              MySQL Container
                      │
                      ▼
               /var/lib/mysql
                      │
                      ├── Database files
                      ├── Tables
                      └── MySQL data
```

---

## 📁 Create MySQL Data Directory

Create the directory from the project root:

```bash
mkdir -p data/mysql/db
```

Docker will then use this directory for MySQL's persistent data.

You do **not** need to manually create MySQL database files.

---

## 🔍 Check MySQL Data Directory

From the project directory:

```bash
ls -la data/mysql/db
```

After MySQL starts, database files should appear inside this directory.

---

## ⚠️ Important

Do not commit the MySQL database files to Git.

Add the following to `.gitignore`:

```text
data/mysql/db/
```

This prevents MySQL's internal database files from being committed to the repository.

---

# 🔐 Environment Variables

Create a `.env` file:

```env
DB_NAME=test_db
DB_USER=root
DB_PASSWORD=root
DB_HOST=mysql_db
DB_PORT=3306
```

Django receives these variables through:

```yaml
env_file:
  - ".env"
```

### Important

Inside Docker:

```env
DB_HOST=mysql_db
```

Do **not** use:

```env
DB_HOST=localhost
```

because `localhost` inside the Django container refers to the Django container itself.

The correct connection is:

```text
Django Container
       │
       │ mysql_db:3306
       ▼
MySQL Container
```

---

# 🐍 Django Database Configuration

Django uses MySQL through environment variables:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.getenv("DB_NAME"),
        'USER': os.getenv("DB_USER"),
        'PASSWORD': os.getenv("DB_PASSWORD"),
        'HOST': os.getenv("DB_HOST"),
        'PORT': os.getenv("DB_PORT"),
    }
}
```

The database flow is:

```text
Django
   │
   ▼
mysql_db:3306
   │
   ▼
MySQL
   │
   ▼
./data/mysql/db
```

Django no longer uses the SQLite `db.sqlite3` database when configured for MySQL.

---

# 📦 MySQL Python Driver

Django's MySQL backend requires `mysqlclient`.

`requirements.txt` contains:

```text
mysqlclient==2.1.1
```

The Dockerfile installs the required system dependencies:

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    pkg-config \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*
```

---

# 🚀 Start the Application

Build and start all services:

```bash
docker compose up -d --build
```

Check containers:

```bash
docker ps
```

Expected:

```text
nginx-container
django_container
mysql-container
```

---

# 🔍 Check Container Status

```bash
docker compose ps
```

Expected:

```text
nginx-container     Up
django_container    Up (healthy)
mysql-container     Up (healthy)
```

---

# 📜 View Logs

### Django

```bash
docker compose logs django_app
```

Follow logs:

```bash
docker compose logs -f django_app
```

### Nginx

```bash
docker compose logs nginx
```

### MySQL

```bash
docker compose logs mysql_db
```

---

# 🔄 Django Migration

The Django container automatically runs:

```bash
python manage.py migrate --noinput
```

before starting Gunicorn.

The container command is:

```bash
sh -c "python manage.py migrate --noinput &&
       gunicorn notesapp.wsgi:application --bind 0.0.0.0:8000"
```

Therefore, Django migrations are applied when the container starts.

---

# 🔎 Verify Django Uses MySQL

Run:

```bash
docker exec django_container python manage.py shell -c \
"from django.conf import settings; print(settings.DATABASES['default'])"
```

Expected:

```text
ENGINE = django.db.backends.mysql
NAME   = test_db
USER   = root
HOST   = mysql_db
PORT   = 3306
```

It should **not** show:

```text
django.db.backends.sqlite3
```

---

# 🗃️ Check MySQL Database

Enter MySQL:

```bash
docker exec -it mysql-container mysql -u root -p
```

Password:

```text
root
```

Select the database:

```sql
USE test_db;
```

Check tables:

```sql
SHOW TABLES;
```

Django should have created its migration and application tables.

---

# 🔀 Nginx Reverse Proxy

Nginx is the public entry point and forwards requests to Django.

Nginx configuration:

```nginx
upstream django {
    server django_app:8000;
}

server {
    listen 80;

    server_name _;

    location / {
        proxy_pass http://django;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

The important part is:

```nginx
server django_app:8000;
```

Nginx communicates with Django through the Docker network using:

```text
django_app
```

---

# 🌍 Access the Application

Nginx exposes:

```yaml
ports:
  - "80:80"
```

Therefore access the application using:

```text
http://EC2-PUBLIC-IP/
```

You do not need:

```text
http://EC2-PUBLIC-IP:8000/
```

when Nginx is the public entry point.

---

# 🔐 AWS EC2 Security Group

For public access through Nginx, allow:

```text
Type: HTTP
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

Port `8000` does not need to be publicly accessible when Nginx is used as the public entry point.

The request flow is:

```text
Internet
    │
    │ :80
    ▼
EC2
    │
    ▼
Nginx
    │
    │ Docker Network
    ▼
Django :8000
```

---

# 🐛 Problems Faced During Setup

## 1. Django Container Was Unhealthy

The Django container can become unhealthy when the Docker healthcheck points to an endpoint that does not exist.

Example:

```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:8000/health || exit 1"]
```

If Django does not provide:

```text
/health
```

the healthcheck fails with:

```text
404 Not Found
```

### Solution

Create a Django health endpoint or configure the healthcheck to use an existing valid endpoint.

Example:

```python
from django.http import JsonResponse


def health(request):
    return JsonResponse({"status": "ok"})
```

Then add:

```python
path('health', health),
```

The healthcheck can then use:

```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:8000/health || exit 1"]
```

---

# 🐛 2. Django Container Was Restarting

After switching Django from SQLite to MySQL:

```text
django_container   Restarting
```

The logs showed:

```text
ModuleNotFoundError: No module named 'MySQLdb'
```

### Cause

Django's MySQL backend requires the `mysqlclient` Python package.

### Solution

Add:

```text
mysqlclient==2.1.1
```

to:

```text
requirements.txt
```

The Dockerfile also needs the required system dependencies:

```text
default-libmysqlclient-dev
pkg-config
gcc
```

Then rebuild:

```bash
docker compose down
docker compose up -d --build
```

---

# 🐛 3. Old Notes Appeared After Changing Database Configuration

The application was originally configured to use SQLite.

The SQLite database was:

```text
db.sqlite3
```

Changing or removing MySQL storage does not remove the SQLite database.

### Previous Architecture

```text
Django
   │
   ▼
SQLite
   │
   ▼
db.sqlite3
```

### Final Architecture

```text
Django
   │
   ▼
mysql_db:3306
   │
   ▼
MySQL
   │
   ▼
./data/mysql/db
```

---

# 🐛 4. Understanding Docker Bind Mounts

The following configuration:

```yaml
volumes:
  - ./data/mysql/db:/var/lib/mysql
```

has two paths:

```text
./data/mysql/db
       │
       └── Host / Project directory


/var/lib/mysql
       │
       └── Directory inside MySQL container
```

The left side is controlled by you.

The right side is the MySQL container's internal data directory.

---

# 🐛 5. Bind Mount vs Named Volume

### Named Volume

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

Docker manages the storage location.

Example:

```text
mysql-data
     │
     ▼
Docker-managed storage
     │
     ▼
/var/lib/mysql
```

### Bind Mount

```yaml
volumes:
  - ./data/mysql/db:/var/lib/mysql
```

You control the storage location.

Example:

```text
Project
   │
   ▼
data/mysql/db
   │
   ▼
/var/lib/mysql
```

For this project, the MySQL database is stored using a **bind mount**.

---

# 🐛 6. Understanding Nginx → Django Communication

The Nginx configuration uses:

```nginx
upstream django {
    server django_app:8000;
}
```

The Compose service is:

```yaml
django_app:
```

while its container name is:

```yaml
container_name: django_container
```

These are different concepts.

For Docker Compose service communication, the service name is used:

```text
django_app
```

Therefore:

```text
Nginx
   │
   │ django_app:8000
   ▼
Django
```

is the correct configuration.

---

# 🧪 Connectivity Testing

## Test Django directly

```bash
curl http://localhost:8000
```

## Test Nginx

```bash
curl http://localhost
```

## Test Django from Nginx

```bash
docker exec nginx-container curl http://django_app:8000
```

## Test Nginx configuration

```bash
docker exec nginx-container nginx -t
```

Expected:

```text
syntax is ok
test is successful
```

---

# 🔧 Useful Docker Commands

### List running containers

```bash
docker ps
```

### List all containers

```bash
docker ps -a
```

### View logs

```bash
docker logs django_container
```

### Follow logs

```bash
docker logs -f django_container
```

### Stop container

```bash
docker stop django_container
```

### Remove container

```bash
docker rm django_container
```

### List images

```bash
docker images
```

### Remove image

```bash
docker rmi django_app
```

### List volumes

```bash
docker volume ls
```

### List networks

```bash
docker network ls
```

---

# 🐳 Docker Compose Commands

### Start

```bash
docker compose up -d
```

### Build and start

```bash
docker compose up -d --build
```

### Stop and remove containers

```bash
docker compose down
```

### Rebuild without cache

```bash
docker compose build --no-cache
```

### Check services

```bash
docker compose ps
```

### View logs

```bash
docker compose logs
```

### Follow logs

```bash
docker compose logs -f
```

### ⚠️ About `docker compose down -v`

```bash
docker compose down -v
```

removes Compose-managed **named volumes**.

Since MySQL is now using a bind mount:

```yaml
./data/mysql/db:/var/lib/mysql
```

the MySQL data stored in:

```text
data/mysql/db/
```

is not a Docker named volume.

However, avoid deleting the `data/mysql/db/` directory manually unless you intentionally want to delete the MySQL database.

---

# 📊 Final Deployment Architecture

```text
                         Internet
                            │
                            │ HTTP :80
                            ▼
                    ┌────────────────┐
                    │      EC2       │
                    │                │
                    │   Nginx :80    │
                    └───────┬────────┘
                            │
                            │ Docker Network
                            │ django_app:8000
                            ▼
                    ┌────────────────┐
                    │ Django/Gunicorn│
                    │      :8000     │
                    └───────┬────────┘
                            │
                            │ mysql_db:3306
                            ▼
                    ┌────────────────┐
                    │     MySQL      │
                    │      :3306     │
                    └───────┬────────┘
                            │
                            │ Bind Mount
                            ▼
                    ┌────────────────┐
                    │ data/mysql/db  │
                    │  EC2 Project   │
                    └────────────────┘
```

---

# 🔑 Key Concepts

### Nginx Reverse Proxy

```text
EC2 :80
   ↓
Nginx
   ↓
Django :8000
```

### Docker Network

```text
nginx → django_app:8000
django → mysql_db:3306
```

### Docker Bind Mount

```text
./data/mysql/db
       ↓
/var/lib/mysql
```

Where:

```text
./data/mysql/db
= Directory on EC2/project host

/var/lib/mysql
= Directory inside MySQL container
```

### Final Stack

```text
Nginx
  ↓
Django + Gunicorn
  ↓
MySQL
  ↓
./data/mysql/db
```

---

# ✅ Final Result

The complete application runs using:

```text
EC2
 │
 │ Port 80
 ▼
Nginx Container
 │
 │ Docker Network
 ▼
Django Container
 │
 │ Docker Network
 ▼
MySQL Container
 │
 │ Bind Mount
 ▼
data/mysql/db/
```

This setup provides a clean **Nginx → Django → MySQL** Docker deployment with persistent MySQL database storage directly inside the project directory.

