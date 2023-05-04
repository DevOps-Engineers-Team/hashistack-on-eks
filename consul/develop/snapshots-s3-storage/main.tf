module "backend" {
  source      = "../../../modules/s3"
  bucket_name    = "${local.config_name}-snapshots-storage"
  environment = local.environment

  bucket_policy_allowed_roles_arns = local.bucket_policy_allowed_roles_arns
  create_dynamodb_lock = false
  create_kms_alias = false
}
