output "athena_rds_db_endpoint" {
  value = aws_db_instance.trident_db.endpoint
}

output "athena_rds_db_identifier" {
  value = aws_db_instance.trident_db.id
}
