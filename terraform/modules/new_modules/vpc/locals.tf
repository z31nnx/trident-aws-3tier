locals {
  name                = "${var.prefix}-${var.vpc_name}"
  public_subnets      = { for k, v in var.subnets : k => v if v.type == "public" }
  public_subnet_by_az = { for k, v in var.subnets : v.az => k if v.type == "public" }
  private_subnets     = { for k, v in var.subnets : k => v if v.type == "private" }
  private_db_subnets  = { for k, v in var.subnets : k => v if v.type == "database" }
}

# public_subnet_by_az assumes theres only one subnet per az so terraform would explode. 
# Future build will scale this better