#!/bin/bash

echo "Running dist upgrade"

echo "Updating package lists..."
sudo apt update

echo "Upgrading installed packages..."
sudo apt dist-upgrade -y

echo "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

echo "Update and upgrade complete!"
