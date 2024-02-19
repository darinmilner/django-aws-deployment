resource "aws_lb_target_group" "lb-tg" {
  name     = "lb-tg"
  port     = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled  = true
    protocol = "HTTP"
    path     = "/health"
  }
}

resource "aws_lb_target_group_attachment" "lb-attach" {
  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id        = aws_instance.server.id
  port             = 8080
}

resource "aws_lb" "app-lb" {
  name               = "App LB"
  internal           = true
  load_balancer_type = "network"

  subnets = [
    aws_subnet.private.id,
    aws_subnet.private-b.id
  ]
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}