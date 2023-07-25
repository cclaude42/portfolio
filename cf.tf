# Cloudfront definition
resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.global

  origin {
    domain_name              = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    origin_id                = aws_s3_bucket.static_site.id
  }

  aliases = var.aliases

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    cache_policy_id  = data.aws_cloudfront_cache_policy.cache_policy.id
    target_origin_id = aws_s3_bucket.static_site.id

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.valid_certificate.arn
    ssl_support_method  = "sni-only"
  }
}

# Caching policy
data "aws_cloudfront_cache_policy" "cache_policy" {
  provider = aws.global

  name = "Managed-CachingOptimized"
}

# Origin Access Control
resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  provider = aws.global

  name                              = "${var.domain_name}.oac"
  description                       = "S3 OAC for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
