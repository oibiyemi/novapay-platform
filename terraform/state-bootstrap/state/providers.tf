# ===================================
# PROVIDER BLOCK WITH STATE BOOTSTRAP
# ===================================
terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket  = "novapay-dev-state-storage"
    key     = "state-bootstrap/state/terraform.tfstate"
    region  = "ca-central-1"
    encrypt = true
    dynamodb_table = "novapay-dev-table"
  }
}

provider "aws" {
  region = "ca-central-1"
}