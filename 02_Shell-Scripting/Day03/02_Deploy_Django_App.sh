#!/bin/bash

<< task 
Deploy a Django App and handle the code for errors
task

code_clone() {
	echo "Cloning the Django app......."
	git clone https://github.com/LondheShubham153/django-notes-app.git
}

install_requirements() {
	echo "Installing Dependencies......"
	sudo apt-get update
	sudo apt-get install docker.io nginx -y
}

required_restarts() {
	sudo chown $USER /var/run/docker.sock
	sudo systemctl enable docker
	sudo systemctl enable nginx
	sudo systemctl restart docker
}

deploy() {
	# Build Images
	docker build -t notes-app .

	# Run Container
	docker run -d --name myNotes-app -p 8000:8000 notes-app:latest
}

echo "********* DEPLOYEMNT START **********"

# Code clone
if ! code_clone; then
	echo "the code directory already exists......."
	cd django-notes-app
fi

# Install Requirement
if ! install_requirements; then 
	echo "Installation failed......"
	exit 1
fi


# Reuired Restarts
if ! required_restarts; then 
	echo "System fault identified......"
	exit 1
fi


# Deploy
deploy

echo "********** DEPLOYMENT DONE **********"
