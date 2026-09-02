# Node.js App — Docker

A simple **Node.js application** containerized using Docker with the official Node.js Alpine image.

## Tech Stack

* Node.js 22
* Node.js Alpine
* Docker

## Project Structure

```text
03_node-app/
├── Dockerfile
├── README.md
├── package.json
├── package-lock.json
└── server.js
```

## Dockerfile

The Dockerfile:

1. Uses **Node.js 22 Alpine**
2. Sets `/app` as the working directory
3. Copies package files and installs dependencies
4. Copies the application code
5. Exposes port `3000`
6. Starts the app with `node server.js`

## Build Image

```bash
docker build -t node-app .
```

## Run Container

```bash
docker run -d -p 3000:3000 --name node-container node-app
```

## Access App

### Local

```text
http://localhost:3000
```

### AWS EC2

```text
http://<EC2-PUBLIC-IP>:3000
```

> Make sure port **3000** is allowed in the EC2 Security Group.

## Check Container

```bash
docker ps
```

## Stop & Remove Container

```bash
docker rm -f node-container
```

