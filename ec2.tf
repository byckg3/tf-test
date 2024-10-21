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

resource "aws_launch_template" "public_lt" {
  image_id               = data.aws_ami.linux.id
  instance_type          = "t2.micro"
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.linux.id
  instance_type               = "t2.micro"
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.public_subnets[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_nlb_sg.id]
  tags = {
    Name = "tf_bastion"
  }
}

resource "aws_instance" "private_instance" {
  ami           = data.aws_ami.linux.id
  instance_type = "t2.micro"
  key_name      = var.ec2_key_name
  subnet_id     = aws_subnet.private_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.private.id
  ]
  tags = {
    Name = "tf-private-instance1"
  }
}