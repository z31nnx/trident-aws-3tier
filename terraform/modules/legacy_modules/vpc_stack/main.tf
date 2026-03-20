# The VPC
resource "aws_vpc" "trident_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}"
  }
}

# The VPC's Internet Gateway which allows us to connect to the internet
resource "aws_internet_gateway" "trident_igw" {
  vpc_id = aws_vpc.trident_vpc.id

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}-igw"
  }
}

resource "aws_eip" "nat_eip" { # Elastic IP (EIP) for the NAT gateway
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}-eip"
  }
}

resource "aws_nat_gateway" "trident_natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}-natgw"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets # for_each runs through all defined public subnets

  vpc_id                                      = aws_vpc.trident_vpc.id # Targets the Trident VPC 
  cidr_block                                  = each.value.cidr_block  # CIDR block in var.public_subnets (e.g., 10.0.1.0/24)
  availability_zone                           = each.value.az          # The availability zone per public subnet
  map_public_ip_on_launch                     = true                   # Enables auto-assign public IPv4 
  enable_resource_name_dns_a_record_on_launch = true                   # Enables automatic DNS A-records for instances with names

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}-public-subnet-${each.value.az}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id                                      = aws_vpc.trident_vpc.id
  cidr_block                                  = each.value.cidr_block
  availability_zone                           = each.value.az
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}-private-subnet-${each.value.az}"
  }
}

# The public route table to connect the public subnets
resource "aws_route_table" "trident_public_rt" {
  vpc_id = aws_vpc.trident_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.trident_igw.id
  }

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}-public-rt"
  }
}

# The private route table to connect the private subnets 
resource "aws_route_table" "trident_private_rt" {
  vpc_id = aws_vpc.trident_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.trident_natgw.id
  }

  tags = {
    Name = "${var.name_prefix}-${var.vpc_name}-private-rt"
  }
}

# Associates the public and private subnets to the corresponding route tables 
resource "aws_route_table_association" "trident_public_rt_association" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.trident_public_rt.id
}

resource "aws_route_table_association" "trident_private_rt_association" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.trident_private_rt.id
}
