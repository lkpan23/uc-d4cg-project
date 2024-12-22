terraform {
  required_version = ">= 1.9"
  backend "s3" {
    # bucket = "cron-lambda-terraform-state-s3-bucket"
    # key    = "lambda-cron/terraform.tfstate"
    # region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
