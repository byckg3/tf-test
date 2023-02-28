provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_vpc" "main" {
  cidr_block = var.aws_vpc_cidr
  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "tf_igw"
  }
}

# configure public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.aws_public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    "Name" = "tf_public_subnet"
  }
}

resource "aws_route_table" "for_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    "Name" = "tf_table"
  }
}

resource "aws_route_table_association" "for_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.for_public.id
}

resource "aws_security_group" "allow_ssh" {
  name   = "tf-sg-allow-ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", var.admin_ip)]
  }
  tags = {
    Name = "tf_ssh"
  }
}
resource "aws_instance" "bastion_host" {
  ami           = "ami-06ee4e2261a4dc5c3"
  instance_type = "t2.micro"
  key_name      = var.ec2_key_name
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id
  ]
  tags = {
    Name = "tf_bastion"
  }
}


# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.aws_private_subnet_cidr

# }