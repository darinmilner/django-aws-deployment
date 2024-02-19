resource "aws_apigatewayv2_api" "api-gateway" {
  name          = "api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api-stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "state"
  auto_deploy = true
}

resource "aws_apigatewayv2_vpc_link" "vpc-link" {
  name               = "api-gateway-vpc-link"
  security_group_ids = [aws_security_group.vpc-sg.id]
  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private-b.id
  ]
}