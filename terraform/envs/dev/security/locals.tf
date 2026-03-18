locals {
  base_tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = var.managedby
  }
  prefix = "${var.environment}-${var.project}"
}

locals {
  portless = {}
  egress = {
    "allow_all" = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }
}