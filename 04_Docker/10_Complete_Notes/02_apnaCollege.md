#### 🐳 Docker
- A Tool to run an application inside container (Containerization Tool)
- Dockerfile --> Docker Image --> Docker Container


#### 🐳 Docker Commands Cheat Sheet
| No |  Command                                  |  Meaning                                                         |
| ---| ----------------------------------------- | -----------------------------------------------------------------|
| 1  | `docker`                                  | Show all Docker Commands                                         |
| 2  | `docker -v`                               | Check Docker Installed version                                   |
| 3  | `docker ps`                               | Show all **active (running)** containers *(ps = process status)* |
| 4  | `docker ps -a`                            | Show **all containers** (running +stopped)                       |
| 5  | `docker images`                           | List all Docker images                                           |
| 6  | `docker volume ls`                        | List all volumes                                                 |
| 7  | `docker network ls`                       | List all networks                                                |
| 8  | `docker rm <Container_Id/Name>`           | Remove a container *(must be stopped first)*                     |
| 9  | `docker rmi <Image_Name>`                 | Remove an image *(only deletes image, not containers)*           |
| 10 | `docker logs <Container_Name>`            | View container logs                                              |
| 11 | `docker exec -it <Container_Id> /bin/bash`| Open terminal inside a running container                         |


#### 🔥 Bonus (Very Useful Commands)
| No | Command                          | Meaning                                       |
| ---| -------------------------------- | --------------------------------------------- |
| 1  | `docker run -d -p 8080:80 nginx` | Run container in background with port mapping |
| 2  | `docker stop <Cont_Id>`          | Stop a container                              |
| 3  | `docker start <Cont_Id>`         | Start a container                             |
| 4  | `docker build -t app .`          | Build Docker image                            |
| 5  | `docker pull nginx`              | Download image from Docker Hub                |


#### 🐳 Docker Images
1. List all Local Images 
- docker images  
 
2. Delete an Image 
- docker rmi <image_name> 
 
3. Remove unused images 
- docker image prune  
 
4. Build an image from a Dockerfile
- docker build -t <image_name>:<version> .            // version is optional 


#### 🐳  Docker Conatiner
1. List all running containers
- docker ps

2. List all Local containers (running & stopped) 
- docker ps -a

3. Rename Existing Container
- docker rename <old_ContainerName> <new_ContainerName>

4. Create & run a new container
- docker run <image_Name>
// if image not available locally, it’ll be downloaded from DockerHub

5. Run container in background
- docker run -d <image_name>

6. Run container with custom name
- docker run --name <container_name> <image_name>


**********************************************************************************************************************
#### (1) Pull an image  (Downloads a Docker image from a registry (like Docker Hub) to your local system)
- docker pull <Image_Name>
- docker pull <Image_Name>: < version>

Example
- docker pull mysql
 
#### (2) List all images (shows all images downloaded on your system)
- docker images

#### (3) Run an image (creates NEW container) 
- docker run ubuntu  
- creates a new container every time when you run this command

#### (4) Run container with interactive terminal (Runs an Ubuntu container and opens an interactive terminal inside it)
1. docker run -it <Image_Name>

Example
- docker run -it ubuntu

2. docker run -d --name <custom_containerName>  <Image_Name>

Where
- i → interactive
- t → terminal (shell)
- d → detached mode (run container in background)
- Start the container
- Run it in the background
- NOT attach your terminal to it


#### (5) Start an existing container [Starts a stopped container does NOT create new one]
- docker start <Conatiner_Name> or <Container_Id>

#### (6) Stop a running container
- docker stop <Conatiner_Name> or <Container_Id>


***************************************************************************
#### 🎯 mysql
- docker run -d -e MYSQL_ROOT_PASSWORD=secret mysql

where
(1)  docker run → Start a new container
(2) -d →  Run in background (detached mode)
(3) -e MYSQL_ROOT_PASSWORD=secret → Set environment variable inside container (This sets MySQL root password = secret)
(4) mysql → Image name


***********************************************************************
#### 🎯 mysql (custom ContaineName)
- docker run -d -e MYSQL_ROOT_PASSWORD=secret --name <custom_containerName> mysql:tag

where
(1) --name custom_name → Give your container a custom name
(2) mysql:tag → Image name with version tag
    Example:- mysql:latest, mysql:8, mysql:5.7

************************************************************************
#### 🎯 mysql (Port Binding)
- docker run -d -e MYSQL_ROOT_PASSWORD=secret --name mysql-latest -p 8080:3306  mysql

Where
(1) -p HOST_PORT:CONTAINER_PORT

(2) HOST_PORT (Outside container, your laptop)
    8080 :- This is the port you will use on your computer to connect.

(3) CONTAINER_PORT (Inside container)
    3306 :- This is MySQL’s default internal port inside the container.

Notes:
--> If you connect to: localhost:8080
--> It will forward to: container:3306


✅  8080 a random number (you can choose any free port)
--> -p 5000:3306
--> -p 7000:3306
--> -p 1234:3306

✅ 3306 is NOT random
--> 3306 is fixed because MySQL always runs inside the container on this port.
Example : -p 8080:3306

*********************************************************************************************************
🎯 mysql
--> docker exec -it Conatiner_Name/Id /bin/bash:- This open a terminal inside a running Docker container.

Let’s break it down:
(1) docker exec:- Run a command inside an already running container
(2) -i:- Interactive mode Keeps the session open so you can type commands
(3) -t:- Allocates a TTY (terminal screen)
(4) -it:- Allows you to use the container’s shell normally
(5) Container_Name:- The ID or name of the running container
    Example:- 4d56c24da4f or mysql-container
