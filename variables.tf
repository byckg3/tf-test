variable "aws_region" {
  type = string
}

variable "aws_vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
variable "ec2_key_name" {
  type = string
}

variable "admin_ip" {
  type = string
}