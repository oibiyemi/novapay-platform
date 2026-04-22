# ===========================
# S3 BUCKET - STATE LOCKING
#============================
resource "aws_s3_bucket" "s3_state_storage" {
  # checkov:skip=CKV2_AWS_61: Lifecycle intentionally not configured - Terraform state must be retained indefinitely for disaster recovery.
  # checkov:skip=CKV_AWS_18: Access logging not configured on state bucket - bootstrap context, no logging target exists yet.
  # checkov:skip=CKV_AWS_144: Cross-region replication not needed for dev state; revisit for prod.
  # checkov:skip=CKV_AWS_145: Using SSE-S3 on state bucket - state contains no PII/PCI data; KMS overhead unjustified.
  # checkov:skip=CKV2_AWS_62: Event notifications not needed on state bucket.
  # checkov:skip=CKV_AWS_300: Multipart abort skipped - state files are small single-part uploads.
  bucket        = "${var.project_name}-${var.environment}-state-storage"
  force_destroy = var.force_destroy


  tags = local.common_tags

}


# ====================
# PUBLIC ACCESS BLOCK
# ====================
resource "aws_s3_bucket_public_access_block" "state_storage_access_block" {
  bucket = aws_s3_bucket.s3_state_storage.id

  # Following AWS security best practices, all four settings are recommended to be true
  # by default unless a specific public use case is required.
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ========================
# BUCKET VERSIONING BLOCK
# ========================
resource "aws_s3_bucket_versioning" "state_storage_versioning" {
  bucket = aws_s3_bucket.s3_state_storage.id

  versioning_configuration {
    status = var.enable_versioning
  }
}

# ==============================
# SERVER-SIDE ENCRYPTION BLOCK
# ==============================
resource "aws_s3_bucket_server_side_encryption_configuration" "state_storage_sse" {
  bucket = aws_s3_bucket.s3_state_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"

    }
  }
}

