#!/bin/bash

# This script sets up Docker and NVIDIA drivers for GPU support on a OL8 system.
# It installs the necessary packages, configures the system, and verifies the installation.

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Install required packages
echo "setup repositories..."
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager -y --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install Docker
echo "Installing Docker..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if [ $? -ne 0 ]; then
    echo "Failed to install Docker. Exiting."
    exit 1
fi

# Start and enable Docker service
echo "Starting Docker service..."
sudo systemctl enable --now docker

if [ $? -ne 0 ]; then
    echo "Failed to start Docker service. Exiting."
    exit 1
fi

# This script assumes that the NVIDIA driver is already installed.
# If not, please install the NVIDIA driver before proceeding.

# Install NVIDIA Container Toolkit
echo "Setting up NVIDIA Container Toolkit..."
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

# Install NVIDIA Container Toolkit
sudo dnf install -y nvidia-container-toolkit

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
sudo usermod -aG docker opc
if [ $? -ne 0 ]; then
    echo "Failed to add user to docker group. Exiting."
    exit 1
fi

echo "Please log out and log back in to apply group changes."