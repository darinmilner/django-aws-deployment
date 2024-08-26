
resource "aws_iam_role" "lambda-role" {
  name = "Scim-Lambda-Role-${local.environment}-${local.short-region}"

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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "api-lambda-policy" {
  name = "api-lambda-db-policy"
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
  name              = "/aws/lambda/scim-lambda-${local.environment}-${var.region}"
  retention_in_days = 14
}

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
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-logging-policy.arn
}