#!/bin/bash

# This script sets up Docker and NVIDIA drivers for GPU support on a Ubuntu system.
# It installs the necessary packages, configures the system, and verifies the installation.

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "setup repositories..."

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Install Docker
echo "Installing Docker..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if [ $? -ne 0 ]; then
    echo "Failed to install Docker. Exiting."
    exit 1
fi

# This script assumes that the NVIDIA driver is already installed.
# If not, please install the NVIDIA driver before proceeding.

# Install NVIDIA Container Toolkit
echo "Setting up NVIDIA Container Toolkit..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update

# Install NVIDIA Container Toolkit
sudo apt-get install -y nvidia-container-toolkit

if [ $? -ne 0 ]; then
    echo "Failed to install NVIDIA Container Toolkit. Exiting."
    exit 1
fi


if [ $? -ne 0 ]; then
    echo "Failed to install NVIDIA Container Toolkit. Exiting."
    exit 1
fi

# Enable the NVIDIA Container Toolkit
sudo nvidia-ctk runtime configure --runtime=docker

if [ $? -ne 0 ]; then
    echo "Failed to configure NVIDIA Container Toolkit. Exiting."
    exit 1
fi

# Restart Docker to apply changes
echo "Restarting Docker service..."
sudo systemctl restart docker

if [ $? -ne 0 ]; then
    echo "Failed to restart Docker service. Exiting."
    exit 1
fi

# Verify NVIDIA driver installation
echo "Verifying NVIDIA installation..."

sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

# Add docker group to the current user
echo "Adding current user to docker group..."
sudo usermod -aG docker $USER
if [ $? -ne 0 ]; then
    echo "Failed to add user to docker group. Exiting."
    exit 1
fi

echo "Please log out and log back in to apply group changes."