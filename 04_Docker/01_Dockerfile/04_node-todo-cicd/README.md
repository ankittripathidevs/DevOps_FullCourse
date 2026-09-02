# Node Todo App — Docker on AWS EC2

A simple **Node.js Todo application** containerized with Docker and deployed on an **AWS EC2 instance**.

## Tech Stack

* Node.js 22
* Express.js
* EJS
* Docker
* AWS EC2

## Project Structure

```text
04_node-todo-cicd/
├── Dockerfile
├── README.md
├── app.js
├── package.json
├── package-lock.json
├── test.js
└── views/
```

## Dockerfile

The Dockerfile:

1. Uses **Node.js 22 Alpine**
2. Sets `/app` as the working directory
3. Copies package files
4. Copies application code
5. Installs dependencies
6. Runs tests using `npm run test`
7. Exposes port `8000`
8. Starts the application with `node app.js`

## Build Image

```bash
docker build -t node-todo-app .
```

## Run Container

```bash
docker run -d -p 8000:8000 --name node-todo-container node-todo-app
```

## Access Application

### Local

```text
http://localhost:8000/todo
```

### AWS EC2

```text
http://<EC2-PUBLIC-IP>:8000/todo
```

> Make sure port **8000** is allowed in the EC2 Security Group.

## Check Container

```bash
docker ps
```

## Stop & Remove Container

```bash
docker rm -f node-todo-container
```

