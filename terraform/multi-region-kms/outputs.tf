output "kms-main" {
  value = aws_kms_key.kms-key.id
}

output "kms-replica" {
  value = aws_kms_replica_key.replica-key-useast2.arn
}

output "sns-topic" {
  value = aws_sns_topic.test-topic.arn
}