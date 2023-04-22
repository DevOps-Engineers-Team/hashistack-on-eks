resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = format("%s-ca", var.name)
    organization = var.organization_name
  }

  dns_names = var.dns_names

  validity_period_hours = 87600
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "aws_acm_certificate" "ca" {
  private_key      = tls_private_key.ca.private_key_pem
  certificate_body = tls_self_signed_cert.ca.cert_pem
}

resource "tls_private_key" "root" {
  algorithm = "RSA"
}

resource "tls_cert_request" "root" {
  private_key_pem = tls_private_key.root.private_key_pem

  subject {
    common_name  = format("%s-client", var.name)
    organization = var.organization_name
  }

  dns_names = var.dns_names
}

resource "tls_locally_signed_cert" "root" {
  cert_request_pem = tls_cert_request.root.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "aws_acm_certificate" "root" {
  private_key       = tls_private_key.root.private_key_pem
  certificate_body  = tls_locally_signed_cert.root.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = format("%s-server", var.name)
    organization = var.organization_name
  }

  dns_names = var.dns_names
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "server" {
  private_key       = tls_private_key.server.private_key_pem
  certificate_body  = tls_locally_signed_cert.server.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
}

resource "aws_security_group" "vpn_sg" {
  name        = "${var.name}-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    iterator = ingress
    content {
      from_port   = ingress.value["port_from"]
      to_port     = ingress.value["port_to"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  description            = var.name
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = var.cidr_block
  split_tunnel           = var.split_tunnel_enable

  security_group_ids = tolist([aws_security_group.vpn_sg.id])
  vpc_id = var.vpc_id

  authentication_options {
    type                            = var.type
    saml_provider_arn               = var.saml_arn
    self_service_saml_provider_arn  = var.self_saml_arn
    root_certificate_chain_arn = aws_acm_certificate.root.arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.vpn.name
  }

  lifecycle {
    ignore_changes = [
      authentication_options
    ]
  }
}

resource "aws_ec2_client_vpn_network_association" "default" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  subnet_id              = element(var.subnet_ids, count.index)

  lifecycle {
    ignore_changes = [subnet_id]
  }
}

resource "aws_cloudwatch_log_group" "vpn" {
  name              = format("/aws/vpn/%s/logs", var.name)
  retention_in_days = var.logs_retention
}

resource "aws_cloudwatch_log_stream" "vpn" {
  name           = format("%s-usage", var.name)
  log_group_name = aws_cloudwatch_log_group.vpn.name
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  target_network_cidr    = var.vpc_cidr
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "vpn_route" {
  count = length(aws_ec2_client_vpn_network_association.default)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.default[count.index].subnet_id # element(var.route_subnet_ids, count.index)
  depends_on             = [aws_ec2_client_vpn_network_association.default]
}
