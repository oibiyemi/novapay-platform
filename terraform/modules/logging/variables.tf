variable "project_name" {
  type        = string
  description = "NovaPay project name used across all resource naming."


  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "project_name must be lowercase, alphanumeric or hyphens, 3–20 characters."
  }
}


variable "environment" {
  type        = string
  description = "Deployment environment for NovaPay resources."


  validation {
    condition     = anytrue([for e in ["dev", "staging", "uat", "prod"] : e == var.environment])
    error_message = "Environment must be one of: dev, staging, prod, uat."
  }
}

variable "region" {
  type        = string
  description = "Region."


  validation {
    condition = contains(["ca-central-1", "ca-west-1"], var.region)

    error_message = "Region must be a supported NovaPay AWS region: ca-central-1 or ca-west-1."
  }
}




variable "force_destroy" {
  description = "Can we delete this bucket even if it has files?"
  type        = bool
  default     = false
  # NEVER true in prod. Fine in dev so we can clean up easily.
}

# ==========================================================
# APP S3 - INPUT BLOCKS (Ingesting from Root module)
# ==========================================================

variable "app_bucket" {
  description = "Name of the application S3 bucket to enable logging for."
  type        = string
}

variable "app_bucket_arn" {
  description = "ARN of the application S3 bucket to enable logging for."
  type        = string
}
