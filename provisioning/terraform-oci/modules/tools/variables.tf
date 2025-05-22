variable "setup_docker" {
    description = "Whether to set up Docker on the instance"
    default     = true
    type        = bool
}
variable "setup_nvidia_container_toolkit" {
    description = "Whether to set up NVIDIA container toolkit on the instance"
    default     = true
    type        = bool
}
variable instance_public_ip {
    description = "Public IP address of the instance"
    type        = string
}
variable "ssh_user" {
    description = "SSH user for accessing the instance"
    default     = "opc"
    type        = string
}
variable "ssh_private_key" {
    description = "SSH private key for accessing the instance"
    type        = string
}
variable "hugging_face_token" {
    description = "Hugging Face token for accessing models"
    type        = string
}
variable "setup_vllm" {
    description = "Whether to set up VLLM on the instance"
    default     = true
    type        = bool
}
variable "vllm_model" {
  description = "Model to be used with vLLM"
  default     = "meta-llama/Llama-3.1-8B-Instruct"
  type        = string
}

variable "vllm_parameters" {
  description = "Additional parameters for vLLM"
  type        = string
  default     = "--max_model_len 2000"
}
