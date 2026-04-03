

# =================
# S3 MODULE
# =================
module "s3" {
  source = "../../modules/s3"

  project_name      = var.project_name
  environment       = var.environment
  region            = var.region
  enable_versioning = var.enable_versioning
  force_destroy     = var.force_destroy
}
