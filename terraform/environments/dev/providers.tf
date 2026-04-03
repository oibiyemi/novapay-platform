
# =================
# PROVIDER BLOCK
# =================
terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}


cd D:/minikube_data/intact-prep/novapay-platform && git add terraform/environments/dev/main.tf terraform/environments/dev/providers.tf && git commit -m "$(cat <<'EOF'
refactor: split provider config into separate providers.tf

Separated terraform/provider blocks from main.tf into providers.tf
for cleaner separation of concerns. Main.tf now only contains
module declarations.

EOF
)" && git status