provider "aws" {
  region                   = "ap-northeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_instance" "hellotf" {
  ami           = "ami-06ee4e2261a4dc5c3"
  instance_type = "t2.micro"
  tags = {
    Name = "tfdev"
  }

}