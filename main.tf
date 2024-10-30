provider "aws" {
  region  = var.aws_region
  profile = "tf-user"
  # shared_credentials_files = ["~/.aws/credentials"][tf-user]
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
    "Name" = "tf-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    "Name" = "tf-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "azs" {
  input        = data.aws_availability_zones.available.names
  result_count = length(var.public_subnets)
}

# configure public subnet
resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.main.id

  count             = length(var.public_subnets)
  cidr_block        = var.public_subnets[count.index]
  availability_zone = random_shuffle.azs.result[count.index]
  # map_public_ip_on_launch = true
  tags = {
    "Name" = "tf-public-subnets${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.main.id

  count             = length(var.private_subnets)
  cidr_block        = var.private_subnets[count.index]
  availability_zone = random_shuffle.azs.result[count.index]
  tags = {
    "Name" = "tf_private_subnets${count.index + 1}"
  }
}

resource "aws_autoscaling_group" "this" {
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = aws_subnet.public_subnets[*].id
  launch_template {
    id      = aws_launch_template.public_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "tf-asg"
    propagate_at_launch = true
  }
  target_group_arns = [aws_lb_target_group.ssh_tg.arn]
}