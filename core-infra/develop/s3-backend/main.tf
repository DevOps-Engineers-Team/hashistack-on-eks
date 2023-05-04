module "backend" {
  source      = "../../../modules/s3-backend"
  bucket_name    = "${local.confg_name}-gitops"
  environment = local.environment

  bucket_policy_allowed_roles_arns = local.bucket_policy_allowed_roles_arns
  bucket_name_postfix = var.bucket_name_postfix
  create_dynamodb_lock = true
  create_kms_alias = true
}
