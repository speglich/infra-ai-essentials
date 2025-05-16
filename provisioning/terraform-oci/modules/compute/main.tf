data "oci_core_images" "ubuntu_latest" {
  compartment_id = var.compartment_ocid
  operating_system = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape = "VM.Standard.E5.Flex"
  sort_by = "TIMECREATED"
  sort_order = "DESC"
}

resource "oci_core_instance" "public" {
  compartment_id = var.compartment_ocid
  availability_domain = var.availability_domain
  shape = "VM.Standard.E5.Flex"

  shape_config {
    ocpus = 1
    memory_in_gbs = 8
  }

  source_details {
    source_type = "image"
    source_id = data.oci_core_images.ubuntu_latest.images[0].id
  }

  create_vnic_details {
    subnet_id        = var.public_subnet_id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  display_name = "e5-public"
}

resource "oci_core_instance" "private" {
  compartment_id = var.compartment_ocid
  availability_domain = var.availability_domain
  shape = "VM.Standard.E5.Flex"

  shape_config {
    ocpus = 1
    memory_in_gbs = 8
  }

  source_details {
    source_type = "image"
    source_id = data.oci_core_images.ubuntu_latest.images[0].id
  }

  create_vnic_details {
    subnet_id        = var.private_subnet_id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  display_name = "e5-private"
}