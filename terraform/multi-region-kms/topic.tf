resource "aws_sns_topic" "test-topic" {
  provider = aws.useast2
  name     = "test-topic-${local.short_region_useast2}"
  kms_master_key_id = aws_kms_replica_key.replica-key-useast2.arn
 // kms_master_key_id = aws_kms_key.kms-key.arn   # both options run successfully
}
