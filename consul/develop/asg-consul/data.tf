module "vpc" {
  source      = "../../../modules/data-vpc"
  environment = local.environment
  config_name  = local.config_name
  vpc_name = "${local.config_name}-${local.environment}-vpc"
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

data "kubernetes_secret" "tool_token" {
  metadata {
    name = "${local.tool_name}-${local.environment}-${local.tool_name}-bootstrap-acl-token"
    namespace = local.tool_name
  }
}

data "kubernetes_secret" "tool_tls_ca" {
  metadata {
    name = "${local.tool_name}-tls-ca"
    namespace = local.tool_name
  }
}

data "aws_ssm_parameter" "consul_keyring" {
  name = "/secrets/core-infra/develop/consul_keyring"
}

data "kubernetes_service" "server_lb" {
  metadata {
    name = "${local.tool_name}-server-lb"
    namespace =  local.tool_name
  }
}

data "aws_ami" "consul_ami" {
  most_recent = true
  owners      = ["979382823631"]

  filter {
    name   = "name"
    values = ["bitnami-consul-*"]
  }
}

data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.0.*"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/assets/amazon-self-consul-user-data.sh")

  vars = {
    consul_version = var.consul_version
    consul_hcl_file_content = data.template_file.consul_hcl.rendered
    consul_service_file_content = data.template_file.consul_service.rendered
    tls_ca_file = data.kubernetes_secret.tool_tls_ca.data["ca"]
  }
}

data "template_file" "consul_hcl" {
  template = file("${path.module}/assets/consul.hcl")

  vars = {
    datacenter_name = var.datacenter_name
    retry_join_url = data.kubernetes_service.server_lb.status.0.load_balancer.0.ingress.0.hostname
    encryption_keyring = data.aws_ssm_parameter.consul_keyring.value
    consul_acl_token = data.kubernetes_secret.tool_token.data["token"]
  }
}

data "template_file" "consul_service" {
  template = file("${path.module}/assets/consul.service")
}
