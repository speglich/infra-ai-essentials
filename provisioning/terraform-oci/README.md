# Example of Terraform in OCI

This project uses Terraform to provision a Virtual Cloud Network (VCN) on Oracle Cloud Infrastructure (OCI), including:

* A public subnet with an accessible E5 instance (via SSH)
* A private subnet with an E5 instance (no public IP)
* An Internet Gateway for public internet access
* A NAT Gateway to allow the private subnet to access the internet
* A modular architecture using separate network and compute modules

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
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
| └── provider.tf
└── compute
├── main.tf
├── variables.tf
└── outputs.tf
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
profile = "DEFAULT" # OCI CLI profile
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

## Notes

The private instance has no public IP; access must be made via a jump host (the public instance)
Be sure to use secure key management and follow OCI IAM best practices
Confirm the compartment_id and region match your tenancy configuration