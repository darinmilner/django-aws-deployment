resource "aws_lambda_permission" "invoke-lambda" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda-name
  source_arn    = aws_lb_target_group.lb-tg.arn
  qualifier     = var.lambda-alias-name
  principal     = "elasticloadbalancing.amazonaws.com"
}
