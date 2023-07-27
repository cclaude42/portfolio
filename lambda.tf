# Define lambda
resource "aws_lambda_function" "index_resolver" {
  provider = aws.global

  filename         = data.archive_file.index_resolver_zip_inline.output_path
  source_code_hash = data.archive_file.index_resolver_zip_inline.output_base64sha256
  publish          = true

  function_name = "cloudfront-index-resolver"
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  role = aws_iam_role.index_resolver_role.arn
}

data "archive_file" "index_resolver_zip_inline" {
  type        = "zip"
  output_path = "/tmp/index_resolver_zip_inline.zip"
  source {
    content  = <<EOF
export const handler = async(event) => {
    
    // Extract the request from the CloudFront event that is sent to Lambda@Edge 
    var request = event.Records[0].cf.request;

    // Extract the URI from the request
    var olduri = request.uri;

    // Match any '/' that occurs at the end of a URI. Replace it with a default index
    var newuri = olduri.replace(/\/$/, '\/index.html');
    
    // Log the URI as received by CloudFront and the new URI to be used to fetch from origin
    console.log("Old URI: " + olduri);
    console.log("New URI: " + newuri);
    
    // Replace the received URI with the URI that includes the index page
    request.uri = newuri;
    
    // Return to CloudFront
    return request;
};
EOF
    filename = "index.mjs"
  }
}

# Attach role to Lambda
resource "aws_iam_role" "index_resolver_role" {
  provider = aws.global

  name               = "index_resolver_role"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
}

resource "aws_iam_role_policy_attachment" "index_resolver_policy" {
  provider = aws.global

  role       = aws_iam_role.index_resolver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  provider = aws.global

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}
