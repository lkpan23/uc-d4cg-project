# Assume Role Policy for Lambda
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Permissions Policy for Lambda
data "aws_iam_policy_document" "lambda_permissions_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.lambda_bucket.arn,
      "${aws_s3_bucket.lambda_bucket.arn}/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.lambda_bucket_key.arn]
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "${var.iam_role_name}-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# Attach Permissions Policy to the Role
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${var.iam_policy_name}-${terraform.workspace}"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_permissions_policy.json
}

# Lambda Function
resource "aws_lambda_function" "cron_lambda_function" {
  function_name                  = "${var.lambda_function_name}-${terraform.workspace}"
  s3_bucket                      = aws_s3_bucket.lambda_bucket.id
  s3_key                         = aws_s3_object.lambda_bucket_object.key
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "lambda_function.lambda_handler"
  runtime                        = "python3.12"
  timeout                        = 60
  memory_size                    = 128
  reserved_concurrent_executions = -1
  s3_object_version              = aws_s3_object.lambda_bucket_object.version_id

  depends_on = [aws_s3_object.lambda_bucket_object]
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/src/lambda-cron"
  output_path = "${path.module}/lambda_function_package.zip"
}

# CloudWatch Event Rule (Cron Job)
resource "aws_cloudwatch_event_rule" "cw_event_rule" {
  name                = var.cw_event_rule_name
  description         = "Fires every five minutes"
  schedule_expression = "rate(5 minutes)"
  state               = "ENABLED"
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.cw_event_rule.name
  target_id = "CronTriggerLambda"
  arn       = aws_lambda_function.cron_lambda_function.arn
}

# Lambda Permission for CloudWatch
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cron_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cw_event_rule.arn
}
