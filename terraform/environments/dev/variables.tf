variable "project_name" {
  type    = string
  default = "novapay"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "ca-central-1"
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = string
  default     = "Enabled"
}

variable "force_destroy" {
  type    = bool
  default = true
}
