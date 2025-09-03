# Deploy Rocky Linux 9 in a GPU in OCI

lsmod | grep nouveau

cat <<EOF | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

sudo reboot
lsmod | grep nouveau

# This script installs the NVIDIA driver on Rocky Linux 9.

sudo dnf groupinstall "Development Tools" -y
sudo dnf install wget -y
sudo dnf distro-sync
sudo reboot
sudo dnf install kernel-devel-$(uname -r) kernel-headers-$(uname -r)

wget https://developer.download.nvidia.com/compute/cuda/12.9.0/local_installers/cuda_12.9.0_575.51.03_linux.run
sudo sh cuda_12.9.0_575.51.03_linux.run