locals {
  environment   = basename(dirname(path.cwd))
  config_name = basename(dirname(dirname(path.cwd)))
  application  = "gitops"
  cluster_name = "${local.config_name}-${local.environment}-${local.application}-cluster"
  ca_cert_secret_name = "${var.app_name}-tls-ca"
  ca_key_secret_name = "${var.app_name}-tls-ca"
}

variable "app_name" {
  default = "consul"
}

variable "helm_repo_url" {
  default = "https://helm.releases.hashicorp.com"
}

variable "kubernetes_namespace" {
  default = "consul"
}

variable "create_namespace" {
  type = bool
  default = false
}

variable "helm_chart_name" {
  default = "consul"
}

variable "helm_chart_version" {
  default = "1.1.1"
}

variable "helm_sets" {
  default = {}
}

variable "image_version" {
  default = "hashicorp/consul:1.15.2"
}

variable "datacenter_name" {
  default = "aws-eks"
}

variable "server_replica_count" {
    type = number
    default = 3
}

variable "ui_service_type" {
    default = "NodePort"
}

variable "target_domain" {
  default = "witold-demo.com"
}

variable "nodeport_service_number" {
  default = 443
}

variable "priv_alb_scheme" {
  default = "internal"
}

variable "pub_alb_scheme" {
    default = "internet-facing"
}

variable "success_codes" {
    default = "200-301"
}

variable "backend_protocol" {
    default = "HTTPS"
}

variable "manage_system_acl" {
    type = bool
    default = true
}

variable "enable_tls" {
    type = bool
    default = true
}

variable "enable_auto_encrypt" {
    type = bool
    default = true
}


variable "ca_cert_secret_key" {
    default = "ca"
}

variable "ca_key_secret_key" {
    default = "ca_key"
}

variable "server_expose_service_type" {
  default = "LoadBalancer"
}

variable "service_lb_name" {
  default = "consul-server-lb"
}

variable "selectors_map" {
  type = map(string)
  default = {
    app = "consul"
    component = "server"
    release = "consul-develop"
  }
}

variable "ports_map" {
  type = map(map(number))
  default = {
    "lan-gossip" = {
      port = 8301
      target_port = 8301
    }
    "grpc" = {
      port = 8300
      target_port = 8300
    }
    "dns" = {
      port = 8600
      target_port = 8600
    }
  }
}
