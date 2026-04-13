# =======================
# LOGGING - OUTPUT BLOCKS
# =======================

# BUCKET NAME
output "logging_bucket_name" {
  value = aws_s3_bucket.s3_logging.bucket
}


# BUCKET ARN
output "logging_bucket_arn" {
  value = aws_s3_bucket.s3_logging.arn
}
