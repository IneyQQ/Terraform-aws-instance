data aws_security_group main {
  for_each = toset(var.vpc_security_group_ids)
  id       = each.key
}

#
# Additional SG
#
resource aws_security_group additional {
  count                = local.create_additional_sg ? 1 : 0
  name                 = "Additional for ${var.Name_tag}"
  vpc_id               = data.aws_vpc.main.id
}

resource aws_security_group_rule additional_tcp_ingress_ports_from_vpc_cidr {
  for_each             = toset(var.open_ports_to_vpc)
  type                 = "ingress"
  from_port            = each.key
  to_port              = each.key
  protocol             = "tcp"
  cidr_blocks          = [ data.aws_vpc.main.cidr_block ]
  security_group_id    = aws_security_group.additional[0].id
}

resource aws_network_interface_sg_attachment additional {
  count                = local.create_additional_sg ? 1 : 0
  security_group_id    = aws_security_group.additional[0].id
  network_interface_id = aws_instance.main.primary_network_interface_id
}

data aws_security_group lb {
  count                    = local.create_public_access ? 1 : 0
  id                       = local.public_access.lb_security_group_id
}

resource aws_security_group_rule additional_tcp_ingress_port_from_lb {
  count                    = local.create_public_access ? 1 : 0
  type                     = "ingress"
  from_port                = local.public_access.port
  to_port                  = local.public_access.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.additional[0].id
  source_security_group_id = data.aws_security_group.lb[0].id
}
