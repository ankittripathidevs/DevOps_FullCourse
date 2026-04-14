# Docker Compose
- A tool used to run multi-container applications using a single file called docker-compose.yml.
- Instead of running multiple docker run commands manually, you can define all services in one YAML file and start them together with one command.


```bash
# Commands
1️⃣ Start All Services
docker compose -f fileName.yaml up -d

🔍 Explanation:
up → Create + Start all containers
-d → Run in Detached mode (background)
-f → Specify compose file
fileName.yaml → Example: mongodb.yaml, app.yaml
```

```bash
2️⃣ Stop & Remove All Services
docker compose -f fileName.yaml down

🔍 Explanation:
down → Stops and removes containers, networks, images (if created by compose)
```

```bash
# Shortcuts (When File Name Is Default)
- docker-compose.yaml

# If your file is named docker-compose.yaml, you can run:
- docker compose up -d
- docker compose down
```

```bash
# Docker Compose File Example

version: "3.8"

services:
  mongo:
    image: mongo
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: qwerty

  mongo-express:
    image: mongo-express
    ports:
      - "8081:8081"
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: admin
      ME_CONFIG_MONGODB_ADMINPASSWORD: qwerty
      ME_CONFIG_MONGODB_URL: mongodb://admin:qwerty@mongo:27017/
```

```bash
# Think to remember
✔ Compose = Multi-container manager
✔ up = build + create + start
✔ down = stop + remove
✔ -d = background mode
✔ -f = use specific YAML file
```

```bash
    Command	                   Meaning
docker compose up	      Start all services
docker compose down	      Stop all services
docker compose ps	      List running services
docker compose logs	      Show logs
docker compose restart	  Restart all services
docker compose pull	      Update images
```

# Instructor 
- Apna College
