# Outputs bucket name for remote reference
output "bucket_name" {
  value = aws_s3_bucket.s3_state_storage.bucket
}

# Outputs Dynamodb Table name for remote reference
output "table_name" {
  value = aws_dynamodb_table.state_dynamodb_table.name
}