resource "aws_lb" "public_nlb" {
  name               = "tf-public-nlb"
  load_balancer_type = "network"
  subnets            = aws_subnet.public_subnets[*].id
  security_groups    = [aws_security_group.bastion_nlb_sg.id]
}

resource "aws_lb_target_group" "ssh_tg" {
  vpc_id   = aws_vpc.main.id
  name     = "tf-ssh-tg"
  protocol = "TCP"
  port     = 22

}

resource "aws_lb_listener" "ssh_listener" {
  load_balancer_arn = aws_lb.public_nlb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssh_tg.arn
  }
}
