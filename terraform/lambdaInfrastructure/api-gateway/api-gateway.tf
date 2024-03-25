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

resource "aws_api_gateway_resource" "s3-endpoint" {
  rest_api_id = local.api_id
  parent_id = aws_api_gateway_rest_api.test-api.root_resource_id
  path_part = "photos"
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

resource "aws_api_gateway_method" "s3-method" {
  rest_api_id =local.api_id
  resource_id = aws_api_gateway_resource.s3-endpoint.id 
  http_method = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api-authorizer.id  
}

resource "aws_api_gateway_integration" "s3-integration" {
  rest_api_id             = local.api_id
  resource_id             = local.resource_id
  http_method             = "GET"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "api-gateway-path/bucket/key"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "statusCode : 200"
  }

  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }
}

resource "aws_api_gateway_method_response" "s3-method-response" {
  rest_api_id = local.api_id
  resource_id = local.resource_id
  http_method = aws_api_gateway_integration.s3-integration.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "s3-integration-response" {
  rest_api_id = local.api_id
  resource_id = local.resource_id
  http_method = aws_api_gateway_integration.s3-integration.http_method
  status_code = aws_api_gateway_method_response.s3-method-response.status_code

  # May NOT be needed
  # response_templates = {
  #   "application/json" = ""
  # }
}
