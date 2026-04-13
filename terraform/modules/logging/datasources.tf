
# ====================================
# DATASOURCE BLOCK - Takes Policy Documents
# =====================================
data "aws_iam_policy_document" "allow_log_write" {
   statement {
    sid = "AllowLogWrite"
    principals {
      type = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]

    # The logging service writes TO the logging bucket (Resource)
    resources = [
      "${aws_s3_bucket.s3_logging.arn}/payment-client/*",
    ]

    # BUT only when the logs came FROM the app bucket (Condition)
    condition {
    test     = "ArnLike"
    variable = "aws:SourceArn"
    values   = [var.app_bucket_arn]   # Pulled from input variable ingested from the root ../dev/main.tf
    }
  }
}