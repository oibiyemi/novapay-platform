resource "aws_dynamodb_table" "state_dynamodb_table" {
  name                        = "${var.environment}-${var.project_name}-table"
  billing_mode                = var.billing_mode
  hash_key                    = var.lock_id
  deletion_protection_enabled = true

  attribute {
    name = var.lock_id
    type = var.attribute_type
  }

  tags = local.common_tags
}