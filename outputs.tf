output "aws_info" {
  value = {
    aws_region = var.aws_region
  }
}

output "instance1_status" {
  value = {
    # key/value pairs can be separated by either a comma or a line break
    id             = aws_instance.instance1.id
    public_ip      = aws_instance.instance1.public_ip
    instance_state = aws_instance.instance1.instance_state
  }
}