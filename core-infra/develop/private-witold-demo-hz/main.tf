module "vpc" {
  source      = "../../../modules/data-vpc"
  environment = local.environment
  config_name  = local.config_name
  vpc_name = "${local.config_name}-${local.environment}-vpc"
}

module "private_hiven_com" {
    source = "../../../modules/aws-r53-hosted-zone"
    vpc_id = module.vpc.vpc_id
    domain = var.domain
    top_domain = var.top_domain
    is_private = var.is_private
}

