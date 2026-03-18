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
  source                 = "../../../modules/new_modules/launch_template"
  lt_name                = "web-asg-lt"
  instance_type          = var.instance_type
  instance_profile       = data.terraform_remote_state.security.outputs.role_name["ssm"]
  device_name            = var.device_name
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.sg_id["web_sg"]]
  root_volume            = var.root_volume
  metadata_options       = var.metadata_options
  user_data              = filebase64("./userdata/web_userdata.sh")
  prefix                 = local.prefix
}


module "app_lt" {
  source                 = "../../../modules/new_modules/launch_template"
  lt_name                = "app-asg-lt"
  instance_type          = var.instance_type
  instance_profile       = data.terraform_remote_state.security.outputs.role_name["ssm"]
  device_name            = var.device_name
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.sg_id["app_sg"]]
  root_volume            = var.root_volume
  metadata_options       = var.metadata_options
  user_data              = filebase64("./userdata/app_userdata.sh")
  prefix                 = local.prefix
}