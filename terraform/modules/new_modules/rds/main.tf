resource "aws_db_subnet_group" "group" {
  name       = "${var.prefix}-${var.db_name}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.prefix}-${var.db_name}-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  identifier                 = "${var.prefix}-${var.db_name}-db"
  db_subnet_group_name       = aws_db_subnet_group.group.name
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  storage_type               = var.storage_type
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  vpc_security_group_ids     = var.vpc_security_group_ids
  multi_az                   = var.multi_az
  publicly_accessible        = var.publicly_accessible
  skip_final_snapshot        = var.skip_final_snapshot
  backup_retention_period    = var.backup_retention_period
  storage_encrypted          = var.storage_encrypted
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  username                   = var.db_username
  password                   = var.db_password
  apply_immediately          = var.apply_immediately
  deletion_protection        = var.deletion_protection

  tags = {
    Name = "${var.prefix}-${var.db_name}-db"
  }
}