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
    resources = [aws_lambda_function.authorizer-lambda.arn]
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
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }   
  }
}

resource "aws_iam_role" "auth-lambda-role" {
  name               = "auth-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.auth-lambda-role.json
}

resource "aws_lambda_permission" "allow-apigw-invoke" {
  statement_id = "allowInvokeFromAPIGatewayAuthorizer"
  action = "lambda:InvokeFunction"
  function_name = aws_api_gateway_authorizer.api-authorizer.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.test-api.execution_arn}/authorizers/${aws_api_gateway_authorizer.api-authorizer.id}"
}