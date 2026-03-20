terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project     = var.project
      environment = var.environment
      owner       = var.owner
      managedby   = var.managedby
    }
  }
}

module "vpc_stack" {
  source          = "../../modules/vpc_stack"
  vpc_name        = var.vpc_name
  cidr_block      = var.cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  name_prefix     = local.name_prefix
}

module "security_groups" {
  source      = "../../modules/security_groups"
  vpc_id      = module.vpc_stack.vpc_id
  name_prefix = local.name_prefix
}

module "iam_stack" {
  source                    = "../../modules/iam_stack"
  iam_instance_profile_name = var.iam_instance_profile_name
  iam_role_name             = var.iam_role_name
  name_prefix               = local.name_prefix
}

module "launch_template" {
  source                    = "../../modules/launch_template"
  trident_web_sg_id         = module.security_groups.trident_web_sg_id
  trident_app_sg_id         = module.security_groups.trident_app_sg_id
  ec2_instance_profile_name = module.iam_stack.ec2_instance_profile_name
  launch_template_names     = var.launch_template_names
  ec2_name                  = var.ec2_name
  instance_types            = var.instance_types
  name_prefix               = local.name_prefix
}

module "alb_stack" {
  source                = "../../modules/alb_stack"
  vpc_id                = module.vpc_stack.vpc_id
  alb_public_subnets    = module.vpc_stack.public_subnets_id
  alb_private_subnets   = module.vpc_stack.private_subnets_id_per_az
  trident_web_alb_sg_id = module.security_groups.trident_web_alb_sg_id
  trident_app_alb_sg_id = module.security_groups.trident_app_alb_sg_id
  name_prefix           = local.name_prefix
}

module "asg_stack" {
  source              = "../../modules/asg_stack"
  web_launch_template = module.launch_template.launch_template_names["web"]
  app_launch_template = module.launch_template.launch_template_names["app"]
  asg_public_subnets  = module.vpc_stack.public_subnets_id
  asg_private_subnets = module.vpc_stack.private_subnets_id_per_az
  web_alb_tg_arn      = module.alb_stack.alb_target_group_arns["web"]
  app_alb_tg_arn      = module.alb_stack.alb_target_group_arns["app"]
  project             = var.project
  environment         = var.environment
  owner               = var.owner
  managedby           = var.managedby
  name_prefix         = local.name_prefix
}

module "rds_stack" {
  source               = "../../modules/rds_stack"
  db_private_subnets   = module.vpc_stack.private_subnets_id_per_az
  trident_db_sg_id     = module.security_groups.trident_data_sg_id
  db_subnet_group_name = var.db_subnet_group_name
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  name_prefix          = local.name_prefix
}

