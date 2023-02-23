provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_instance" "instance1" {
  ami           = "ami-06ee4e2261a4dc5c3"
  instance_type = "t2.micro"
  key_name      = var.ec2_key_name
  tags = {
    Name = "tf_instance1"
  }
}