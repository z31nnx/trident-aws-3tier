data "terraform_remote_state" "networking" {
  backend = "local"
  config = {
    path = "../../../envs/dev/networking/terraform.tfstate"
  }
}

module "ssm_role" {
  source               = "../../../modules/new_modules/assume_role"
  role_name            = var.role_name
  max_session_duration = var.max_session_duration
  trusted_services     = var.trusted_services
  trusted_arns         = var.trusted_arns
  policy_arns          = var.policy_arns
  prefix               = local.prefix
}

module "web_alb_sg" {
  source  = "../../../modules/new_modules/security_groups"
  vpc_id  = data.terraform_remote_state.networking.outputs.vpc_id["main_vpc"]
  sg_name = "web-alb"
  ingress = {
    "http" = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
    }
    "https" = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
    }
  }
  egress = local.egress
  prefix = local.prefix
}
module "web_sg" {
  source  = "../../../modules/new_modules/security_groups"
  vpc_id  = data.terraform_remote_state.networking.outputs.vpc_id["main_vpc"]
  sg_name = "web"
  ingress = {
    "http-from-web-alb" = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.web_alb_sg.sg_id
    }
  }
  egress = local.egress
  prefix = local.prefix
}

module "app_alb_sg" {
  source  = "../../../modules/new_modules/security_groups"
  vpc_id  = data.terraform_remote_state.networking.outputs.vpc_id["main_vpc"]
  sg_name = "app-alb"
  ingress = {
    "http-from-web" = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.web_sg.sg_id
    }
  }
  egress = local.egress
  prefix = local.prefix
}

module "app_sg" {
  source  = "../../../modules/new_modules/security_groups"
  vpc_id  = data.terraform_remote_state.networking.outputs.vpc_id["main_vpc"]
  sg_name = "app"
  ingress = {
    "http-from-app-alb" = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.app_alb_sg.sg_id
    }
  }
  egress = {
    "mysql-to-db" = {
      from_port                    = 3306
      to_port                      = 3306
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.database_sg.sg_id
    }
  }
  prefix = local.prefix
}

module "database_sg" {
  source  = "../../../modules/new_modules/security_groups"
  vpc_id  = data.terraform_remote_state.networking.outputs.vpc_id["main_vpc"]
  sg_name = "database"
  ingress = {
    "mysql-from-app" = {
      from_port                    = 3306
      to_port                      = 3306
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.app_sg.sg_id
    }
  }
  egress = local.portless
  prefix = local.prefix
}