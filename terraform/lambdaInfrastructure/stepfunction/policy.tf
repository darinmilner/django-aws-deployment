resource "aws_iam_role" "lambda-role" {
  name               = "step-function-lambda-role-${local.environment}-${local.short-region}"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
    EOF
}

resource "aws_iam_role" "step-functions-role" {
  name = "step-functions-role-${local.environment}-${local.short-region}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "lambda-access-policy" {
  statement {
    actions = [
      "lambda:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "step-functions-policy-lambda" {
  name   = "step-functions-lambda-policy-${local.environment}-${local.short-region}"
  policy = data.aws_iam_policy_document.lambda-access-policy.json
}

resource "aws_iam_role_policy_attachment" "step-function-to-lambdas" {
  role       = aws_iam_role.step-functions-role.name
  policy_arn = aws_iam_policy.step-functions-policy-lambda.arn
}
