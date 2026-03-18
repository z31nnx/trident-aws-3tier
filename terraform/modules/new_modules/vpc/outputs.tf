output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = {
    for k, v in aws_subnet.subnets :
    k => {
      id   = v.id
      az   = v.availability_zone
      cidr = v.cidr_block
    }
  }
}