

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