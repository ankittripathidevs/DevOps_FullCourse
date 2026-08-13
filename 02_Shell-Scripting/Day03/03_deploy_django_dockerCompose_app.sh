#!/bin/bash

<< task
Deploy Django + MySQL using docker-compose and handle repeated deployments safely
task

# Exit immediately if any command fails
set -e

# -------------------------------------------------------
# (1) Clone Django repository or update existing repositor
# -------------------------------------------------------

code_clone() {
    echo "Cloning the Django app........"

    if [ -d "django-notes-app" ]; then
        echo "Application already exists. Updating code........"
        cd django-notes-app
        git pull
    else
        echo "Cloning application........"
       	git clone https://github.com/ankittripathidevs/django-notes-app.git
        cd django-notes-app
    fi
}


# ------------------------------------------------------
# (2) Function to install required dependencies
# -----------------------------------------------------

install_requirements() {
    echo "Installing dependencies......"
    sudo apt-get update 
    sudo apt-get install -y docker.io  docker-compose 
}


# ----------------------------------------------------
# (3) Function to perform required restarts
# ----------------------------------------------------

required_restarts() {
    echo "Starting docker......"
    sudo chown "$USER" /var/run/docker.sock

    sudo systemctl enable --now docker
}


# --------------------------------------------------
# (4) Function to deploy the Django app
# --------------------------------------------------

deploy() {
    echo "Building and deploying the Django app........"
    docker build -t notes-app . 
    docker-compose up -d 
}



# Main deployment script
echo " --------------------------------------- "
echo "          DEPLOYMENT STARTED             "
echo " --------------------------------------- "

# (1) Clone the code
if ! code_clone; then 
  echo "Error: Failed to clone the code....... "
fi

# (2) Install dependencies
if ! install_requirements; then
   echo "Error: Failed to install dependencies......"
   exit 1
fi

# (3) Perform required restarts
if ! required_restarts; then
   echo "Error: Docker service failed to start......"
   exit 1 
fi

# (4) Deploy the app
if ! deploy; then
    echo "Error: Deployment failed. Mailing the admin......"
    exit 1
fi

echo " ------------------------------------- "
echo "         DEPLOYMENT DONE               "
echo " ------------------------------------- "
