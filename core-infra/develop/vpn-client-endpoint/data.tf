module "vpc" {
  source      = "../../../modules/data-vpc"
  environment = local.environment
  config_name  = local.config_name
  vpc_name = "${local.config_name}-${local.environment}-vpc"
}

data "aws_ssm_parameter" "cgw_ip" {
  name     = "/secrets/customer_gw_ip"
}

data "aws_route_tables" "priv_route_tables" {
  vpc_id = module.vpc.vpc_id

  filter {
    name   = "tag:Name"
    values = ["${local.config_name}-${local.environment}-private-rt*"]
  }
}

resource "local_file" "openvpn_files" {
  for_each = local.openvpn_files
  content  = each.value
  filename = "${path.module}/acm-${each.key}"
}
