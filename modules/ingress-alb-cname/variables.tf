variable "ingress_name" {}

variable "kubernetes_namespace" {}

variable "acm_cert_arn" {}

variable "app_host" {}

variable "hosted_zone_id" {}

variable "nodeport_name" {}

variable "nodeport_number" {
    type = number
}

variable "backend_protocol" {
    default = "HTTP"
}

variable "healthcheck_path" {
    default = "/"
}

variable "alb_scheme" {
    default = "internet-facing"
}

variable "success_codes" {
    default = "200"
}