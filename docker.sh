#!/bin/bash



USERID="$(id -u)"

if [ "$USERID" -ne 0 ]; then
    echo "You need to run this as root"
    exit 1
fi

read -p "Do you want to update the system and install docker?: " install_docker_choice
if [ "$install_docker_choice" = "y" ]; then

    echo "Updating the system"
    apt-get update && apt-get upgrade -y

    echo "Installing docker from https://get.docker.com"
    curl https://get.docker.com | sh

    read -p "Do you want to create a non-root user called 'docker'? (y/n): " create_docker_user
    if [ "$create_docker_user" = "y" ]; then

        if getent group docker > /dev/null 2>&1; then 
            echo "Adding user 'docker' to docker group"
            useradd -m -g docker docker
        else 
            echo "Creating docker group and adding user 'docker' to it"
            groupadd docker
            useradd -m -g docker docker
        fi

        echo "docker:docker" | passwd --stdin docker > /dev/null 2>&1
        usermod -aG docker docker
        echo "User 'docker' has been created with the password 'docker' and added to the Docker group."
    fi 
fi

