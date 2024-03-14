locals {
  short_region   = replace(var.aws_region, "-", "")
  api_id         = aws_api_gateway_rest_api.test-api.id
  resource_id    = aws_api_gateway_resource.root-endpoint.id
  http_post_type = "POST"
  ok_response    = "200"
}