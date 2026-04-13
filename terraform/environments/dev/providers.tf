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

  # =============
  # BACKEND BLOCK
  # =============
  backend "s3" {
    bucket         = "novapay-dev-state-storage"
    key            = "environments/dev/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true                # Highly recommended for security
    dynamodb_table = "dev-novapay-table" # Legacy locking (pre-1.10)
  }
}

provider "aws" {
  region = var.region
}