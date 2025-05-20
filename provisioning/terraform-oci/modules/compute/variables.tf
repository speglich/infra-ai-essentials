variable "compartment_ocid" {
    description = "OCID of the compartment where resources will be created"
    type        = string
}
variable "availability_domain" {
    description = "Availability domain where resources will be created"
    type        = string
}
variable "ssh_public_key" {
    description = "SSH public key for accessing the instance"
    type        = string
}
variable "ssh_private_key" {
    description = "SSH private key for accessing the instance"
    type        = string
}
variable "ssh_user" {
    description = "Default SSH user for accessing the instance"
    default     = "ubuntu"
    type        = string
}
variable "public_subnet_id" {
    description = "OCID of the public subnet"
    type        = string
}
variable "private_subnet_id" {
    description = "OCID of the private subnet"
    type        = string
}
variable "shape" {
    description = "Shape of the instance (e.g., 'VM.Standard2.1', 'VM.GPU.A10.1')"
    default = "VM.Standard.E5.Flex"
    type   = string
}

variable "ocpus" {
  description = "Number of OCPUs to allocate for the instance (Only for VM shapes)"
  type        = number
  default     = 1
}

variable "memory_in_gbs" {
  description = "Amount of memory in GBs to allocate for the instance (Only for VM shapes)"
  type        = number
  default     = 8
}

variable "image_id" {
    description = "OCID of the image to use for the instance"
    # This is the default image for Ubuntu 22.04 in the São Paulo region
    # You can find the latest image OCID in the OCI console or use the CLI to list images
    default = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa7z4j4tf57j54mfx3g32xdk2v2ayhtp5xp3js7s6nx6kagxdkka7a"
    type        = string
}

variable "boot_volume_size_in_gbs" {
    description = "Size of the boot volume in GBs"
    default     = 50
    type        = number
}

variable "instance_name" {
    description = "Name of the instance"
    default     = "e5-instance"
    type        = string
}