resource "aws_lambda_layer_version" "layer_version" {
  filename            = "${path.module}/code/python.zip"
  layer_name          = "test-lambda-layer"
  compatible_runtimes = ["python3.12"]
}

# Generates an archive from content, a file, or directory of files.
data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/code/build/"
  output_path = "${path.module}/code/python.zip"
}
