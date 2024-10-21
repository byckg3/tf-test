output "aws_info" {
  value = {
    aws_region         = var.aws_region
    availability_zone1 = random_shuffle.azs.result[0]
    availability_zone2 = random_shuffle.azs.result[1]
  }
}

output "public_subnets" {
  value = [for each in aws_subnet.public_subnets : "${each.cidr_block} -> ${each.availability_zone}"]
}

output "private_subnets" {
  value = [for each in aws_subnet.private_subnets : "${each.cidr_block} -> ${each.availability_zone}"]
}

locals {
  bastion_public_ip  = aws_instance.bastion_host.public_ip
  privat_instance_ip = aws_instance.private_instance.private_ip
}

output "bastion" {
  value = {
    # # key/value pairs can be separated by either a comma or a line break
    id             = aws_instance.bastion_host.id
    instance_state = aws_instance.bastion_host.instance_state
    ssh            = "ssh -i ~/.ssh/${var.ec2_key_name}.pem ec2-user@${local.bastion_public_ip}"
  }
}

output "private_instance" {
  value = {
    id         = aws_instance.private_instance.id
    private_ip = aws_instance.private_instance.private_ip
    ssh1       = "ssh-add ~/.ssh/${var.ec2_key_name}.pem && ssh -A ec2-user@${local.bastion_public_ip}"
    ssh2       = "ssh ec2-user@${local.privat_instance_ip}"
  }
}

output "nlb" {
  value = {
    dns_name = aws_lb.public_nlb.dns_name
    ssh      = "ssh -i ~/.ssh/${var.ec2_key_name}.pem ec2-user@${aws_lb.public_nlb.dns_name}"
  }
}
