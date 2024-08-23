output "rest-api-arn" {
  value = aws_api_gateway_rest_api.test-api.execution_arn
}

output "rest-api-id" {
  value = aws_api_gateway_rest_api.test-api.id
}