resource "kubectl_manifest" "ingress" {
  yaml_body = data.template_file.ingress_yaml.rendered
}


resource "time_sleep" "wait_in_seconds" {
  depends_on = [kubectl_manifest.ingress]
  create_duration = "30s"
}

resource "aws_route53_record" "cname_record" {
  # depends_on = [time_sleep.wait_in_seconds]
  zone_id = var.hosted_zone_id
  name    = var.app_host
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_ingress_v1.ingress.status.0.load_balancer.0.ingress.0.hostname]
}
