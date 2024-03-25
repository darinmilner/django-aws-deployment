data "archive_file" "auth-lambda-package" {
  type = "zip"
  source_file = "./authlambda/authorizer.py"
  output_path = "./authlambda/authorizer.zip"
}

# authorizor lambda
resource "aws_lambda_function" "authorizer-lambda" {
  filename      = "lambda/authorizor.zip"
  function_name = "api-auth-lambda"
  role          = aws_iam_role.auth-lambda-role.arn
  handler       = "index.lambda_handler"

  source_code_hash = filebase64sha256("./authlambda/authorizer.zip")
}
# Authorizor attachment
resource "aws_api_gateway_authorizer" "api-authorizer" {
  rest_api_id            = local.api_id
  name                   = "api-authorizor"
  type                   = "TOKEN"
  identity_source        = "method.request.header.Authorization"
  authorizer_uri         = aws_lambda_function.authorizer-lambda.invoke_arn
  authorizer_credentials = aws_iam_role.auth-lambda-role.arn
}

# deployment
resource "aws_api_gateway_deployment" "api-deployment" {
  depends_on  = [aws_api_gateway_integration.s3-integration]
  rest_api_id = local.api_id
  stage_name  = "dev"
}

resource "aws_api_gateway_stage" "api-stage" {
  rest_api_id           = local.api_id
  stage_name            = aws_api_gateway_deployment.api-deployment.stage_name
  deployment_id         = aws_api_gateway_deployment.api-deployment.id
  cache_cluster_enabled = false
  # TODO  - Throws Error
  #   authorizer_id = aws_api_gateway_authorizer.api-authorizor.id  
}
