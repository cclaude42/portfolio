# Output Cloudfront URL
output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  description = "The URL of your Cloudfront distribution ; try to curl or visit it !"
}
