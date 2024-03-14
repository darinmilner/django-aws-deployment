# authorizor lambda
resource "aws_lambda_function" "authorizor-lambda" {
  filename      = "lambda/authorizor.zip"
  function_name = "api-auth-lambda"
  role          = aws_iam_role.auth-lambda-role.arn
  handler       = "index.lambda_handler"

  source_code_hash = filebase64sha256("authlambda/authorizor.zip")
}
# Authorizor attachment
resource "aws_api_gateway_authorizer" "api-authorizor" {
  rest_api_id            = local.api_id
  name                   = "api-authorizor"
  type                   = "TOKEN"
  identity_source        = "method.request.header.Authorization"
  authorizer_uri         = aws_lambda_function.authorizor-lambda.invoke_arn
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
#TODO Add S3 API ROLE and Policy

data "aws_iam_policy_document" "api-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "invocation-role" {
  name               = "api-auth-invocation"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.api-role.json
}

data "aws_iam_policy_document" "invocation-policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.authorizor-lambda.arn]
  }
}

resource "aws_iam_role_policy" "invocation-policy" {
  name   = "default"
  role   = aws_iam_role.invocation-role.id
  policy = data.aws_iam_policy_document.invocation-policy.json
}


data "aws_iam_policy_document" "auth-lambda-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "auth-lambda-role" {
  name               = "auth-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.auth-lambda-role.json
}