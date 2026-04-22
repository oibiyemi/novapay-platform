# ==========================
# DATASOURCES - Account ID
# ==========================
data "aws_caller_identity" "current" {}



# ======================================================
# DATASOURCE BLOCK - Oaccount_idC IAM Permission Policy Document
# ======================================================
data "aws_iam_policy_document" "github_web_identity_policy_doc" {
  statement {
    sid = "1"

    actions = [
      # ---------- S3 ----------
      "s3:GetObject",
      "s3:PutObject",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:PutAccountPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutLifecycleConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:PutEncryptionConfiguration",
      "s3:GetEncryptionConfiguration",
      "s3:PutBucketVersioning",
      "s3:GetBucketVersioning",
      "s3:PutBucketObjectLockConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:PutBucketLogging",
      "s3:GetBucketLogging",
      "s3:PutBucketPolicy",
      "s3:GetBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketNotification",
      "s3:GetBucketNotification",
      "s3:PutBucketTagging",
      "s3:GetBucketTagging",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:ListBucket",

      # ---------- KMS ----------
      "kms:CreateAlias",
      "kms:CreateKey",
      "kms:EnableKeyRotation",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "kms:DeleteAlias",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "kms:TagResource",
      "kms:ScheduleKeyDeletion",

      # ---------- DynamoDB ----------
      "dynamodb:CreateTable",
      "dynamodb:DeleteTable",
      "dynamodb:DescribeTable",
      "dynamodb:UpdateTable",
      "dynamodb:TagResource",
      "dynamodb:UntagResource",
      "dynamodb:ListTagsOfResource",
      "dynamodb:UpdateContinuousBackups",
      "dynamodb:DescribeContinuousBackups",
      # ---------- DynamoDB (state locking) ----------
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",


      # ---------- IAM ----------
      "iam:CreateRole",
      "iam:GetRole",
      "iam:CreateOpenIDConnectProvider",
      "iam:GetOpenIDConnectProvider",
      "iam:DeleteRole",
      "iam:DeleteOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:CreatePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeletePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:DeleteRolePermissionsBoundary",
      "iam:PutRolePolicy",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:AddRoleToInstanceProfile",
      "iam:TagRole",
      "iam:TagPolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",

      # ---------- SNS (S3 event notifications) ----------
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:ListTagsForResource",
      "sns:TagResource",
      "sns:UntagResource",
      "sns:Subscribe",
      "sns:Unsubscribe",
      "sns:ListSubscriptionsByTopic"
    ]

    resources = [
      # Application and logging buckets (objects)
      "arn:aws:s3:::${var.project_name}-${var.environment}-*/*",
      # Bucket-level operations
      "arn:aws:s3:::${var.project_name}-${var.environment}-*",
      # State bucket (explicit for bootstrap state lock)
      "arn:aws:s3:::${var.project_name}-${var.environment}-state-storage",
      "arn:aws:s3:::${var.project_name}-${var.environment}-state-storage/*",
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.project_name}-${var.environment}-*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_name}-${var.environment}-*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_name}-workload-role",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.project_name}-${var.environment}-*",
      "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:alias/${var.project_name}-${var.environment}-*",
      "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*",
      "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.project_name}-${var.environment}-*"
    ]
  }

}



