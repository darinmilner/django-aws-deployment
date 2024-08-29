resource "aws_lb_target_group" "lb-tg" {
  name        = "lb-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lb-attach" {
  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id        = var.lambda-arn
  depends_on = [ aws_lambda_permission.invoke-lambda ]
}

resource "aws_lb" "app-lb" {
  name               = "lambda-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  enable_deletion_protection = false 
  
  subnets = [
    var.subnet1,
    var.subnet2
  ]
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn

    fixed_response {
      content_type = "text/plain"
      message_body = "Success"
      status_code  = 200
    }
  }
}

# # redireect to HTTPS if using Route53 domain
# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.app-lb.arn 
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# Maps incoming requests to the server (Lambda)
resource "aws_lb_listener_rule" "http-listener" {
  listener_arn = aws_lb_listener.lb-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }

  condition {
    path_pattern {
      values = [var.lambda-name]
    }
  }

  condition {
    http_request_method {
      values = ["GET","OPTIONS", "POST"]
    }
  }
}