#
# Private zone data
#
data aws_route53_zone private {
  zone_id      = var.aws_route53_private_zone_id
  private_zone = true
}

#
# Private record
#
resource aws_route53_record private {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = var.instance_name
  type    = "A"
  ttl     = "5"
  records = [ aws_instance.main.private_ip ]
}


#
# Public zone data
#
data aws_route53_zone public {
  count                = local.create_public_access ? 1 : 0
  zone_id              = local.public_access.route53_public_zone_id
}

#
# Public records
#
resource aws_route53_record public {
  count                    = local.create_public_access ? 1 : 0
  zone_id                  = data.aws_route53_zone.public[0].id
  name                     = "${var.instance_name}.${data.aws_route53_zone.public[0].name}"
  type                     = "A"
  alias {
    name                   = data.aws_lb.main[0].dns_name
    zone_id                = data.aws_lb.main[0].zone_id
    evaluate_target_health = true
  }
}
