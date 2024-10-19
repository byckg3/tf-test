resource "aws_security_group" "allow_ssh_icmp" {
  name   = "tf-allow-ssh-icmp"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-public-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_admin" {
  security_group_id = aws_security_group.allow_ssh_icmp.id

  ip_protocol = "tcp"
  cidr_ipv4   = format("%s/32", var.admin_ip)
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_ssh_out" {
  security_group_id = aws_security_group.allow_ssh_icmp.id

  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.private.id
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_icmp_out" {
  security_group_id = aws_security_group.allow_ssh_icmp.id

  ip_protocol = "icmp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  to_port     = -1

  tags = {
    "Name" = "tf-allow-icmp-out"
  }
}

resource "aws_security_group" "private" {
  name   = "tf-private-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_public_sg" {
  security_group_id = aws_security_group.private.id

  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.allow_ssh_icmp.id
  from_port                    = 22
  to_port                      = 22
}