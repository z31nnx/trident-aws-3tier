# Tags 
variable "environment" {
  type = string
}
variable "project" {
  type = string
}
variable "owner" {
  type = string
}
variable "managedby" {
  type = string
}
variable "region" {
  type = string
}

# VPC
variable "vpc_name" {
  type = string
}
variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  description = "Map of public subnets with AZ and CIDR"
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnets with AZ and CIDR"
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

# IAM variables
variable "iam_role_name" {
  type = string
}
variable "iam_instance_profile_name" {
  type = string
}

# Launch templates 

variable "launch_template_names" {
  type = object({
    web = string
    app = string
  })
}
variable "ec2_name" {
  type = string
}
variable "instance_types" {
  type = string
}

# RDS 
variable "db_subnet_group_name" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_username" {
  sensitive = true
  type      = string
}
variable "db_password" {
  type      = string
  sensitive = true
}