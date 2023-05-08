locals {
  full_bucket_name = var.bucket_name_postfix == null ? var.bucket_name : "${var.bucket_name}-${var.bucket_name_postfix}"
}

variable "bucket_name" {}

variable "environment" {}

variable "bucket_name_postfix" {
  default = null
}

variable "bucket_policy_allowed_roles_arns" {
  type = list(string)
  default = []
}

variable "create_dynamodb_lock" {
  type = bool
  default = false
}

variable "create_kms_alias" {
  type = bool
  default = false
}