data "template_file" "ingress_yaml" {
    template = file("${path.module}/assets/ingress.yaml")
    vars = {
        ingress_name = var.ingress_name
        kubernetes_namespace = var.kubernetes_namespace
        alb_scheme = var.alb_scheme
        acm_cert_arn = var.acm_cert_arn
        healthcheck_path = var.healthcheck_path
        app_host = var.app_host
        success_codes = var.success_codes
        nodeport_name = var.nodeport_name
        nodeport_number = var.nodeport_number
        backend_protocol = var.backend_protocol
    }
}

data "kubernetes_ingress_v1" "ingress" {
    depends_on = [time_sleep.wait_in_seconds]
    # depends_on = [kubectl_manifest.ingress]
    metadata {
        name = var.ingress_name
        namespace = var.kubernetes_namespace
    }
}