output "aws_info" {
  value = {
    aws_region         = var.aws_region
    availability_zone1 = data.aws_availability_zones.available.names[0]
    availability_zone2 = data.aws_availability_zones.available.names[1]
  }
}

output "instance1_status" {
  value = {
    # # key/value pairs can be separated by either a comma or a line break
    id             = aws_instance.bastion_host.id
    public_ip      = aws_instance.bastion_host.public_ip
    instance_state = aws_instance.bastion_host.instance_state
    ssh            = "ssh -i ~/.ssh/${var.ec2_key_name}.pem ec2-user@${aws_instance.bastion_host.public_ip}"
  }
}