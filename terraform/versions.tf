terraform {
  required_version = ">= 1.9"
  backend "s3" {
    # bucket = "uc-d4cg-terraform-state-s3-backend"
    # key    = "lambda-cron/terraform.tfstate"
    # region = var.aws_region
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
