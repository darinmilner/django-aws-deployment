resource "aws_iam_role" "alb-role" {
  name = "test-lambda-alb-role-${var.environment}-${var.short-region}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "elasticloadbalancing.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "alb-lambda-policy" {
  name = "api-lambda-alb-policy"
  role = aws_iam_role.alb-role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["lambda:*"],
        "Resource" : var.lambda-arn
      }
    ]
  })
}

resource "aws_lambda_permission" "invoke-lambda" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda-name
  source_arn    = aws_lb_target_group.lb-tg.arn
  qualifier     = var.lambda-alias-name
  principal     = "elasticloadbalancing.amazonaws.com"
}
