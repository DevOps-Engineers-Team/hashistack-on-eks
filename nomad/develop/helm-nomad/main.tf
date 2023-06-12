module "nomad_namespace" {
  source               = "../../../modules/k8s-namespace"
  namespace =  var.kubernetes_namespace
}

module "gossip_encrypt_key" {
  depends_on = [module.nomad_namespace]
  source               = "../../../modules/k8s-secret"
  name                 = "${var.app_name}-gossip-encrypt-keyring"
  namespace            = var.kubernetes_namespace
  data                 = {
    keyring = data.aws_ssm_parameter.nomad_keyring.value
    key = data.aws_ssm_parameter.nomad_keyring.value
  }
}

module "nomad_helm_chart" {
    depends_on = [module.gossip_encrypt_key]
    source = "../../../modules/generic-helm-release"
    environment = local.environment
    kubernetes_namespace = var.kubernetes_namespace
    create_namespace = var.create_namespace
    helm_chart_name = loca.helm_chart_path # "./chart"
    helm_init_values = module.helm_config.helm_values
    helm_sets = var.helm_sets
}

# module "ingress_alb_cname" {
#     depends_on = [module.nomad_helm_chart]
#     source = "../../../modules/ingress-alb-cname"
#     ingress_name = "${var.app_name}-ingress"
#     kubernetes_namespace = var.kubernetes_namespace
#     acm_cert_arn = data.aws_acm_certificate.cert.arn
#     success_codes = var.success_codes
#     app_host = "${var.app_name}.${var.target_domain}"
#     nodeport_name = "${var.app_name}-${local.environment}-${var.app_name}-ui"
#     nodeport_number = var.nodeport_service_number
#     hosted_zone_id = data.aws_route53_zone.private.zone_id
#     alb_scheme = var.priv_alb_scheme
# }

# module "ingress_alb_cname_temp" {
#     depends_on = [module.nomad_helm_chart]
#     source = "../../../modules/ingress-alb-cname"
#     ingress_name = "temp-${var.app_name}-ingress"
#     kubernetes_namespace = var.kubernetes_namespace
#     acm_cert_arn = data.aws_acm_certificate.cert.arn
#     success_codes = var.success_codes
#     app_host = "temp-${var.app_name}.${var.target_domain}"
#     nodeport_name = "${var.app_name}-${local.environment}-${var.app_name}-ui"
#     nodeport_number = var.nodeport_service_number
#     hosted_zone_id = data.aws_route53_zone.public.zone_id
#     alb_scheme = var.pub_alb_scheme
# }

# module "nomad_server_lb" {
#   depends_on = [module.nomad_helm_chart]
#   source               = "../../../modules/k8s-service-lb"
#   service_lb_name                 = var.service_lb_name
#   namespace            = var.kubernetes_namespace
#   selectors_map = var.selectors_map
#   ports_map = var.ports_map
# }
