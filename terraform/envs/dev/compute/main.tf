data "terraform_remote_state" "networking" {
  backend = "local"
  config = {
    path = "../../../envs/dev/networking/terraform.tfstate"
  }
}

data "terraform_remote_state" "security" {
  backend = "local"
  config = {
    path = "../../../envs/dev/security/terraform.tfstate"
  }
}

module "web_lt" {
  source                  = "../../../modules/new_modules/launch_template"
  lt_name                 = "web-asg-lt"
  instance_type           = var.instance_type
  instance_profile        = data.terraform_remote_state.security.outputs.ssm_role_profile
  device_name             = var.device_name
  vpc_security_group_ids  = [data.terraform_remote_state.security.outputs.sg_id["web_sg"]]
  root_volume             = var.root_volume
  disable_api_stop        = false
  disable_api_termination = false
  metadata_options        = var.metadata_options
  user_data               = filebase64("./userdata/web_userdata.sh")
  prefix                  = local.prefix
}

module "app_lt" {
  source                  = "../../../modules/new_modules/launch_template"
  lt_name                 = "app-asg-lt"
  instance_type           = var.instance_type
  instance_profile        = data.terraform_remote_state.security.outputs.ssm_role_profile
  device_name             = var.device_name
  vpc_security_group_ids  = [data.terraform_remote_state.security.outputs.sg_id["app_sg"]]
  root_volume             = var.root_volume
  disable_api_stop        = false
  disable_api_termination = false
  metadata_options        = var.metadata_options
  user_data               = filebase64("./userdata/app_userdata.sh")
  prefix                  = local.prefix
}

module "web_alb" {
  source                     = "../../../modules/new_modules/load_balancer"
  lb_name                    = "web-alb"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  security_groups            = [data.terraform_remote_state.security.outputs.sg_id["web_alb_sg"]]
  subnets = [
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["web-public-a"]["id"],
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["web-public-b"]["id"]
  ]
  target_group = {
    main_tg = {
      name             = "web-alb"
      port             = 80
      protocol         = "HTTP"
      ip_address_type  = "ipv4"
      vpc_id           = data.terraform_remote_state.networking.outputs.vpc_id["main_vpc"]
      protocol_version = "HTTP1"
      target_type      = "instance"
    }
  }
  health_check = {
    main = {
      protocol            = "HTTP"
      path                = "/index.html"
      matcher             = "200"
      healthy_threshold   = 5
      unhealthy_threshold = 2
      timeout             = 5
      interval            = 30
    }
  }
  prefix = local.prefix
}

module "web_asg" {
  source                    = "../../../modules/new_modules/auto_scale"
  asg_name                  = "web"
  max_size                  = 5
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  launch_template           = module.web_lt.launch_template_id
  vpc_zone_identifier = [
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["web-public-a"]["id"],
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["web-public-b"]["id"]
  ]
  target_group_arns              = [module.web_alb.target_group["main_tg"]["arn"]]
  capacity_distribution_strategy = "balanced-best-effort"
  min_healthy_percentage         = 90
  max_healthy_percentage         = 120
  prefix                         = local.prefix
}

module "app_alb" {
  source                     = "../../../modules/new_modules/load_balancer"
  lb_name                    = "app-alb"
  internal                   = true
  load_balancer_type         = "application"
  enable_deletion_protection = false
  security_groups            = [data.terraform_remote_state.security.outputs.sg_id["app_alb_sg"]]
  subnets = [
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["app-private-a"]["id"],
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["app-private-b"]["id"]
  ]
  target_group = {
    main_tg = {
      name             = "app-alb"
      port             = 80
      protocol         = "HTTP"
      ip_address_type  = "ipv4"
      vpc_id           = data.terraform_remote_state.networking.outputs.vpc_id["main_vpc"]
      protocol_version = "HTTP1"
      target_type      = "instance"
    }
  }
  health_check = {
    main = {
      protocol            = "HTTP"
      path                = "/app/index.html"
      matcher             = "200"
      healthy_threshold   = 5
      unhealthy_threshold = 2
      timeout             = 5
      interval            = 30
    }
  }
  prefix = local.prefix
}

module "app_asg" {
  source                    = "../../../modules/new_modules/auto_scale"
  asg_name                  = "app"
  max_size                  = 5
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  launch_template           = module.app_lt.launch_template_id
  vpc_zone_identifier = [
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["app-private-a"]["id"],
    data.terraform_remote_state.networking.outputs.subnets.main_vpc["app-private-b"]["id"]
  ]
  target_group_arns              = [module.app_alb.target_group["main_tg"]["arn"]]
  capacity_distribution_strategy = "balanced-best-effort"
  min_healthy_percentage         = 90
  max_healthy_percentage         = 120
  prefix                         = local.prefix
}