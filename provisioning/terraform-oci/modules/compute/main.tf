# This module creates a public compute instance in OCI with the specified shape and configuration.
# It uses a dynamic block to configure the shape and memory for flex shapes.
# The instance is created in the specified compartment and availability domain.
# The instance is assigned a public IP address and uses the provided SSH public key for access.

locals {
  flex_shapes = [
    "VM.Standard.E5.Flex",
    "VM.Standard.E4.Flex",
  ]

  is_flex = contains(local.flex_shapes, var.shape)
}

resource "oci_core_instance" "public" {
  compartment_id = var.compartment_ocid
  availability_domain = var.availability_domain
  shape = var.shape
  display_name = "${var.instance_name}-public"

  # Use flex shapes for OCPUs and memory
  dynamic "shape_config" {
    for_each = local.is_flex ? [1] : []
    content {
      ocpus         = var.ocpus
      memory_in_gbs = var.memory_in_gbs
    }
  }

  source_details {
    source_type = "image"
    source_id = var.image_id
  }

  create_vnic_details {
    subnet_id        = var.public_subnet_id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}