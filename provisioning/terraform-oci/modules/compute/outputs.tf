output "public_instance_ip" {
  value = oci_core_instance.public.public_ip
}

output "private_instance_ip" {
  value = oci_core_instance.private.private_ip
}