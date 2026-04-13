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


# BILLING MODE VARIABLE BLOCK
variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"

  validation {
    condition     = anytrue([for e in ["PAY_PER_REQUEST", "PROVISIONED"] : e == var.billing_mode])
    error_message = "Billing mode must be either 'PAY_PER_REQUEST' or 'PROVISIONED'."
  }
}

# -------------------------------
# ATTRIBUTE NAME VARIABLE BLOCK
# -------------------------------
variable "lock_id" {
  type    = string
  default = "LockID"
}

# -------------------------------
# ATTRIBUTE TYPE VARIABLE BLOCK
# -------------------------------
variable "attribute_type" {
  type    = string
  default = "S"

  validation {
    condition     = contains(["S", "N", "B"], var.attribute_type)
    error_message = "value"
  }
}