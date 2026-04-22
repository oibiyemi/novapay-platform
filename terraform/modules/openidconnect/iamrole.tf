

# ==============================================================
# IAM ROLE + Trust Policy - Github Actions Web identity 
# Allows users federated by the specified external web identity
# =============================================================
resource "aws_iam_role" "github_web_identity_role" {
  name = "${var.project_name}-${var.environment}-github-actions-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
            "sts.amazonaws.com"]
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : [
            "repo:${var.github_username}/${var.repo_name}:ref:refs/heads/main"]
          }
        }
      }
    ]
  })

  tags = local.common_tags
}



# ==================
# PERMISSION POLICY
# ==================
resource "aws_iam_policy" "github_web_identity_policy" {
  # checkov:skip=CKV_AWS_355: Wildcard resources required - GitHub Actions must manage any resource matching project naming convention (${project}-${env}-*). Scoping by naming prefix is the least-privilege pattern for a CI deploy role.
  # checkov:skip=CKV_AWS_289: Admin-like permissions required for Terraform CI role - create/destroy S3, KMS, IAM, DynamoDB, SNS. Scoped by naming prefix, trust policy locked to single repo + branch.
  # checkov:skip=CKV_AWS_290: IAM write permissions required for Terraform CI - creates and manages IAM roles for the workload. Bounded by resource ARN pattern.
  # checkov:skip=CKV_AWS_107: iam:Create* actions required for bootstrapping IAM resources via Terraform.
  # checkov:skip=CKV_AWS_108: Permissions scoped to specific resource ARN patterns, not "*".
  # checkov:skip=CKV_AWS_109: Resource modification actions required for Terraform lifecycle.
  # checkov:skip=CKV_AWS_110: Privilege escalation risk acknowledged - mitigated by OIDC trust policy (repo + branch + audience restrictions).
  # checkov:skip=CKV_AWS_111: Write-without-constraints required for Terraform CI; constrained by resource ARN naming prefix.
  name   = "${var.project_name}-${var.environment}-github-identity-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.github_web_identity_policy_doc.json
}


# ============================
# POLICY ATTACHMENT  BLOCK -
# ===========================
resource "aws_iam_policy_attachment" "github_web_identity_policy_attach" {
  name       = "${var.project_name}-${var.environment}-policy-attach"
  roles      = [aws_iam_role.github_web_identity_role.name]
  policy_arn = aws_iam_policy.github_web_identity_policy.arn
}