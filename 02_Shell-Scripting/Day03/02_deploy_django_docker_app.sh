#!/bin/bash


<< task 
Deploy Django + SQLLite using Docker and handle repeated deployments safely
task


# Exit immediately if any command fails
set -e


# -------------------------------------------------------
# Variables
# -------------------------------------------------------

APP_NAME="notes-app"
IMAGE_NAME="notes-app"
APP_DIR="django-notes-app"
PORT="8000"


# -------------------------------------------------------
# (1) Clone Django repository
# -------------------------------------------------------

code_clone() {
    echo "Cloning the Django application..."

    if [ -d "$APP_DIR" ]; then
        echo "Application directory already exists."
    else
        echo "Cloning Django application..."
        git clone https://github.com/ankittripathidevs/Django-Notes-App.git "$APP_DIR"
    fi

    cd "$APP_DIR"
}


# -------------------------------------------------------
# (2) Build Docker image
# -------------------------------------------------------

build_image() {
    echo "Building Docker image..."

    docker build -t "$IMAGE_NAME:latest" .
}


# -------------------------------------------------------
# (3) Remove old container
# -------------------------------------------------------

remove_old_container() {
    if docker ps -a --format '{{.Names}}' | grep -q "^${APP_NAME}$"; then
        echo "Removing old container..."
        docker rm -f "$APP_NAME"
    else
        echo "No old container found."
    fi
}


# -------------------------------------------------------
# (4) Run Docker container
# -------------------------------------------------------

run_container() {
    echo "Starting Django container..."

    docker run -d \
        --name "$APP_NAME" \
        --restart unless-stopped \
        -p "$PORT:8000" \
        "$IMAGE_NAME:latest"
}


# -------------------------------------------------------
# (5) Check container
# -------------------------------------------------------

check_container() {
    echo "Waiting for application..."
    sleep 5

    if docker ps --format '{{.Names}}' | grep -q "^${APP_NAME}$"; then
        echo "Container is running."
    else
        echo "Container failed to start."
        docker logs "$APP_NAME"
        exit 1
    fi
}


# -------------------------------------------------------
# Main deployment script
# -------------------------------------------------------

echo "---------------------------------------"
echo "        DEPLOYMENT STARTED             "
echo "---------------------------------------"


# (1) Clone application
if ! code_clone; then
    echo "Error: Failed to clone application."
    exit 1
fi


# (2) Build Docker image
if ! build_image; then
    echo "Error: Failed to build Docker image."
    exit 1
fi


# (3) Remove old container
if ! remove_old_container; then
    echo "Error: Failed to remove old container."
    exit 1
fi


# (4) Run new container
if ! run_container; then
    echo "Error: Failed to start Docker container."
    exit 1
fi


# (5) Check container
if ! check_container; then
    echo "Error: Container health check failed."
    exit 1
fi


echo "---------------------------------------"
echo "        DEPLOYMENT DONE                "
echo "---------------------------------------"

echo "Application: http://<EC2-PUBLIC-IP>:8000"

