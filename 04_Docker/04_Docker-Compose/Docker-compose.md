==============================================================================================
                    DOCKER COMPOSE
                         DAY-3
==============================================================================================

🌸 WHAT IS DOCKER COMPOSE?
-->  Docker Compose = Manage multiple containers using one file.

# Instead of running multiple `docker run` commands, we define the configuration in one file.
-->  docker-compose.yml or
-->  docker-compose.yaml

# Then start everything with
-->  docker compose up


===============================================================
🌸 BASIC DOCKER COMPOSE FILE
===============================================================
# Example

   services:

      mysql:
        image: mysql:9.7

      flask-app:
        build: .


===============================================================
🌸 IMPORTANT OPTIONS
===============================================================
(1) services
-->  Defines the containers/services

(2) image
-->  Specifies an existing Docker image

     image: mysql:9.7

(3) build
-->  Builds an image using a Dockerfile

     build: .

(4) ports
-->  Maps Host Port : Container Port

     ports:
       - "5000:5000"

(5) environment
-->  Passes environment variables to the container

     environment:
       MYSQL_ROOT_PASSWORD: root

(6) depends_on
-->  Controls the startup order of services.

     depends_on:
       - mysql

(7) volumes
-->  Used to persist data, especially MySQL data.

     volumes:
       - mysql-data:/var/lib/mysql

(8) networks
-->  Connects services to a specific Docker network

     networks:
       - two-tier

(9) healthcheck
-->  Checks whether a container/service is healthy

     healthcheck:
       test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
       interval: 10s
       timeout: 5s
       retries: 5

(10) restart
-->  Defines when Docker should automatically restart a container

     restart: always


===============================================================
🌸 FLASK + MYSQL DOCKER COMPOSE
===============================================================
docker-compose.yml

    services:

      mysql:
        image: mysql:9.7
        container_name: mysql-container

        ports:
          - "3606:3606"

        environment:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: devops
          MYSQL_USER: admin
          MYSQL_PASSWORD: admin

        volumes:
          - mysql-data:/var/lib/mysql

        networks:
          - two-tier

        restart: always

        healthcheck:
          test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-proot"]
          interval: 10s
          timeout: 5s
          retries: 5
          start_period: 60s

      flask-app:
        build:
          context: .

        container_name: flask-container

        ports:
          - "5000:5000"

        environment:
          MYSQL_HOST: mysql
          MYSQL_USER: root
          MYSQL_PASSWORD: root
          MYSQL_DB: devops

        depends_on:
          mysql:
            condition: service_healthy

        networks:
          - two-tier

        restart: always

        healthcheck:
          test: ["CMD-SHELL", "curl -f http://localhost:5000/health || exit 1"]
          interval: 10s
          timeout: 5s
          retries: 5
          start_period: 30s

    networks:
      two-tier:

    volumes:
      mysql-data:


===============================================================
🌸 IMPORTANT: MYSQL_HOST
===============================================================
Here:

# MYSQL_HOST: mysql
-->  `mysql` is the MySQL service name, not mysql-container name.

     services:
          mysql:

          flask-app:


===============================================================
🌸 IMPORTANT DOCKER COMPOSE COMMANDS
===============================================================
(1) Start containers:
-  docker compose up

(2) Start in background:
-  docker compose up -d

(3) Build and start:
-  docker compose up --build

(4) Check containers:
-  docker compose ps
-  docker compose ps -a

(5) View logs:
-  docker compose logs

(6) View logs continuously:
-  docker compose logs -f

(7) Stop containers:
-  docker compose stop

(8) Stop & remove containers:
-  docker compose down

(9) Restart containers:
-  docker compose restart

(10) Enter a container:
-  docker compose exec mysql-container bash


===============================================================
🌸 CHECK MYSQL
===============================================================
# Enter MySQL:
-  docker compose exec mysql-container mysql -u root -p

# Then Enter
-  SHOW DATABASES;
-  USE devops;
-  SHOW TABLES;
-  SELECT * FROM messages;


===============================================================
🌸 COMMON CHECKS
===============================================================
(1) Check containers:
-  docker compose ps

(2) Check Flask logs:
-  docker compose logs flask-app

(3) Check MySQL logs:
-  docker compose logs mysql

(4) Check Docker networks:
-  docker network ls

(5) Check Docker Volumes:
-  docker volume ls

(6) Check listening TCP ports on EC2:
-  sudo ss -ltnp


===============================================================
🌸 IMPORTANT CONCEPT
===============================================================
# Without Compose:
   docker network create
   docker volume create
   docker run mysql
   docker run flask

# With Compose:
   docker compose up -d

# Everything is defined inside:
   docker-compose.yml

# Key concept:

    Flask
      |
      | MYSQL_HOST=mysql
      v
    MySQL


===============================================================
🌸 DOCKER CLEANUP COMMANDS
===============================================================
(1) Remove unused Docker resources:
-  docker system prune

(2) Force remove all Docker images:
-  docker rmi -f $(docker images -aq)