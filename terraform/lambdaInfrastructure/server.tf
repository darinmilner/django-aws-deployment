resource "aws_launch_template" "app-template" {
  name_prefix   = "app-template-${var.environment}-${local.short_region}"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "app-asg" {
  availability_zones = ["${var.zone1}"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.app-template.id
    version = "$Latest"
  }
}

resource "aws_dynamodb_table" "db-table" {
  hash_key     = "resourceName"
  name         = "inventoryTable"
  billing_mode = "PROVISIONED"
  #   stream_enabled   = true
  #   stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity  = "30"
  write_capacity = "30"

  attribute {
    name = "resourceName"
    type = "S"
  }
}
