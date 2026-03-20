variable "name_prefix" {
  type = string
}
variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}
variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
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
