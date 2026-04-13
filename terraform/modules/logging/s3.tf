# ============================
# LOGGING - S3
#=============================

# # LOGGING - BUCKET RESOURCE BLOCK
resource "aws_s3_bucket" "s3_logging" {
  bucket        = "${var.project_name}-${var.environment}-logging"
  force_destroy = var.force_destroy


  tags = local.common_tags

}

# # LOGGING  - PUBLIC ACCESS BLOCK
resource "aws_s3_bucket_public_access_block" "s3_logging_access_block" {
  bucket = aws_s3_bucket.s3_logging.id


  # Following AWS security best practices, all four settings are recommended to be true
  # by default unless a specific public use case is required.
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# ----------------------------------
#  LOGGING - LIFECYCLE CONFIGURATION
# ----------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "s3_logging_lifecycle" {
  bucket = aws_s3_bucket.s3_logging.id
  rule {
    id     = "logging"
    status = "Enabled"


    filter {
      prefix = "payment-history-logs/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 100
      storage_class = "GLACIER"
    }

    expiration {
      days = 300
    }
  }
}



# -------------------------
# LOGGING - BUCKET POLICY
# -------------------------

resource "aws_s3_bucket_policy" "s3_logging_policy" {
  bucket = aws_s3_bucket.s3_logging.id

  policy = data.aws_iam_policy_document.allow_log_write.json
}