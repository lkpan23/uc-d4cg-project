terraform {
  required_version = ">= 1.9"
  backend "s3" {
    # bucket = "uc-d4cg-project-terraform-state-s3-bucket"
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
