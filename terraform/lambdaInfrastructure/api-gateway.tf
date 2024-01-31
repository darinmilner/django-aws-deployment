resource "aws_api_gateway_rest_api" "test-api" {
  name        = "${var.environment}-${local.short_region}-api"
  description = "API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root-endpoint" {
  rest_api_id = local.api_id
  parent_id   = aws_api_gateway_rest_api.test-api.root_resource_id
  path_part   = "api" // endpoint  <URL>/api
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = local.api_id
  resource_id   = local.resource_id
  http_method   = local.http_post_type
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda-integration" {
  rest_api_id             = local.api_id
  resource_id             = local.resource_id
  http_method             = local.http_post_type
  integration_http_method = aws_api_gateway_method.proxy.http_method
  type                    = "AWS"
}

resource "aws_api_gateway_method_response" "ok-response" {
  rest_api_id = local.api_id
  resource_id = local.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = local.ok_response
}

resource "aws_api_gateway_integration_response" "response-integration" {
  rest_api_id = local.api_id
  resource_id = local.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = local.ok_response

  depends_on = [aws_api_gateway_integration.lambda-integration, aws_api_gateway_method.proxy]
}

resource "aws_api_gateway_method_response" "cors-proxy" {
  rest_api_id = local.api_id
  resource_id = local.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = local.ok_response

  response_parameters = {
    "method.response.header.Access_Control-Allow-Headers" = true,
    "method.response.header.Access_Control-Allow-Methods" = true,
    "method.response.header.Access_Control-Allow-Origin"  = true,
  }
}

resource "aws_api_gateway_integration_response" "response" {
  rest_api_id = local.api_id
  resource_id = local.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = local.ok_response

  response_parameters = {
    "method.response.header.Access_Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access_Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access_Control-Allow-Origin"  = "'*'",
  }

  depends_on = [aws_api_gateway_method.proxy, aws_api_gateway_integration.lambda-integration]
}