module "vpc" {
  source               = "../../../modules/new_modules/vpc"
  vpc_name             = var.vpc_name
  cidr_block           = var.cidr_block
  subnets              = var.subnets
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  prefix               = local.prefix
}