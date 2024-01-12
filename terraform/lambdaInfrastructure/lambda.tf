
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.py"
  output_path = "lambda.zip"
}

# Zip lambda folder first
resource "aws_lambda_function" "inventory-lambda" {
  function_name = "inventory-lambda-${var.environment}-${local.short_region}"
  role          = aws_iam_role.lambda-role.arn
  handler       = "index.lambda_handler"
  filename      = "lambda.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.10"

  environment {
    variables = {
      DB_TABLE_NAME = aws_dynamodb_table.db-table.name
      ENVIRONMENT = var.environment
    }
  }
}

resource "aws_iam_role" "lambda-role" {
  name = "Inventory-Lambda-Role-${var.environment}-${local.short_region}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/servicerole/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name = "dynamodb-lambda-policy"
  role = aws_iam_role.lambda-role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : "${aws_dynamodb_table.db-table.arn}"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda-loggroup" {
  name              = "/aws/lambda/inventory-lambda-${var.environment}-${var.region}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda-logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda-logging-policy" {
  name        = "lambda-logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda-logging.json
}

resource "aws_iam_role_policy_attachment" "lambda-logs" {
  role       = aws_iam_role.lambda-role.arn
  policy_arn = aws_iam_policy.lambda-logging-policy.arn
}