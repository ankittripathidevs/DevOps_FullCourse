#!/bin/bash

# Exit immediately if any command fails
set -e

<< task
Deploy Django + MySQL using Docker
Handle repeated deployments safely
task


# --------------------------------------------------
# Clone the Django application
# --------------------------------------------------

code_clone() {
    echo "Cloning the Django app......."
    git clone https://github.com/ankittripathidevs/Django-Notes-App.git
}


# --------------------------------------------------
# Install Docker
# --------------------------------------------------

install_requirements() {
    echo "Installing Docker......"
    sudo apt-get update
    sudo apt-get install -y docker.io
}


# --------------------------------------------------
# Start Docker service
# --------------------------------------------------

required_restarts() {
    echo "Starting Docker service......"
    sudo systemctl enable docker
    sudo systemctl restart docker
}


# --------------------------------------------------
# Create Docker network if it doesn't exist
# --------------------------------------------------

create_network() {
    echo "Checking Docker network......"

    if ! docker network ls --format '{{.Name}}' | grep -q "^notes-app-nw$"; then
        echo "Creating Docker network......"
        docker network create notes-app-nw
    else
        echo "Docker network already exists."
    fi
}


# --------------------------------------------------
# Deploy Django + MySQL
# --------------------------------------------------

deploy() {
    # Build Django Docker image
    echo "Building Django Docker image......"
    docker build -t notes-app .

    # Start MySQL container
    echo "Checking MySQL container......"

    if docker ps -a --format '{{.Names}}' | grep -q "^db_cont$"; then
        echo "MySQL container already exists."

        # Start MySQL if it exists but is stopped
        if ! docker ps --format '{{.Names}}' | grep -q "^db_cont$"; then
            echo "Starting existing MySQL container......"
            docker start db_cont
        fi
    else
        echo "Starting MySQL container......"
        docker run -d \
            --name db_cont \
            --network notes-app-nw \
            -e MYSQL_ROOT_PASSWORD=root \
            -e MYSQL_DATABASE=test_db \
            -v notes_mysql_data:/var/lib/mysql \
            mysql:8.0
    fi


    # Wait for MySQL
    echo "Waiting for MySQL to become ready......"

    until docker exec db_cont mysqladmin \
        ping \
        -h 127.0.0.1 \
        -uroot \
        -proot \
        --silent; do

        # Check whether MySQL container crashed
        if ! docker ps --format '{{.Names}}' | grep -q "^db_cont$"; then
            echo "ERROR: MySQL container stopped unexpectedly."
            echo
            echo "MySQL logs:"
            docker logs db_cont
            exit 1
        fi
         echo "MySQL is not ready yet..."
        sleep 5
    done

    echo "MySQL server is ready."


    # Test Django image -> MySQL connection
    echo "Testing Django to MySQL connection......"

    until docker run --rm \
        --network notes-app-nw \
        notes-app:latest \
	python3 -c "

    import MySQLdb
    MySQLdb.connect(
    host='db_cont',
    user='root',
    password='root',
    database='test_db',
    port=3306
    )
    print('Database connection successful.')";
    
     do
        # Check whether MySQL container is still running
        if ! docker ps --format '{{.Names}}' | grep -q "^db_cont$"; then
            echo "ERROR: MySQL container stopped unexpectedly."
            echo
            echo "MySQL logs:"
            docker logs db_cont
            exit 1
        fi

        echo "Django cannot connect to MySQL yet..."
        sleep 3
    done

    echo "Django can connect to MySQL."


    # ----------------------------------------------
    # Remove old Django container
    # ----------------------------------------------

    echo "Checking Django container......"

    if docker ps -a --format '{{.Names}}' | grep -q "^myCustomName$"; then
        echo "Removing old Django container......"
        docker rm -f myCustomName
    fi


    # ----------------------------------------------
    # Start Django container
    # ----------------------------------------------

    echo "Starting Django container......"

    docker run -d \
        --name myCustomName \
        --network notes-app-nw \
        -p 8000:8000 \
        -e DB_NAME=test_db \
        -e DB_USER=root \
        -e DB_PASSWORD=root \
        -e DB_HOST=db_cont \
        -e DB_PORT=3306 \
        notes-app:latest


    # ----------------------------------------------
    # Check Django container
    # ----------------------------------------------

    echo "Checking Django container status......"

    sleep 3

    if ! docker ps --format '{{.Names}}' | grep -q "^myCustomName$"; then
        echo "ERROR: Django container failed to start."
        echo
        echo "Django logs:"
        docker logs myCustomName
        exit 1
    fi

    echo "Django container is running."
}


# ==================================================
# DEPLOYMENT START
# ==================================================

echo "****************************************************"
echo "              DEPLOYMENT START"
echo "****************************************************"


# --------------------------------------------------
# Clone repository or update existing repository
# --------------------------------------------------

if [ -d "Django-Notes-App" ]; then
    echo "The code directory already exists......."
    cd Django-Notes-App
    echo "Updating code from GitHub......"
    git pull
else
    code_clone
    cd Django-Notes-App
fi


# --------------------------------------------------
# Install Docker
# --------------------------------------------------

if ! install_requirements; then
    echo "Docker installation failed......"
    exit 1
fi


# --------------------------------------------------
# Start Docker service
# --------------------------------------------------

if ! required_restarts; then
    echo "Docker service failed to start......"
    exit 1
fi


# -------------------------------------------------
# create Docker network
# -------------------------------------------------

create_network

# --------------------------------------------------
# Deploy Django + MySQL
# --------------------------------------------------

deploy

# ==================================================
# DEPLOYMENT DONE
# ==================================================


echo "****************************************************"
echo "              DEPLOYMENT DONE"
echo "****************************************************"
ubuntu@ip-172-31-34-84:~/DevOps_FullCourse/02_Shell-Scripting/Day03$ 
