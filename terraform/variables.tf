variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"

}

variable "iam_role_name" {
  description = "The name of the IAM role to create for the Lambda function"
  type        = string
  default     = "lambda_execution_role"
}

variable "cw_event_rule_name" {
  description = "The name of the CloudWatch Event Rule"
  type        = string
  default     = "lambda_cron_event_rule"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "cron_lambda_function"
}

variable "iam_policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "lambda_permissions_policy"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
  default     = "lambda-code-bucket"
}

variable "s3_bucket_versioning_status" {
  description = "The versioning status of the S3 bucket"
  type        = string
  default     = "Enabled"
}

variable "kms_key_deletion_window_in_days" {
  description = "The number of days before the KMS key is deleted."
  type        = number
  default     = 7
}

variable "bucket_object_lock_configuration_days" {
  description = "The number of days to retain the object in the bucket."
  type        = number
  default     = 5
}
