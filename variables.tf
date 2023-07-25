# Site definition
variable "domain_name" {
  type        = string
  description = "Your domain name"
}

variable "aliases" {
  type        = list(any)
  description = "Aliases for your domain name (format: [\"www.mysite.com\", \"*.mysite.com\"])"
}


# Default config
variable "region" {
  type        = string
  description = "The region to create local resources in"
  default     = "eu-west-1"
}

variable "file_directory" {
  type        = string
  description = "The directory containing the website's static files"
  default     = "root"
}

variable "random_bucket_name" {
  type        = bool
  description = <<EOT
  Changes the name of the S3 bucket containing your static files
    If disabled : [mysite.com]
    If enabled  : [mysite.com-7edf32]
  Use if a bucket with your domain name already exists
  EOT
  default     = false
}


# Credentials
variable "shared_credentials_file" {
  type        = string
  description = "The path to the file where the AWS credentials are stored"
  default     = "~/.aws/credentials"
}

variable "terraform_aws_profile" {
  type        = string
  description = "The name of the AWS profile used to create the infrastructure"
  default     = "tf-static-site"
}
