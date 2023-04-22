module "vpn_client_endpoint" {
  source        = "../../../modules/vpn-client-endpoint"
  name             = "${local.config_name}-${local.environment}-vpn-client"
  environment      = local.environment
  cidr_block       = "172.0.0.0/16"
  subnet_ids       = module.vpc.public_subnet_ids
  vpc_cidr = module.vpc.vpc_cidr
  vpc_id = module.vpc.vpc_id
  dns_names = var.dns_names

  sg_ingress_rules = {
    vpc = {
      port_from = 443
      port_to   = 443
      protocol  = "tcp"
      cidr      = [module.vpc.vpc_cidr]
    }
    home = {
      port_from = 443
      port_to   = 443
      protocol  = "tcp"
      cidr      = ["${data.aws_ssm_parameter.cgw_ip.value}/32"]
    }
  }
}
