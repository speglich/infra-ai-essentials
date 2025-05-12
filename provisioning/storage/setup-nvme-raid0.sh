#!/bin/bash
set -e

RAID_DEVICE="/dev/md0"
MOUNT_POINT="/mnt/scratch"
FILESYSTEM="ext4"

echo "Identificando discos NVMe disponíveis..."
DISKS=($(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print "/dev/"$1}' | grep nvme | sort))

NUM_DISKS=${#DISKS[@]}
if [ "$NUM_DISKS" -lt 2 ]; then
  echo "É necessário pelo menos dois discos NVMe para configurar RAID 0. Encontrado: $NUM_DISKS"
  exit 1
fi

echo "Dispositivos NVMe detectados: ${DISKS[@]}"

echo "Instalando mdadm..."
if command -v yum &>/dev/null; then
  sudo yum install -y mdadm
elif command -v apt &>/dev/null; then
  sudo apt update && sudo apt install -y mdadm
else
  echo "Gerenciador de pacotes não suportado."
  exit 1
fi

echo "Criando RAID 0 com ${NUM_DISKS} discos..."
sudo mdadm --create --verbose $RAID_DEVICE --level=0 --raid-devices=$NUM_DISKS "${DISKS[@]}"

sleep 5

echo "Criando sistema de arquivos $FILESYSTEM..."
sudo mkfs.$FILESYSTEM -F $RAID_DEVICE

echo "Criando ponto de montagem e montando RAID em $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT
sudo mount $RAID_DEVICE $MOUNT_POINT

echo "Adicionando entrada no /etc/fstab para montagem automática..."
UUID=$(sudo blkid -s UUID -o value $RAID_DEVICE)
echo "UUID=$UUID $MOUNT_POINT $FILESYSTEM defaults,nofail,discard 0 0" | sudo tee -a /etc/fstab

echo "Salvando configuração do mdadm..."
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf >/dev/null 2>&1 || \
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm.conf >/dev/null

echo "RAID 0 configurado com sucesso em $RAID_DEVICE e montado em $MOUNT_POINT"
