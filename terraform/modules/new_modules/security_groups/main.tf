resource "aws_security_group" "sg" {
  name                   = "${var.prefix}-${var.sg_name}-sg"
  description            = "Security group for ${var.prefix}-${var.sg_name}-sg"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = {
    Name = "${var.prefix}-${var.sg_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = var.ingress

  security_group_id            = aws_security_group.sg.id
  description                  = try(each.value.description, null)
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  from_port                    = try(each.value.from_port, null)
  to_port                      = try(each.value.to_port, null)
  ip_protocol                  = try(each.value.ip_protocol, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = var.egress

  security_group_id            = aws_security_group.sg.id
  description                  = try(each.value.description, null)
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  from_port                    = try(each.value.from_port, null)
  to_port                      = try(each.value.to_port, null)
  ip_protocol                  = try(each.value.ip_protocol, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}