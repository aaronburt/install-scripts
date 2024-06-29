#!/bin/sh
curl https://get.docker.com | sh

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root to install Docker and manage user groups."
    exit 1
fi

NON_ROOT_USERS=$(getent passwd {1000..60000} | awk -F: '{ print $1 }')

if [ -z "$NON_ROOT_USERS" ]; then 
  echo "Warning: Only root user detected. Running Docker as root can be dangerous."
  echo "It is recommended to add non-root users to the Docker group."

  # Step 6.5: Offer to create a non-root user called 'docker'
  read -p "Do you want to create a non-root user called 'docker'? (y/n): " create_docker_user
  if [ "$create_docker_user" = "y" ]; then 
    if getent group docker > /dev/null 2>&1; then 
      useradd -m -g docker docker
    else 
      groupadd docker
      useradd -m -g docker docker
    fi
    echo "Setting password for 'docker' user..."
    echo "docker:docker" | passwd --stdin docker > /dev/null 2>&1
    usermod -aG docker docker
    echo "User 'docker' has been created with the password 'docker' and added to the Docker group."
  else 
    echo "User 'docker' was not created."
  fi
  exit 0
fi

echo "Non-root users on the system:"
echo "$NON_ROOT_USERS"
for USER in $NON_ROOT_USERS; do 
  while true; do 
    read -p "Do you want to add user '$USER' to the Docker group? (y/n): " response
    case $response in 
      [Yy]* ) 
        usermod -aG docker $USER; 
        echo "User '$USER' has been added to the Docker group."; 
        break;;
      [Nn]* ) 
        echo "User '$USER' was not added to the Docker group."; 
        break;;
      * ) 
        echo "Please answer yes or no.";;
    esac
  done
done

echo "Complete."
