resource "aws_security_group" "bastion_nlb_sg" {
  name   = "tf-bastion-nlb-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-bastion-nlb-sg"
  }
}

resource "aws_security_group" "asg_sg" {
  name   = "tf-asg_sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-asg-sg"
  }
}

resource "aws_security_group" "private" {
  name   = "tf-private-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-private-sg"
  }
}

# egress rules
resource "aws_vpc_security_group_egress_rule" "allow_icmp_out" {
  security_group_id = aws_security_group.bastion_nlb_sg.id

  ip_protocol = "ICMP"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  to_port     = -1

  tags = {
    "Name" = "tf-allow-icmp-out"
  }
}

locals {
  public_sg_ids = {
    id1 = aws_security_group.bastion_nlb_sg.id,
    id2 = aws_security_group.asg_sg.id
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_ssh_to_private" {
  for_each          = local.public_sg_ids
  security_group_id = each.value

  ip_protocol                  = "TCP"
  referenced_security_group_id = aws_security_group.private.id
  from_port                    = 22
  to_port                      = 22
  tags = {
    "Name" = "tf-allow-ssh-to-private"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_ssh_to_asg" {
  security_group_id = aws_security_group.bastion_nlb_sg.id

  ip_protocol                  = "TCP"
  referenced_security_group_id = aws_security_group.asg_sg.id
  from_port                    = 22
  to_port                      = 22
  tags = {
    "Name" = "tf-allow-ssh-to-asg"
  }
}

# ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_admin" {
  security_group_id = aws_security_group.bastion_nlb_sg.id

  ip_protocol = "TCP"
  cidr_ipv4   = format("%s/32", var.admin_ip)
  from_port   = 22
  to_port     = 22
  tags = {
    "Name" = "tf-allow-ssh-from-admin"
  }
}
locals {
  inbound_ssh_sg_ids = {
    id1 = aws_security_group.private.id,
    id2 = aws_security_group.asg_sg.id
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_nlb" {
  for_each          = local.inbound_ssh_sg_ids
  security_group_id = each.value

  ip_protocol                  = "TCP"
  referenced_security_group_id = aws_security_group.bastion_nlb_sg.id
  from_port                    = 22
  to_port                      = 22
  tags = {
    "Name" = "tf-allow-ssh-from-bastion-nlb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_asg" {
  security_group_id = aws_security_group.private.id

  ip_protocol                  = "TCP"
  referenced_security_group_id = aws_security_group.asg_sg.id
  from_port                    = 22
  to_port                      = 22
  tags = {
    "Name" = "tf-allow-ssh-from-asg"
  }
}