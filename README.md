My Script is designed to automate the deployment of a Django app using Docker, while also handling errors.

Automating Django App Deployment with Docker Using a Bash Script
In this blog, I’ll walk you through automating the deployment of a Django application using a bash script. This script will manage cloning the code, installing dependencies, performing required system restarts, and deploying the app in Docker containers. The script also includes basic error handling to ensure a smooth deployment process. Let’s dive into each section!

1. Overview of the Script
Our bash script follows these steps:

Clone the Django app repository from GitHub.

Install necessary dependencies (Nginx and Docker).

Restart services, if needed.

Build and deploy the Django app using Docker.

The script is modular, breaking tasks into functions that handle specific steps of the deployment.

2. Cloning the Django App
The first task in our deployment process is to clone the app repository from GitHub. This is handled by the code_clone function.

code_clone() {

echo "Cloning the Django app.."

git clone https://github.com/huzefaweb/my-django-note-app.git

}

What it does: It clones a repository from GitHub into the local directory using the git clone command.

Error handling: If the directory already exists or cloning fails, the script can detect this, and you can include logic to handle it (like pulling the latest changes).

3. Installing Required Dependencies
Next, we need to install Nginx, Docker, and Docker Compose, which are essential for serving and running the app inside containers. The install_requirements function handles this.

install_requirements() {

echo "Installing dependencies..."

sudo apt install nginx -y

sudo apt install docker.io -y

sudo apt-get install docker-compose-plugin -y

}

Nginx: A web server that will handle the app’s web traffic.

Docker: Used to containerize the Django app and manage its environment.

Docker Compose: Simplifies the management of multi-container Docker applications.

The -y flag ensures that the system automatically confirms the installation of each package.

4. Restarting Services
Some system services need to be restarted or adjusted during deployment. The required_restarts function does this.

required_restarts() {

echo "Performing required restarts..."

sudo chown $USER /var/run/docker.sock

# Uncomment the following lines if needed:

# sudo systemctl enable docker

# sudo systemctl enable nginx

# sudo systemctl restart docker

}

Adjusting Docker permissions: The chown command gives the current user permissions to manage Docker.

Optional service restarts: The script contains commented-out lines for restarting Docker and enabling Nginx. These lines can be uncommented if the services need to be manually enabled or restarted.

5. Building and Deploying the Django App
With the environment set up, we build and run the Django app inside Docker containers using the deploy function.

deploy() {

echo "Building and deploying the Django app..."

docker build -t notes-app .

docker compose up -d

}

docker build: Builds a Docker image from the Dockerfile in the project directory, tagging it as notes-app.

docker compose up: Starts the containers defined in the docker-compose.yml file in detached mode (-d), so they run in the background.

This step isolates the Django app inside a container, ensuring it runs in a consistent environment across different systems.

6. Error Handling
The script contains error handling mechanisms at every step. Using the if condition with the ! (negation operator), it checks whether each step succeeds. If any step fails, the script stops and exits.

echo "********** DEPLOYMENT STARTED *********"

if ! code_clone; then

echo "Code Clone Already Exits"

cd my-django-note-app

fi

if ! install_requirements; then

exit 1

fi

if ! required_restarts; then

exit 1

fi

if ! deploy; then

echo "Deployment failed. Mailing the admin..."

exit 1

fi

echo "********** DEPLOYMENT DONE *********"

If a step fails: The script prints a message and exits with a non-zero status (exit 1), indicating that an error occurred.

Custom failure handling: You can add additional logic, like sending email alerts to the admin in case of deployment failure.

Conclusion
This bash script offers a simple yet effective way to automate the deployment of a Django app using Docker. By breaking down tasks into individual functions and adding error handling at each stage, the script ensures that any deployment issues are handled gracefully. Whether you're new to DevOps or looking to streamline your processes, this approach can save time and prevent errors during deployments.

If you'd like to use this script or make your own adjustments, simply copy it and modify it as needed for your projects. Let me know in the comments if you have any questions or need further customization!
