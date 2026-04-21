resource "aws_dynamodb_table" "state_dynamodb_table" {
  # checkov:skip=CKV_AWS_119: AWS-owned key acceptable for state-lock metadata (no PII/PCI). Revisit for prod.
  name                        = "${var.project_name}-${var.environment}-table"
  billing_mode                = var.billing_mode
  hash_key                    = var.lock_id
  deletion_protection_enabled = false

  # Point-in-time Recovery Backup
  # Protect your DynamoDB tables from accidental write or delete operations
  point_in_time_recovery {
    enabled = true
  }


  # Customer Managed Key (CMK) for encryption, 
  # provides an added layer of security, 
  # rather than the default AWS-owned keys
  attribute {
    name = var.lock_id
    type = var.attribute_type
  }

  tags = local.common_tags
}