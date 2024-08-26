# resource "aws_cloudfront_origin_access_identity" "origin-access-identity" {
#   comment = "access-identity-${aws_s3_bucket.upload-bucket.bucket}.s3.amazonaws.com"
# }

# resource "aws_cloudfront_distribution" "static-distribution" {
#   origin {
#     domain_name = aws_s3_bucket.upload-bucket.bucket_regional_domain_name
#     origin_id   = aws_s3_bucket.upload-bucket.bucket
#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.origin-access-identity.cloudfront_access_identity_path
#     }
#   }

#   enabled         = true
#   is_ipv6_enabled = true
#   comment         = "Cloudfront Distribution"

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     compress         = false
#     target_origin_id = "S3-${aws_s3_bucket.upload-bucket.bucket}"

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 0
#     max_ttl                = 0
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
