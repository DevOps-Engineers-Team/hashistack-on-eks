module "helm_config" {
  source = "./helm-config"
  server_replica_count = var.server_replica_count
  ui_service_type = var.ui_service_type
  manage_system_acl = var.manage_system_acl
  server_expose_service_type = var.server_expose_service_type
  image_version = var.image_version
  datacenter_name = var.datacenter_name
  enable_tls = var.enable_tls
  enable_auto_encrypt = var.enable_auto_encrypt
  ca_cert_secret_name = local.ca_cert_secret_name
  ca_cert_secret_key = var.ca_cert_secret_key
  ca_key_secret_name = local.ca_key_secret_name
  ca_key_secret_key = var.ca_key_secret_key
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

data "aws_acm_certificate" "cert" {
  domain   = "*.${var.target_domain}"
}

data "aws_route53_zone" "private" {
  name         = "${var.target_domain}."
  private_zone = true
}

data "aws_route53_zone" "public" {
  name         = "${var.target_domain}."
  private_zone = false
}

data "aws_ssm_parameter" "consul_keyring" {
  name = "/secrets/core-infra/develop/consul_keyring"
}

data "aws_ssm_parameter" "consul_agent_ca_key" {
  name = "/secrets/core-infra/develop/consul_agent_ca_key"
}

data "aws_ssm_parameter" "consul_agent_ca" {
  name = "/secrets/core-infra/develop/consul_agent_ca"
}
