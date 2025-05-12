# setup-docker-nvidia-ol8.sh

This script installs and configures **Docker** and the **NVIDIA Container Toolkit** on an **Oracle Linux 8 (OL8)** system to enable GPU-accelerated containers.

## 🔧 What It Does

- Installs Docker and its dependencies using the official Docker repository
- Sets up the NVIDIA Container Toolkit for GPU support
- Configures the NVIDIA runtime for Docker
- Verifies the installation using `nvidia-smi` inside a container

> ⚠️ **This script assumes that the NVIDIA driver is already installed on the host system.**

## 🖥️ Tested On

- Oracle Linux 8 (OL8)
- Compatible NVIDIA GPUs
- Docker CE
- NVIDIA Container Toolkit (`nvidia-ctk`)

## 🚀 How to Use

Run the script as root:

```bash
sudo bash setup-docker-nvidia-ol8.sh
```
