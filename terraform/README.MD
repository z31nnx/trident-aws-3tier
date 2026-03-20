# Trident 3-Tier Terraform Architecture

This directory contains the Terraform configuration for **Trident**, a refactored **3-tier AWS architecture** built with reusable modules and organized into separate infrastructure stacks.

This Terraform build was modernized from an earlier 2025 version to better reflect cleaner infrastructure design, separation of concerns, and stack-based deployment. It may differ from the [manual build](/manual_build/README.MD).

## Overview

Trident is a **modular 3-tier AWS environment** deployed with Terraform.  
It is structured into separate stacks for clearer ownership, simpler data flow, and easier maintenance.

The current Terraform design emphasizes:

- **Separation of Concerns**: Infrastructure is split into dedicated stacks for networking, security, compute, and database
- **Reusable Modules**: Shared building blocks are used instead of tightly coupled legacy code
- **Local Stack Data Flow**: Stacks exchange values through local Terraform state outputs
- **Production-Inspired Design**: Multi-AZ networking, layered security boundaries, load balancing, private database placement, and Amazon Linux 2023-based compute instances
- **Sandbox-Friendly Deployment**: Local state is used intentionally for demonstration in temporary lab environments

## Architecture Diagram

![Trident-3-Tier-Architecture-Diagram](/diagram/trident-3-Tier-Diagram.png)

## Stack Layout

The Terraform build is organized into four primary stacks:

| Stack | Purpose |
|-------|---------|
| **networking** | Provisions core network infrastructure such as the VPC, subnets, route tables, internet gateway, and NAT gateways |
| **security** | Defines security groups, IAM roles, instance profiles, and supporting access controls |
| **compute** | Deploys application compute resources such as launch templates, load balancers, and Auto Scaling Groups |
| **database** | Provisions the database tier, including DB subnet groups and the RDS instance |

This structure makes the project easier to understand, test, and extend compared to the earlier legacy layout.

## Module Design

Trident uses reusable Terraform modules to keep the infrastructure consistent and easier to maintain.

Examples of infrastructure handled through modules include:

- **VPC and subnet provisioning**
- **Security group definitions**
- **IAM roles and instance profiles**
- **Launch templates**
- **Application and internal load balancers**
- **Auto Scaling Groups**
- **RDS database resources**

The refactor replaced older modules with newer module patterns that better match the current project structure and Terraform skill level.

## Requirements

- **Terraform**: [Install Guide](https://developer.hashicorp.com/terraform/install)
- **AWS CLI v2**: [Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- **AWS credentials configured locally** using `aws configure`
- Each stack requires a manually created `terraform.tfvars` file
- Each stack includes a `terraform.tfvars.example` file to use as a reference when creating your own inputs

## State Management

This project uses **local Terraform state intentionally**.

Because Trident is designed and tested in temporary sandbox AWS environments, local state keeps the demonstration simple and avoids unnecessary backend complexity for short-lived lab usage.

In a real shared or persistent environment, a remote backend such as **S3** would be recommended for durability, collaboration, and safer team workflows.

## Amazon Linux 2023 Note

The compute layer in this project uses **Amazon Linux 2023 (AL2023)**.

This matters because package installation differs from older Amazon Linux 2 workflows. In particular, AL2023 uses **DNF** as its package manager, and the MySQL-compatible client is installed with:

```bash
sudo dnf install mariadb105
```
## Notes

- ⚠️ **Never commit `terraform.tfvars` files to version control**
- ⚠️ **Never commit Terraform state files if they contain sensitive values**
- ⚠️ **RDS destroy note:** `skip_final_snapshot = true` is acceptable for sandbox use, but is **not recommended for production**
- This Terraform implementation may differ from the manual build documentation because the Terraform version has been refactored and improved over time

## Deployment Order

Because the project is split into stacks, deploy them in dependency order:

1. **networking**
2. **security**
3. **compute**
4. **database**

This allows later stacks to consume outputs from earlier stacks using local state references.

Before deploying a stack, create a `terraform.tfvars` file in that stack's directory by referring to the included `terraform.tfvars.example` file and supplying your own inputs.

## How to Deploy

Repeat the following process for each stack in the correct deployment order.

```bash
# Example: navigate to a stack environment
cd ./trident-aws-3tier/terraform/envs/dev/<stack-name>

# Initialize Terraform
terraform init

# Apply infrastructure
terraform apply
``` 

## How to destroy 

Destroy the stacks in reverse order to avoid dependency issues: 
1. **database**
2. **compute**
3. **security**
4. **networking**

Repeat the following process for each stack in the correct destruction order.

```bash
# Example: navigate to a stack environment
cd ./trident-aws-3tier/terraform/envs/dev/<stack-name>

terraform destroy
```

## Manual documentation
For service-to-service implementation details, see the manual build documentation: [manual build](/manual_build/README.MD).

