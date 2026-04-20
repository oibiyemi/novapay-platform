locals {
  common_tags = {
    name      = var.project_name
    env       = var.environment
    managedby = "Terraform"
    project   = "${var.project_name}-project"
  }
}