# Config for init
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8.0"
    }
  }

  backend "s3" {
    key     = "state/terraform.tfstate"
    encrypt = true
  }
}
