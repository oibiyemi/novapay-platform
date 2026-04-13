# ================================
# APPLICATION S3 - OUTPUT BLOCKS 
# ================================

# BUCKET NAME
output "bucket_name" {
  value = aws_s3_bucket.novapay_s3.bucket
}


# BUCKET ARN
output "bucket_arn" {
  value = aws_s3_bucket.novapay_s3.arn
}
