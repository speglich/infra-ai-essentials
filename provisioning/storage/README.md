# OCI NVMe RAID 0 Setup Script

This script automates the creation of a RAID 0 volume using all available NVMe disks on a bare metal Oracle Cloud Infrastructure (OCI) instance.

## Purpose

Automatically configure a RAID 0 array to increase I/O performance by aggregating the instance's local NVMe disks. The default filesystem is `ext4`, and the volume is mounted at `/mnt/scratch`.

**Warning**: RAID 0 provides no redundancy. If any disk fails, all data is lost. Use only for temporary or intermediate data storage.

## Features

- Automatically detects all available NVMe devices
- Creates a RAID 0 array using `mdadm`
- Formats the array with `ext4`
- Mounts the volume at `/mnt/scratch`
- Configures automatic mounting via `/etc/fstab`
- Saves the RAID configuration in `/etc/mdadm.conf` (or equivalent)

## Requirements

- OCI bare metal instance with two or more NVMe disks
- Linux distribution with `mdadm` support (e.g., Oracle Linux, Ubuntu)
- Superuser privileges (sudo)

## Usage

1. Download or copy the `oci_nvme_raid0_setup.sh` script.
2. Make the script executable:

```bash
chmod +x oci_nvme_raid0_setup.sh
```

3. Run it with administrative privileges:

```bash
sudo ./oci_nvme_raid0_setup.sh
```

## Customization

You can change the filesystem by modifying the `FILESYSTEM` variable at the top of the script:

```bash
FILESYSTEM="xfs"
```

The default mount point is `/mnt/scratch`, which can be changed by editing the `MOUNT_POINT` variable.

## Removal

To unmount and delete the created RAID 0 configuration:

```bash
sudo umount /mnt/scratch
sudo mdadm --stop /dev/md0
for disk in /dev/nvme*n1; do
  sudo mdadm --zero-superblock $disk
done
sudo rm -rf /mnt/scratch
```

## Disclaimer

This script will overwrite available NVMe disks. Carefully verify which devices are detected before running it on systems with important data.
