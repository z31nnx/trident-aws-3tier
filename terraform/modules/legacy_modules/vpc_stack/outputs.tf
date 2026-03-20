# Outputs resource ids and important settings, makes debugging easier
output "vpc_id" {
  value = aws_vpc.trident_vpc.id # Used by ASG, ALB, and RDS modules for resource attachment
}

output "public_subnets_id" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnets_id" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

# Outputs exactly 2 private subnets, one from each AZ to prevent conflicting errors
# ALBs require one subnet per Availability Zone, including duplicates would cause deployment failure
output "private_subnets_id_per_az" {
  value = [
    aws_subnet.private_subnets["private_subnet_1"].id,
    aws_subnet.private_subnets["private_subnet_2"].id
  ]
}

output "igw_id" {
  value = aws_internet_gateway.trident_igw.id
}

output "natgw_id" {
  value = aws_nat_gateway.trident_natgw.id
}