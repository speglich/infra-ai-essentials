variable "region" {
  description = "OCI region where resources will be created"
  default     = "sa-saopaulo-1"
  type        = string
}
variable "compartment_ocid" {
  description = "OCID of the compartment where resources will be created"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the instance"
  type = string
}

variable "ssh_private_key" {
  description = "SSH private key for accessing the instance"
  type        = string
}

variable "profile" {
  description = "Profile from OCI CLI config file"
  default     = "DEFAULT"
  type        = string
}

variable "shape" {
  description = "Shape of the instance (e.g., 'VM.Standard2.1', 'VM.GPU.A10.1')"
  default     = "VM.GPU.A10.1"
  type        = string
}

# This is a sample image ID for Oracle Linux 8 with NVIDIA GPU support
variable "image_id" {
  description = "OCID of the image to use for the instance"
  default     = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa6whle33ey34txn6lx63jnaywjcstpwdlvapjqtnr4c4fxu7xmloa"
  type        = string
}

variable "ssh_user" {
  description = "Default SSH user for accessing the instance"
  default     = "opc"
  type        = string
}

variable "setup_docker" {
  description = "Whether to set up Docker on the instance"
  default     = true
  type        = bool
}

variable "setup_nvidia_container_toolkit" {
  description = "Whether to set up NVIDIA toolkit on the instance"
  default     = true
  type        = bool
}