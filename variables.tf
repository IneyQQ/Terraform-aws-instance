#
# Tags
#
variable tags {
  type = map
  default = {}
  description = "A map of tags to add to all resources"
}
variable Name_tag {
  description = "Value for tag 'Name' and some named resources"
}

#
# Instance vars
#
variable ami {
  default = "ami-54550b2b"
}
variable type {
  default = "t2.micro"
}
variable subnet_id {}
variable key_name {
  default = ""
}
variable vpc_security_group_ids {
  type = list(string)
}
variable iam_instance_profile_name {}
variable aws_route53_private_zone_id {}
variable instance_name {}
variable open_ports_to_vpc {
  type    = list(string)
  default = []
}

#
# Public access vars
#
variable public_access {
  type    = map(string)
  default = {}
}

