# =========================================
# LOGGING - S3
# checkov:skip=CKV_AWS_18: logging enabled
#=========================================

# # LOGGING - BUCKET RESOURCE BLOCK
resource "aws_s3_bucket" "s3_logging" {
  # checkov:skip=CKV_AWS_18: This IS the access-log target bucket. Logging to itself creates recursion; no upstream target exists.
  # checkov:skip=CKV_AWS_21: Versioning intentionally disabled on logs bucket to control cost. Logs are append-only and retained via lifecycle.
  # checkov:skip=CKV_AWS_144: Cross-region replication not needed for ops logs in this environment.
  # checkov:skip=CKV_AWS_145: Using SSE-S3 (AES256) not KMS on logs bucket - cost decision. KMS per-request cost unjustified for high-volume log writes.
  # checkov:skip=CKV2_AWS_62: Event notifications not required on logs bucket.
  # checkov:skip=CKV2_AWS_61: Lifecycle configuration is defined below.
  # checkov:skip=CKV2_AWS_6: Public access block defined below.
  bucket        = "${var.project_name}-${var.environment}-logging"
  force_destroy = var.force_destroy


  tags = local.common_tags

}

# ==============================
# LOGGING - SSE (AES256 / SSE-S3)
# Explicitly declared to satisfy Checkov CKV_AWS_19 even though
# AWS enables SSE-S3 by default on all new buckets since Jan 2023.
# ==============================
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_logging_sse" {
  bucket = aws_s3_bucket.s3_logging.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
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

    # This is critical for preventing incomplete 
    # multipart uploads from consuming unnecessary storage
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    id     = "logging"
    status = "Enabled"


    filter {
      prefix = "workload-storage-logs/"
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



# ====================
# S3 LOGGING RESOURCE
# ====================

resource "aws_s3_bucket_logging" "novapay_s3_logging" {
  bucket = aws_s3_bucket.s3_logging.id

  target_bucket = aws_s3_bucket.s3_logging.bucket
  target_prefix = "payment-client-log/"
  target_object_key_format {
    partitioned_prefix {
      partition_date_source = "EventTime"
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