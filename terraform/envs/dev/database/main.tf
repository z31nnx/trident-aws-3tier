data "terraform_remote_state" "networking" {
  backend = "local"
  config = {
    path = "../networking/terraform.tfstate"
  }
}
data "terraform_remote_state" "security" {
  backend = "local"
  config = {
    path = "../security/terraform.tfstate"
  }
}

module "main_db" {
  source  = "../../../modules/new_modules/rds"
  db_name = "database"
  subnet_ids = [
    data.terraform_remote_state.networking.outputs.subnets["main_vpc"]["rds-private-a"]["id"],
    data.terraform_remote_state.networking.outputs.subnets["main_vpc"]["rds-private-b"]["id"]
  ]
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = "db.t3.micro"
  storage_type               = "gp3"
  allocated_storage          = 20
  max_allocated_storage      = 1000
  vpc_security_group_ids     = [data.terraform_remote_state.security.outputs.sg_id["database_sg"]]
  multi_az                   = true
  publicly_accessible        = false
  skip_final_snapshot        = true
  backup_retention_period    = 7
  storage_encrypted          = true
  auto_minor_version_upgrade = true
  apply_immediately          = true
  deletion_protection        = false
  db_username                = var.db_username
  db_password                = var.db_password
  prefix                     = local.prefix
}