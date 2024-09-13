resource "aws_lambda_function" "check-age-lambda" {
  filename         = data.archive_file.check-age.output_path
  source_code_hash = data.archive_file.check-age.output_base64sha256
  function_name    = "poc-check-age-${local.environment}-${local.short-region}-lambda"
  role             = aws_iam_role.lambda-role.arn
  handler          = "check_age.lambda_handler"
  runtime          = "python3.12"
}

resource "aws_lambda_function" "create-bucket-lambda" {
  filename         = data.archive_file.create-bucket.output_path
  source_code_hash = data.archive_file.create-bucket.output_base64sha256
  function_name    = "poc-create-bucket-${local.environment}-${local.short-region}-lambda"
  role             = aws_iam_role.lambda-role.arn
  handler          = "create_bucket.lambda_handler"
  runtime          = "python3.12"
}

resource "aws_lambda_function" "upload-lambda" {
  filename         = data.archive_file.upload.output_path
  source_code_hash = data.archive_file.upload.output_base64sha256
  function_name    = "poc-upload-${local.environment}-${local.short-region}-lambda"
  role             = aws_iam_role.lambda-role.arn
  handler          = "upload.lambda_handler"
  runtime          = "python3.12"
}