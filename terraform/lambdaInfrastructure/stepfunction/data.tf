data "archive_file" "check-age" {
  type        = "zip"
  source_dir  = "./lambdas/check_age/"
  output_path = "./lambdas/check_age.zip"
}

data "archive_file" "create-bucket" {
  type        = "zip"
  source_dir  = "./lambdas/create_bucket/"
  output_path = "../lambdas/create_bucket.zip"
}

data "archive_file" "upload" {
  type        = "zip"
  source_dir  = "./lambdas/upload/"
  output_path = "./lambdas/upload.zip"
}