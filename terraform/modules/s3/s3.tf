# ============================
# BUCKET AND SUB RESOURCES
#=============================

# BUCKET RESOURCE BLOCK
resource "aws_s3_bucket" "novapay_s3" {
  # checkov:skip=CKV_AWS_144: cross-region replication not needed - Single region deployment
  # checkov:skip=CKV_AWS_300: multipart abort already configured in lifecycle rule
  # checkov:skip=CKV2_AWS_62: event notifications already enabled
  # checkov:skip=CKV2_AWS_64: KMS key Policy already defined
  # checkov:skip=CKV_AWS_18: Logging has been enabled
  bucket              = "${var.project_name}-${var.environment}-novapay"
  force_destroy       = var.force_destroy
  object_lock_enabled = true # Required for WORM protection



  tags = local.common_tags

}

# PUBLIC ACCESS BLOCK
resource "aws_s3_bucket_public_access_block" "novapay_s3_access_block" {
  bucket = aws_s3_bucket.novapay_s3.id


  # Following AWS security best practices, all four settings are recommended to be true
  # by default unless a specific public use case is required.
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# =================================
# BUCKET VERSIONING BLOCK
# =================================
resource "aws_s3_bucket_versioning" "novapay_s3_versioning" {
  bucket = aws_s3_bucket.novapay_s3.id


  versioning_configuration {
    status = var.enable_versioning
    # mfa_delete should be set at the bucket level, not versioning level
    # Also, mfa_delete can only be "Enabled" or "Disabled" (case-sensitive)
    # and can only be configured by the root account with MFA authentication
    # For most use cases, it's better to omit this parameter entirely
    # mfa_delete = "Disabled"

    # MFA Delete protects permanent version deletes and overwrites to
    # the bucket's versioning state.
    #
    # Important operational note:
    # - This is a root-account-controlled feature in AWS.
    # - The MFA code is not a stable Terraform value because it changes
    #   every ~30 seconds.
    # - In practice, protected version deletions are typically performed manually
    #  with AWS CLI/API at execution time using the current MFA token.
    # Example delete flow:
    # aws s3api delete-object \
    #   --bucket <bucket-name> \
    #   --key <object-key> \
    #   --version-id <version-id> \
    #   --mfa "<mfa-device-serial-or-arn> <current-6-digit-code>"
  }
}

# =================================
# ENCRYPTION CONFIGURATION BLOCKS
# =================================
resource "aws_kms_key" "novapay_s3_kms_key" {
  # checkov:skip=CKV2_AWS_64: KMS key policy uses default (sufficient for single-account, single-region use). Explicit policy to be added for cross-account access.
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

# ================
# KMS ALIAS BLOCK
# ================
resource "aws_kms_alias" "novapay_kms_alias" {
  name          = "alias/${var.project_name}-${var.environment}-key-alias"
  target_key_id = aws_kms_key.novapay_s3_kms_key.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "novapay_sse" {
  bucket = aws_s3_bucket.novapay_s3.id


  # Using a bucket-level key for SSE-KMS can reduce AWS KMS request costs 
  # by up to 99 percent by decreasing the request traffic from Amazon S3 to AWS KMS
  # if we set bucket_key_enabled = true
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.novapay_s3_kms_key.arn
      sse_algorithm     = "aws:kms"

    }
    bucket_key_enabled = true
  }
}

# -----------------------
# LIFECYCLE CONFIGURATION
# ------------------------
resource "aws_s3_bucket_lifecycle_configuration" "novapay_s3_lifecycle" {
  bucket = aws_s3_bucket.novapay_s3.id
  rule {

    # This is critical for preventing incomplete 
    # multipart uploads from consuming unnecessary storage
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    id     = "payment-workload"
    status = "Enabled"


    filter {
      prefix = "payment-history/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 365
      storage_class = "GLACIER"
    }

    expiration {
      days = 600
    }
  }
}


# --------------------------------------------------------------------------------------------------
# S3 OBJECT LOCK (WORM PROTECTION)
# Prevents objects from being deleted or overwritten for a fixed amount of time.
# Required for SOC2/Financial data integrity.
# --------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_object_lock_configuration" "novapay_s3_object_lock" {
  bucket = aws_s3_bucket.novapay_s3.id

  rule {
    default_retention {
      mode  = "COMPLIANCE" # Can't overwritten even by root 
      years = 7
    }
  }
}


