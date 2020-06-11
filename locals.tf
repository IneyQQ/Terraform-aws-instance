locals {
  create_additional_sg = (length(var.open_ports_to_vpc) != 0) || local.create_public_access
  create_public_access = length(var.public_access) != 0
  defaul_public_access = {
    route53_public_zone_id = ""
    lb_listener_arn        = ""
    lb_security_group_id   = ""
    port                   = "80"
    health_check_path      = "/"
    health_check_matcher   = "200"
  }
  public_access = merge(local.defaul_public_access, var.public_access)
}
