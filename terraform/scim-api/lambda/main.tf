data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/code/test_lambda.py"
  output_path = "lambda.zip"
}

resource "aws_lambda_alias" "lambda-alias" {
  name             = "test-alias"
  description      = "Alias for API lambda"
  function_name    = aws_lambda_function.test-lambda.arn
  function_version = aws_lambda_function.test-lambda.version
}

# Zip lambda folder first
resource "aws_lambda_function" "test-lambda" {
  function_name    = "test-lambda-${var.environment}-${var.short-region}"
  role             = aws_iam_role.lambda-role.arn
  handler          = "test_lambda.lambda_handler"
  filename         = "lambda.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  layers           = [aws_lambda_layer_version.layer_version.arn]
  timeout          = 60
  runtime          = "python3.12"

  environment {
    variables = {
      DB_TABLE_NAME = aws_dynamodb_table.db-table.name
      ENVIRONMENT   = var.environment
    }
  }

  vpc_config {
    subnet_ids         = [var.subnet1, var.subnet2]
    security_group_ids = [var.sg-id]
  }
}

resource "aws_cloudwatch_log_group" "lambda-loggroup" {
  name              = "/aws/lambda/test-lambda-${var.environment}-${var.region}"
  retention_in_days = 14
}
