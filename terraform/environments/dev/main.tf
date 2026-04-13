

# =====================
# S3 MODULE
# =====================
module "s3" {
  source = "../../modules/s3"

  project_name      = var.project_name
  environment       = var.environment
  region            = var.region
  enable_versioning = var.enable_versioning
  force_destroy     = var.force_destroy
}

# =====================
# S3 LOGGING MODULE
# =====================
module "s3_logging" {
  source = "../../modules/logging"

  project_name  = var.project_name
  environment   = var.environment
  region        = var.region
  force_destroy = var.force_destroy

  # Application bucket references (from s3 module outputs)
  app_bucket    = module.s3.bucket_name
  app_bucket_arn = module.s3.bucket_arn
}

