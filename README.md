# Trident AWS 3-Tier Infra
[![Terraform CI](https://github.com/z31nnx/trident-aws-3tier/actions/workflows/terraform.yml/badge.svg)](https://github.com/z31nnx/trident-aws-3tier/actions/workflows/terraform.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Trident is a resilient, highly available, and secure AWS 3-tier architecture deployed manually and with **Terraform** (IaC). 

> **Renaming Notice — Sep 2025**
>
> This project was previously named **Athena**. It was renamed to **Trident** to avoid **service/resource naming collisions** (e.g., security groups, ALBs, ASGs, RDS identifiers).  
> Any screenshots or tags that still show `athena-*` refer to the same project prior to the rename.

# Overview 
This project demonstrates the deployment of a modern 3-tier architecture using both manual steps and Infrastructure as Code (IaC). It incorporates core AWS services to ensure scalability, availability, and security. 

![Trident-3-Tier-Architecture-Diagram](/diagram/trident-3-Tier-Diagram.png) 

# Builds
- **Manual build:** **[Click Here](/manual_build/README.MD)**
- **Terraform build:** **[Click Here](/terraform/README.MD)**

# Key Features
- VPC with Public & Private Subnets 
- Security Groups for network segmentation 
- EC2 with SSM (session manager) for secure portless access 
- Autoscaling Group (ASG) for dynamic scalability 
- Application Load Balancer (ALB) for traffic distribution 
- NAT Gateway (NAT) and Internet Gateway (IGW) for Internet Access
- IAM Role for EC2 aligning with best practices 
- RDS database for data storage 

## Notes  
- This project demonstrates both practical infrastructure understanding and the ability to deploy it using code.
- Manual build was first documented in Notion with the ease of documentation for efficiency. 
- The project name was initially named Athena but due to collision with the AWS service, I have changed it to Trident, still a fitting name. 
- This was my first real project that I took time on, I will improve it as time goes and with more experience I get towards my journey in Cloud and Cybersecurity. 

## Costs 
-  This project was built/tested in A Cloud Guru’s/Pluralsight AWS sandbox to avoid real-world charges.
- There are cost considerations when this architecture gets deployed in a real AWS account. 
- I recommend checking [AWS Pricing Calculator](https://calculator.aws/#/) to estimate total costs. 

## License
This project is licensed under the [MIT License](./LICENSE).

