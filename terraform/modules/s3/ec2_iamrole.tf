# ============================
# IAM ROLE - WORKLOAD (EC2)
# Trust:      ec2.amazonaws.com can assume this role
# Permission: least-privilege access to S3 + KMS only
# ============================

# TRUST POLICY — who can assume this role
resource "aws_iam_role" "novapay_workload_s3_role" {
  name = "${var.project_name}-workload-role"

  assume_role_policy = templatefile("${path.module}/templates/trust-policy.json", {
    service = "ec2.amazonaws.com"
    action  = "sts:AssumeRole"
  })

  tags = local.common_tags
}

# PERMISSION POLICY — what this role can do
# Scoped to the specific bucket and KMS key (least privilege)
resource "aws_iam_role_policy" "novapay_workload_s3_policy" {
  name = "${var.project_name}-workload-s3-policy"
  role = aws_iam_role.novapay_workload_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ReadWrite"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.novapay_s3.arn}/*"
      },
      {
        # S3 calls KMS on behalf of the workload — but the workload's
        # identity must also have these KMS permissions or the call is denied.
        Sid    = "KMSForS3Encryption"
        Effect = "Allow"
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ]
        Resource = aws_kms_key.novapay_s3_kms_key.arn
      }
    ]
  })
}
