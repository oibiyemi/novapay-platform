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

module "s3" {
  source = "../../modules/s3"

  project_name      = var.project_name
  environment       = var.environment
  region            = var.region
  enable_versioning = var.enable_versioning
  force_destroy     = var.force_destroy
}
