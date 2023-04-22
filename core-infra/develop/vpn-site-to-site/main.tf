module "vpn" {
  source        = "../../../modules/vpn-site-to-site"
  vpc_id = module.vpc.vpc_id
  cgw_ip = data.aws_ssm_parameter.cgw_ip.value
  dest_on_prem_cidr = var.dest_on_prem_cidr
  route_table_ids = tolist(data.aws_route_tables.priv_route_tables.ids)
}
