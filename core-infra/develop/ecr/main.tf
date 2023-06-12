module "ecr" {
  for_each = local.ecr_config
  source = "../../../modules/ecr"
  repo_name = each.value["name"]
  repo_pull_permissions = local.repo_pull_permissions
  repo_push_permissions = local.repo_push_permissions
}
