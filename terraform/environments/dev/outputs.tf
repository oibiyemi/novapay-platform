# =====================
# OUTPUTS
# =====================
output "s3_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the application S3 bucket"
  value       = module.s3.bucket_arn
}

output "s3_bucket_domain_name" {
  description = "Domain name of the application S3 bucket"
  value       = module.s3.bucket_name
}