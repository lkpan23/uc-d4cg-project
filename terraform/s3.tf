# KMS Key for S3 Bucket Encryption
resource "aws_kms_key" "lambda_bucket_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
}

# S3 Bucket for Lambda Code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket_access_block" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_bucket_encryption" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.lambda_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id

  versioning_configuration {
    status = "Disabled"
  }
}

# Upload Lambda Code to S3
resource "aws_s3_object" "lambda_bucket_object" {
  bucket     = aws_s3_bucket.lambda_bucket.id
  key        = "lambda_function.zip"
  source     = data.archive_file.lambda_package.output_path
  kms_key_id = aws_kms_key.lambda_bucket_key.arn
  depends_on = [aws_s3_bucket.lambda_bucket, aws_kms_key.lambda_bucket_key, aws_s3_bucket_versioning.lambda_bucket_versioning]

  force_destroy = true
}
