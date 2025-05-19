variable "compartment_ocid" {}
variable "vcn_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "network_name" {
  description = "Name of the network"
  type        = string
}