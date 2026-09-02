# Flask App — Docker on AWS EC2

A minimal **Flask web application** containerized with Docker and deployed on an **AWS EC2 instance**.

![Python](https://img.shields.io/badge/Python-3.14-blue)
![Flask](https://img.shields.io/badge/Flask-3.1.1-green)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED)
![AWS EC2](https://img.shields.io/badge/AWS-EC2-FF9900)

## Features

* Simple Flask web application
* Dockerized using a single `Dockerfile`
* `/health` endpoint for health checks
* Runs on EC2 port `80`

## Tech Stack

| Component  | Technology  |
| ---------- | ----------- |
| Framework  | Flask 3.1.1 |
| Runtime    | Python 3.14 |
| Container  | Docker      |
| Deployment | AWS EC2     |

## Project Structure

```text
flask-app-ec2/
├── app.py
├── run.py
├── requirements.txt
├── templates/
│   └── index.html
└── Dockerfile
```

## Run Locally

```bash
pip install -r requirements.txt
python run.py
```

Open:

```text
http://localhost:80
```

## Run with Docker

### Build Image

```bash
docker build -t flask-app .
```

### Run Container

```bash
docker run -d -p 80:80 --name flask-app flask-app
```

Check:

```bash
docker ps
```

## Endpoints

| Route     | Description              |
| --------- | ------------------------ |
| `/`       | Flask landing page       |
| `/health` | Application health check |

## AWS EC2 Deployment

After installing Docker on the EC2 instance:

```bash
docker build -t flask-app .
docker run -d -p 80:80 --name flask-app flask-app
```

Make sure **port 80** is allowed in the EC2 Security Group.

### Access the Application

```text
http://<EC2-PUBLIC-IP>:80
```

### Health Check

```text
http://<EC2-PUBLIC-IP>:80/health
```

Expected response:

```text
Server is up and running
```

