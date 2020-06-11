data aws_lb_listener main {
  count                    = local.create_public_access ? 1 : 0
  arn                      = local.public_access.lb_listener_arn
}

data aws_lb main {
  count                    = local.create_public_access ? 1 : 0
  arn                      = data.aws_lb_listener.main[0].load_balancer_arn
}

resource aws_lb_target_group main {
  count       = local.create_public_access ? 1 : 0
  name        = var.instance_name
  port        = local.public_access.port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"
  health_check {
    path = local.public_access.health_check_path
    matcher = local.public_access.health_check_matcher
    unhealthy_threshold = 10
  }

}

resource aws_lb_listener_rule main {
  count    = local.create_public_access ? 1 : 0
  listener_arn = data.aws_lb_listener.main[0].arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }

  condition {
    host_header {
      values         = [aws_route53_record.public[0].name]
    }
  }
}

resource aws_lb_target_group_attachment main {
  count            = local.create_public_access ? 1 : 0
  target_group_arn = aws_lb_target_group.main[0].arn
  target_id        = aws_instance.main.private_ip
  port             = local.public_access.port
}

