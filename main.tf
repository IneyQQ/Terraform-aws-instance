data aws_subnet main {
  id = var.subnet_id
}

data aws_vpc main {
  id = data.aws_subnet.main.vpc_id
}

resource aws_instance main {
  subnet_id              = data.aws_subnet.main.id
  ami                    = var.ami
  instance_type          = var.type
  key_name               = var.key_name
  vpc_security_group_ids = concat([for id, sg in data.aws_security_group.main : sg.id], aws_security_group.additional.*.id)
  iam_instance_profile   = var.iam_instance_profile_name
  tags = merge(var.tags,
    {
      Name = var.Name_tag
    }
  )
}

