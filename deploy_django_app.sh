#!/bin/bash

# Deploy a Django app and handle errors

# Function to clone the Django app code
code_clone() {
    echo "Cloning the Django app.."
        git clone https://github.com/huzefaweb/my-django-note-app.git
}

# Function to install required dependencies
install_requirements() {
    echo "Installing dependencies..."
    sudo apt install nginx -y
    sudo apt install docker.io -y 
    sudo apt-get install docker-compose-plugin -y    
}

# Function to perform required restarts
required_restarts() {
    echo "Performing required restarts..."
    sudo chown $USER /var/run/docker.sock

    # Uncomment the following lines if needed:
    # sudo systemctl enable docker
    #  sudo systemctl enable nginx
    # sudo systemctl restart docker
}

# Function to deploy the Django app
deploy() {
    echo "Building and deploying the Django app..."
    docker build -t notes-app .
    # docker run -d -p 8000:8000 notes-app:latest
    docker compose up -d
}

# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

# Clone the code
if ! code_clone; then
	echo "Code Clone Already Exits"
	cd my-django-note-app
fi

# Install dependencies
if ! install_requirements; then
	exit 1
fi

# Perform required restarts
if ! required_restarts; then
	exit 1
fi

# Deploy the app
if ! deploy; then
	echo "Deployment failed. Mailing the admin..."
	# Add your sendmail or notification logic here 
	exit 1
fi

echo "********** DEPLOYMENT DONE *********"
