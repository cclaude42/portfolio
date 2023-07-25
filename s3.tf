# Bucket definition
resource "aws_s3_bucket" "static_site" {
  provider = aws.local

  bucket = var.random_bucket_name ? "${var.domain_name}-${random_id.bucket_name.hex}" : var.domain_name
}

resource "random_id" "bucket_name" {
  byte_length = 3
}

# Static website hosting
resource "aws_s3_bucket_website_configuration" "static_site" {
  provider = aws.local

  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Add cloudfront permissions
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  provider = aws.local

  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  provider = aws.local

  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.static_site.arn}/*"
    ]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.s3_distribution.arn}"]
    }
  }
}

# Upload static files
resource "aws_s3_object" "static_files" {
  provider = aws.local

  for_each = fileset("${path.module}/${var.file_directory}", "**/*.html")

  bucket = aws_s3_bucket.static_site.id

  key          = each.value
  source       = "${var.file_directory}/${each.value}"
  etag         = filemd5("${var.file_directory}/${each.value}")
  content_type = "text/html"
}
