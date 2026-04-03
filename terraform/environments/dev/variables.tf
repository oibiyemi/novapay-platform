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
  type    = string
  default = "Disabled"
}

variable "force_destroy" {
  type    = bool
  default = true
}
