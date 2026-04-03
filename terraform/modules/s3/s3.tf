# ============================
# BUCKET AND SUB RESOURCES
#=============================

# BUCKET RESOURCE BLOCK
resource "aws_s3_bucket" "novapay_s3" {
  bucket = "${var.project_name}-${var.environment}-novapay"
  force_destroy = var.force_destroy
  region = var.region

  tags = local.common_tags

}

# PUBLIC ACCESS BLOCK
resource "aws_s3_bucket_public_access_block" "novapay_s3_access_block" {
  bucket = aws_s3_bucket.novapay_s3.id
  region = var.region

  # Following AWS security best practices, all four settings are recommended to be true
  # by default unless a specific public use case is required.
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# BUCKET VERSIONING BLOCK
resource "aws_s3_bucket_versioning" "novapay_s3_versioning" {
  bucket = aws_s3_bucket.novapay_s3.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Enabled"

    # MFA Delete protects permanent version deletes and changes to
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
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 10
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

# aws_s3_bucket_versioning
# aws_s3_bucket_public_access_block
# aws_s3_bucket_lifecycle_configuration
# aws_s3_bucket_logging
# aws_s3_bucket_policy
# aws_s3_bucket_server_side_encryption_configuration
# bucket_prefix