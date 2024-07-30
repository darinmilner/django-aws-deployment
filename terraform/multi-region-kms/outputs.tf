output "kms-main" {
  value = aws_kms_key.kms-key.id
}

output "kms-main-key-arn" {
  value = aws_kms_key.kms-key.arn
}

output "kms-alias" {
  value = aws_kms_alias.kms-alias.name
}

output "kms-replica" {
  value = aws_kms_replica_key.replica-key-useast2.arn
}

output "kms-replica-alias" {
  value = aws_kms_alias.kms-replica-alias.name
}

# output "sns-topic" {
#   value = aws_sns_topic.test-topic.arn
# }