output "user-pool-name" {
  value = aws_cognito_user_pool.user-pool.name
}

output "user-pool-arn" {
  value = aws_cognito_user_pool.user-pool.arn
}

output "saml-provider-id" {
  value = aws_cognito_identity_provider.saml-provider.id
}