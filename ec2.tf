data "aws_ami" "linux" {
  most_recent = true
  #   filter {
  #     name   = "name"
  #     values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  #   }
  filter {
    name   = "image-id"
    values = ["ami-0e56f7ba9d8df2e9f"]
  }
  owners = ["amazon"]
}

resource "aws_launch_template" "common" {
  image_id      = data.aws_ami.linux.id
  instance_type = "t2.micro"
  key_name      = var.ec2_key_name
}

resource "aws_instance" "bastion_host" {
  launch_template {
    id = aws_launch_template.common.id
  }
  subnet_id = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh_icmp.id
  ]
  tags = {
    Name = "tf_bastion"
  }
}