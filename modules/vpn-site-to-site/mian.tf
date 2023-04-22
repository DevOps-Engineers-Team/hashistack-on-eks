resource "aws_customer_gateway" "customer_gw" {
  bgp_asn    = var.bgp_asn
  ip_address = var.cgw_ip
  type       = var.tunnel_type
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = var.vpc_id
}

resource "aws_vpn_gateway_attachment" "vpn_gw_attach" {
  vpc_id         = var.vpc_id
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
}

resource "aws_vpn_gateway_route_propagation" "rt_propagation" {
  count = length(var.route_table_ids)
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
  route_table_id = var.route_table_ids[count.index]
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.customer_gw.id
  type                = var.tunnel_type
  static_routes_only  = var.use_static_routes
  tunnel1_preshared_key = random_string.passphrase.result
}

resource "aws_vpn_connection_route" "on_prem_connect" {
  destination_cidr_block = var.dest_on_prem_cidr
  vpn_connection_id      = aws_vpn_connection.vpn.id
}

resource "random_string" "passphrase" {
  length           = 12
  special          = false
  upper = false
}
