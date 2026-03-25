# Trident AWS 3-Tier Infra
[![Terraform CI](https://github.com/z31nnx/trident-aws-3tier/actions/workflows/terraform.yml/badge.svg)](https://github.com/z31nnx/trident-aws-3tier/actions/workflows/terraform.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Cloud: AWS](https://img.shields.io/badge/Cloud-AWS-orange.svg)](#)
[![IaC: Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC.svg)](#)
[![Architecture: 3-Tier](https://img.shields.io/badge/Architecture-3--Tier-blue.svg)](#)
[![Status: Maintained](https://img.shields.io/badge/Status-Maintained-blue.svg)](#)

Trident is a resilient, highly available, and secure AWS 3-tier architecture implemented both manually and with **Terraform** as Infrastructure as Code (IaC).

> **Renaming Notice — Sep 2025**
>
> This project was previously named **Athena**. It was renamed to **Trident** to avoid service and resource naming collisions with AWS-related identifiers.
> Any screenshots, tags, or legacy references that still show `athena-*` refer to the same project prior to the rename.

## Overview

This project demonstrates the deployment of a modern AWS 3-tier architecture using both manual implementation and Infrastructure as Code.

It is designed to showcase core cloud engineering concepts including scalability, availability, layered networking, secure access patterns, and modular infrastructure design.

The repository contains:

- a **manual build** documenting the service-by-service setup
- a **Terraform build** that refactors the architecture into reusable modules and stack-based deployment

![Trident-3-Tier-Architecture-Diagram](/diagram/trident-3-Tier-Diagram.png)

## Builds

- **Manual build:** **[Click Here](/manual_build/README.MD)**
- **Terraform build:** **[Click Here](/terraform/README.MD)**

## Key Features

- VPC with public and private subnets
- Security groups for network segmentation
- EC2 with SSM Session Manager for secure portless access
- Auto Scaling Groups for dynamic scalability
- Application Load Balancers for traffic distribution
- NAT Gateway and Internet Gateway for controlled connectivity
- IAM roles and instance profiles aligned with least-privilege practices
- RDS for the database tier
- Terraform-based modular deployment using separate infrastructure stacks

## Terraform Build Highlights

The Terraform implementation has been refactored from an earlier 2025 version to better reflect cleaner infrastructure practices and improved project structure.

Highlights include:

- stack-based organization across **networking**, **security**, **compute**, and **database**
- reusable Terraform modules
- local stack data flow using Terraform outputs
- Amazon Linux 2023-based compute instances
- sandbox-friendly local state for demonstration environments

For full Terraform-specific documentation, see **[terraform/README.MD](/terraform/README.MD)**.

## Notes

- This project demonstrates both practical infrastructure understanding and the ability to automate the same environment using Terraform
- The manual build was first documented in Notion for speed and ease of documentation, then brought into the repository
- The project was originally named **Athena** and later renamed to **Trident**
- This was one of my earliest major cloud projects and has since been revisited and refactored as my Terraform and AWS skills improved

## Costs

- This project was built and tested in A Cloud Guru / Pluralsight AWS sandbox environments to avoid real-world charges
- Deploying this architecture in a personal or production AWS account will incur costs
- Use the [AWS Pricing Calculator](https://calculator.aws/#/) to estimate expected charges before deployment

## License

This project is licensed under the [MIT License](./LICENSE).