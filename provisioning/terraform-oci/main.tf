module "network" {
  source            = "./modules/network"
  compartment_ocid  = var.compartment_ocid
  vcn_cidr          = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  network_name      = local.environment_name
}

module "compute" {
  source              = "./modules/compute"
  compartment_ocid    = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  public_subnet_id    = module.network.public_subnet_id
  private_subnet_id   = module.network.private_subnet_id
  ssh_public_key      = var.ssh_public_key
  shape               = var.shape
  image_id            = var.image_id
  instance_name       = local.environment_name
}

module "tools" {
  source              = "./modules/tools"
  instance_public_ip  = module.compute.public_instance_ip
  ssh_user            = var.ssh_user
  ssh_private_key     = var.ssh_private_key
  setup_docker        = var.setup_docker
  setup_nvidia_container_toolkit = var.setup_nvidia_container_toolkit
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}