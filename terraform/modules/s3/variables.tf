variable "project_name" {
  type = string
  description = "NovaPay project name used across all resource naming."
 

  validation {
    condition = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "project_name must be lowercase, alphanumeric or hyphens, 3–20 characters."
  }
}


variable "environment" {
  type = string
  description = "Deployment environment for NovaPay resources."
 

  validation {
    condition     = anytrue([for e in ["dev","staging","uat","prod"]: e == var.environment])
    error_message = "Environment must be one of: dev, staging, prod, uat."
  }
}

variable "region" {
  type = string
  description = "Region."
 

  validation {
    condition     = contains(["ca-central-1", "ca-west-1"], var.region)
                    
    error_message = "Region must be a supported NovaPay AWS region: ca-central-1 or ca-west-1."
  }
}


variable "enable_versioning" {
  description = "Enable S3 versioning. Must be 'Enabled' or 'Disabled'. Always Enabled in prod."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.enable_versioning)
    error_message = "enable_versioning must be 'Enabled' or 'Disabled'."
  }
  # Versioning costs money. Dev doesn't need it. Prod must have it.
}

variable "force_destroy" {
  description = "Can we delete this bucket even if it has files?"
  type        = bool
  default     = false
  # NEVER true in prod. Fine in dev so we can clean up easily.
}