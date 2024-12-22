aws_region           = "us-east-1"
iam_role_name        = "lambda_execution_role"
cw_event_rule_name   = "lambda_cron_event_rule"
lambda_function_name = "cron_lambda_function"
iam_policy_name      = "lambda_permissions_policy"
s3_bucket_name       = "project-cron-lambda-s3-bucket"
# cron-lambda-terraform-state-s3-bucket - Manually create this bucket for storing the Terraform state files
