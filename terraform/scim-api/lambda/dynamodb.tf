
resource "aws_dynamodb_table" "db-table" {
  hash_key       = "id"
  name           = "ScimAPITable"
  billing_mode   = "PROVISIONED"
  read_capacity  = "30"
  write_capacity = "30"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "scim-api-table-${var.environment}-${var.short-region}"
  }
}