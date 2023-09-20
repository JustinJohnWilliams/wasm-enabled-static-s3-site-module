resource "aws_cloudfront_distribution" "s3_distribution" {

  is_ipv6_enabled = true

  origin {
    domain_name = var.website_endpoint
    origin_id   = var.website_endpoint
  }

  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.website_endpoint

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    lambda_function_association {
      event_type   = "origin-response"
      include_body = false
      lambda_arn   = var.lambda_arn
    }
  }

  tags = var.tags
}

data "aws_cloudfront_cache_policy" "example" {
  name = "Managed-CachingOptimized"
}
