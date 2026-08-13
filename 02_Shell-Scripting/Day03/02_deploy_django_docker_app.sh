#!/bin/bash

set -e

APP_NAME="notes-app"
IMAGE_NAME="notes-app"
APP_DIR="django-notes-app"
PORT="8000"

echo "********** DEPLOYMENT STARTED **********"

# Clone application if it doesn't exist
if [ -d "$APP_DIR" ]; then
    echo "Application directory already exists."
else
    echo "Cloning Django application..."
    git clone https://github.com/ankittripathidevs/Django-Notes-App.git "$APP_DIR"
fi

cd "$APP_DIR"

# Build Docker image
echo "Building Docker image..."
docker build -t "$IMAGE_NAME:latest" .

# Remove old container if it exists
 if docker ps -a --format '{{.Names}}' | grep -q "^${APP_NAME}$"; then
    echo "Removing old container..."
    docker rm -f "$APP_NAME"
fi

# Run new container
echo "Starting Django container..."
docker run -d \
    --name "$APP_NAME" \
    --restart unless-stopped \
    -p "$PORT:8000" \
    "$IMAGE_NAME:latest"

echo "Waiting for application..."
sleep 5

# Check container
if docker ps --format '{{.Names}}' | grep -q "^${APP_NAME}$"; then
    echo "Container is running."
else
    echo "Container failed to start."
    docker logs "$APP_NAME"
    exit 1
fi

echo "********** DEPLOYMENT DONE **********"
echo "Application: http://<EC2-PUBLIC-IP>:8000"
