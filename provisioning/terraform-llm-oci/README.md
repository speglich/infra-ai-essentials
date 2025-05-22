# LLM Deployment with Terraform on OCI

This project provisions infrastructure on **Oracle Cloud Infrastructure (OCI)** to deploy an **LLM inference server** using Terraform.

## Features

- Public subnet with a GPU-enabled `VM.GPU.A10.1` instance
- Internet Gateway for public access
- Automatic setup of:
  - Docker
  - NVIDIA Container Toolkit
  - vLLM with Meta Llama 3.1-8B-Instruct model
- Exposes vLLM on port `8000`

## Project Structure

```plaintext
.
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
└── modules
    ├── network
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── provider.tf
    ├── compute
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── provider.tf
    └── tools
        ├── main.tf
        ├── variables.tf
        └── provider.tf
```

## Prerequisites

- OCI account and credentials with necessary permissions
- OCI CLI configured with appropriate `profile`
- Terraform ≥ 1.0 installed
- SSH key pair (e.g., `ssh-keygen`)
- Hugging Face token

## Required Variables

Define the following in `terraform.tfvars`:

```hcl
region                = "sa-saopaulo-1"
compartment_ocid      = "ocid1.compartment.oc1..xxxxxxxx"
ssh_public_key        = "ssh-rsa AAAA... your_user@host"
ssh_private_key_path  = "/path/to/your/private_key.pem"
profile               = "DEFAULT"
hugging_face_token    = "your_hugging_face_token"
```

## Default Configuration

Additional configurable variables and defaults:

```hcl
shape                     = "VM.GPU.A10.1"
image_id                 = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa6whle33ey34txn6lx63jnaywjcstpwdlvapjqtnr4c4fxu7xmloa"
boot_volume_size_in_gbs = 100
ssh_user                 = "opc"
exposed_ports            = [22, 8000]
setup_docker             = true
setup_nvidia_container_toolkit = true
setup_vllm               = true
vllm_model               = "meta-llama/Llama-3.1-8B-Instruct"
vllm_parameters          = "--max_model_len 2000"
```

## Usage

1. **Initialize Terraform**:
    ```bash
    terraform init
    ```

2. **Review the plan**:
    ```bash
    terraform plan
    ```

3. **Apply the configuration**:
    ```bash
    terraform apply
    ```

4. **Access the instance**:
    ```bash
    ssh -i /path/to/private_key.pem opc@<public_ip_from_output>
    ```

## Modules Overview

- **network**: Creates VCN, subnets, route tables, internet gateway
- **compute**: Provisions GPU instance in public subnet
- **tools**: Automates setup of Docker, NVIDIA toolkit, and vLLM

---

Terraform simplifies deploying LLMs in OCI with secure, repeatable infrastructure-as-code.