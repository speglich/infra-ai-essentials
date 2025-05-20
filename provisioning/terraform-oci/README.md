# LLM Deployment with Terraform on OCI

This project uses Terraform to provision infrastructure on Oracle Cloud Infrastructure (OCI) with:

* A public subnet with an accessible VM.A10.1 instance (via SSH)
* An Internet Gateway for public internet access
* Automated installation of Docker and NVIDIA Container Toolkit
* Deployment of the Meta Llama 3.1-8B-Instruct model using vLLM, exposed on port 8000 (accessible inside the VCN)

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

* An Oracle Cloud Infrastructure (OCI) account
* API keys with appropriate access to your tenancy
* Terraform ≥ 1.0 installed
* SSH public/private key pair (e.g., created with ssh-keygen)

## Variables

You must define the required variables in `terraform.tfvars`:

```hcl
region = "sa-saopaulo-1"
compartment_ocid = "ocid1.compartment.oc1..xxxxxxxx"
ssh_public_key = "ssh-rsa AAAA... your_user@host"
ssh_private_key_path = "/path/to/your/private_key.pem"
profile = "DEFAULT" # OCI CLI profile
hugging_face_token = "your_hugging_face_token"
```

## Usage

1. **Initialize Terraform:**
    ```sh
    terraform init
    ```

2. **Review the execution plan:**
    ```sh
    terraform plan
    ```

3. **Apply the infrastructure:**
    ```sh
    terraform apply
    ```

4. **SSH into the public instance:**
    ```sh
    ssh -i /path/to/private_key.pem opc@<public_ip_from_output>
    ```

## Modules

modules/network: Defines the VCN, subnets, routing tables, and gateways
modules/compute: Launches E5 instances in public and private subnets
modules/tools: Installs Docker, NVIDIA Container Toolkit, and vLLM on the public instance
