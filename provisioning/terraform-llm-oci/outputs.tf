output "public_instance_ip" {
  value = module.compute.public_instance_ip
}

output "vllm_endpoint" {
  value = "Seu endpoint VLLM está pronto! Acesse: http://${module.compute.public_instance_ip}:8000"
  description = "URL amigável para acessar o endpoint VLLM"
}