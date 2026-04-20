data "aws_iam_policy_document" "sns_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.topic.arn]


    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.novapay_s3.arn]
    }
  }
}


# ============
#  SNS TOPIC
# =============
resource "aws_sns_topic" "topic" {
  name = "${var.project_name}-${var.environment}-s3-topic"
  # Policy is attached separately via aws_sns_topic_policy to keep
  # the topic definition and its access policy loosely coupled.
}


# =======================
#  SNS POLICY
# =======================
resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.topic.arn

  policy = data.aws_iam_policy_document.sns_policy_doc.json
}

# =======================
#  S3 BUCKET NOTIFICATION
# =======================
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.novapay_s3.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "payment-history/"
    filter_suffix = ".csv"
  }
}