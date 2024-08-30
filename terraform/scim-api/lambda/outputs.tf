output "lambda-arn" {
  value = aws_lambda_function.test-lambda.arn
}

output "lambda-name" {
  value = aws_lambda_function.test-lambda.function_name
}

output "lambda-alias-arn" {
  value = aws_lambda_alias.lambda-alias.arn
}

output "lambda-alias-name" {
  value = aws_lambda_alias.lambda-alias.name
}

output "exec-lambda-role" {
  value = aws_iam_role.lambda-role.arn
}
