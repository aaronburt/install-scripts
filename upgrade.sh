#!/bin/bash

echo "Running upgrade"

echo "Updating the package list"
sudo apt update

echo "Upgrading installed packages..."
sudo apt upgrade -y

echo "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

echo "Update complete" 