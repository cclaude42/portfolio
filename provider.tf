provider "aws" {
  alias                    = "local"
  shared_credentials_files = ["${var.shared_credentials_file}"]
  profile                  = var.terraform_aws_profile
  region                   = var.region
}

provider "aws" {
  alias                    = "global"
  shared_credentials_files = ["${var.shared_credentials_file}"]
  profile                  = var.terraform_aws_profile
  region                   = "us-east-1"
}