(6) /bin/bash:- This tells Docker, Open a Bash shell inside the container
(7) Some containers don’t have bash → then you use /bin/sh :- docker exec -it Container_Name /bin/sh

******************************************************************************
--> Node js applicaltion ke ander jo setup kiye hai-
--> We are using ankit-db database but not present in our local machine.
--> We are using mangodb database (Esme hm setup krege with the help of container)

--> Actually hamare Nodejs application ko mongodb data base chaiye tha but hm usko apne local machine pe setup nhi krenge.
--> Hm mongodb ko setup krenge using docker container.
--> Container ke ander he appication intract kr ke data store krwaegi aur fetch kregi.
--> mongo 
--> mongo-express

************************************************************************************************************
🎯 Docker Network
  (1) List docker Network
   --> docker network ls

  (2) Create a docker Network
   Example:- docker network create mango-network

  (3) Remove docker Network
   Example:- docker network rm mongo-network

*****************************************************************************************************************
🎯  For Mongo
--> docker run -d --name mymango-latest -p 27017:27017 --network mymango-network -e MONGO_INITDB_ROOT_USERNAME:admin -e MONGO_INITDB_ROOT_PASSWORD:qwerty mongo

Line by Line
PS C:\Users\ankit\OneDrive\Desktop\docker-testapp> docker run -d \
>> -p 27017:27017 \
>> --name mongo \
>> --network mongo-network \
>> -e MONGO_INITDB_ROOT_USERNAME:admin \
>> -e MONGO_INITDB_ROOT_PASSWORD:qwerty  \
>> mongo

****************************************************************************************************************
 🎯 For Mongo-Express
--> docker run -d --name mango-express -p 8081:8081 --network mongo-network  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin 
-e ME_CONFIG_MONGODB_ADMINPASSWORD=qwerty -e ME_CONFIG_MONGODB_URL="mongodb://admin:qwerty@mongo:27017"  mongo-express

Line By Line
PS C:\Users\ankit\OneDrive\Desktop\docker-testapp> docker run -d \
>> -p8081:8081 `
>> --name mongo-express `
>> --network mongo-network `
>> -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin `
>> -e ME_CONFIG_MONGODB_ADMINPASSWORD=qwerty `
>> -e ME_CONFIG_MONGODB_URL="mongodb://admin:qwerty@mongo:27017" `
>> mongo-express

--> run node server.js
--> localhost: 8081
--> localhost: 5050/getUsers

*****************************************************************************************************************
🎯 Docker Compose
--> A tool used to run multi-container applications using a single file called docker-compose.yml
--> Instead of running many docker run commands manually, you define everything in one YAML file and start all services with


# Commands
(1) Start All Services
--> docker compose -f fileName.yaml up -d

🔍 Explanation:
up → Create + Start all containers
-d → Run in Detached mode (background)
-f → Specify compose file
fileName.yaml → Example: mongodb.yaml, app.yaml


(2) Stop & Remove All Services
--> docker compose -f fileName.yaml down
🔍 Explanation:
   down → Stops and removes containers, networks, images (if created by compose)


(3) If your file is named docker-compose.yaml(default), you can run:
--> docker compose up -d
--> docker compose down


🎯 Some Important Commands
      Command	                  Meaning
(1) docker compose up	      Start all services
(2) docker compose down	      Stop all services
(3) docker compose ps	      List running services
(4) docker compose logs	      Show logs
(5) docker compose restart    Restart all services
(6) docker compose pull	      Update images

*******************************************************************************************************
🎯  Example of mongodb compose file 
    mangodb.yaml file

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



# https://docs.docker.com/

🎯 Dockerizing-node-app
Create Dockerfile old way

# (1) Use official Node.js image
FROM node

# (2) Env variables (not secure, but ok for learning)
ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PASSWORD=qwerty

# (3) Create folder inside container
RUN mkdir -p dockerizing-node-app

# (4) Copy project to container
COPY . /dockerizing-node-app

# (5) Start the app
CMD ["node", "/dockerizing-node-app/server.js"]

*****************************************************************************************************************
🎯  Dockerfile (clean version)
FROM node

WORKDIR /dockerizing-node-app

COPY package*.json .

RUN npm install

COPY . .

CMD ["node", "server.js"]


(1) Build Docker Image
--> docker build -t dockerizing-node-app:1.0  .

  -t:- Tag → gives name & version to the image
   dockerizing-node-app:- custom ImageName
   1.0:- Image version
   .:- Build context (current folder)

(2) Run Docker Container
--> docker run --name node-container -p 3000:3000 dockerizing-node-app:1.0


(3) Run in background
--> docker run -d --name node-container -p 3000:3000 dockerizing-node-app:1.0

(4) Running Without Ports
--> docker run --name node-container dockerizing-node-app:1.0


Interactive Mode:
docker run -it dockerizing-node-app:1.0
docker run -it dockerizing-node-app:1.0 bash

🎯 Stop Container
--> docker stop node-container

🎯 Remove Container
--> docker rm node-container

**************************************************************************
🎯 Publishing Docker Images on Docker Hub
Step:1 Account setting >>> My Profile >>>
Setp:2 My Hub >>> Repositories
Step:3 Create a Repositories
Step:4 Come to terminal where your project is (vs-code)
Setp:5 Run this command in termianl 
       docker build -t ankittripathidocker/docker-reactapp .
Where: 
ankittripathidocker/docker-reactapp:- This is your repositries

Step:6 docker push ankittripathidocker/docker-reactapp

*****************************************************************************

🎯 Docker Volumes
--> Volume are persistent data stores for containers.

