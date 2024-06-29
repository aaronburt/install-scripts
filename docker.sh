#!/bin/sh

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root to install Docker and manage user groups."
  exit 1
fi

# Function to compute SHA256 hash using available tools
compute_sha256() {
  if command -v shasum &> /dev/null; then 
    echo $(shasum -a 256 $1 | awk '{ print $1 }')
  elif command -v sha256sum &> /dev/null; then 
    echo $(sha256sum $1 | awk '{ print $1 }')
  else 
    read -p "'shasum' and 'sha256sum' are not installed. Do you want to install 'shasum'? (y/n): " install_response
    if [ "$install_response" = "y" ]; then 
      apt-get update && apt-get install -y perl-Digest-SHA 
      echo $(shasum -a 256 $1 | awk '{ print $1 }')
    else 
      echo "Cannot compute SHA256 hash without required tools. Exiting."
      exit 1
    fi
  fi
}

# Step 1: Download the Docker install script
echo "Downloading Docker installation script..."
curl -fsSL https://get.docker.com -o get-docker.sh

# Step 2: Compute the SHA256 hash of the downloaded script
HASH=$(compute_sha256 get-docker.sh)
echo "The SHA256 hash of the downloaded script is: $HASH"

# Step 3: Ask the user to confirm the hash is correct
read -p "Do you confirm that the hash is correct? (y/n): " response
if [ "$response" != "y" ]; then 
  echo "Hash not confirmed. User exit."
  exit 1
fi

echo "Hash confirmed. Proceeding to run the Docker installation script..."

# Step 4: Run the Docker installation script
sh get-docker.sh

# Delete the Docker downloaded file
rm get-docker.sh
echo "Docker installation script removed."

# Step 5: Identify non-root users
NON_ROOT_USERS=$(getent passwd {1000..60000} | awk -F: '{ print $1 }')

# Step 6: Check if there are any non-root users
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
    echo "docker:docker" | passwd docker --stdin > /dev/null 2>&1
    usermod -aG docker docker
    echo "User 'docker' has been created with the password 'docker' and added to the Docker group."
  else 
    echo "User 'docker' was not created."
  fi
  exit 0
fi

# Step 7: Display non-root users and prompt to add to the Docker group
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
