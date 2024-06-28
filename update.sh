#!/bin/bash

# Function to ask user for dist-upgrade with timeout
ask_dist_upgrade() {
    local answer
    echo "Do you want to run dist-upgrade? (y/n)"
    echo "Press ENTER to skip (timeout in 10 seconds)"
    read -t 10 -r answer    # Read input with a timeout of 10 seconds

    if [[ -n $answer ]]; then   # If user entered something
        case $answer in
            y|Y)
                echo "Running dist-upgrade..."
                sudo apt dist-upgrade -y
                ;;
            *)
                echo "Skipping dist-upgrade."
                ;;
        esac
    else
        echo "Timeout reached. Skipping dist-upgrade."
    fi
}

echo "Updating package lists..."
sudo apt update

echo "Upgrading installed packages..."
sudo apt upgrade -y

ask_dist_upgrade

echo "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

echo "Update and upgrade complete!"
