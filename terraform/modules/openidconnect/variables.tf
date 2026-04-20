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

}

variable "repo_name" {
  type        = string
  description = "Repository name."
}


variable "github_username" {
  type        = string
  description = "Github User."
}