# ===========================
# S3 BUCKET - STATE LOCKING
#============================
resource "aws_s3_bucket" "s3_state_storage" {
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

