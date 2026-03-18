resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${local.name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-igw"
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.type == "public"

  tags = {
    Name = "${local.name}-${each.key}-${each.value.az}"
  }
}

resource "aws_eip" "nateip" {
  for_each = local.public_subnet_by_az

  domain = "vpc"

  tags = {
    Name = "${local.name}-nateip-${each.key}"
  }
}

resource "aws_nat_gateway" "natgw" {
  for_each = local.public_subnet_by_az

  allocation_id = aws_eip.nateip[each.key].id
  subnet_id     = aws_subnet.subnets[each.value].id

  tags = {
    Name = "${local.name}-natgw-${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = local.public_subnet_by_az

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw[each.key].id
  }

  tags = {
    Name = "${local.name}-private-rt-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private[each.value.az].id
}

resource "aws_route_table" "private_db" {
  for_each = toset(["us-east-1a", "us-east-1b"])

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-private-db-rt-${each.key}"
  }
}

resource "aws_route_table_association" "private_db" {
  for_each = local.private_db_subnets

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private_db[each.value.az].id
}