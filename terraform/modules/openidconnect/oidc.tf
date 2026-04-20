
# ====================================
# DATASOURCE BLOCK - data source goes to the URL, 
# downloads its public SSL certificate
# =====================================
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}


# =======================
# OPENIDCONNECT RESOURCE
# ======================
resource "aws_iam_openid_connect_provider" "github_actions_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
  # .sha1_fingerprint - The unique ID number on that card that AWS uses to recognize the provider
}