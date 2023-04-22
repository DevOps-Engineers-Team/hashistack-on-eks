resource "kubernetes_service_v1" "service_lb" {
  metadata {
    name = var.service_lb_name
    namespace            = var.namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-internal" = var.is_clb_internal
  }
  }
  spec {
    selector = var.selectors_map
    
    dynamic "port" {
      for_each = var.ports_map
      iterator = port_pair
      content {
        name = port_pair.key
        port        = port_pair.value["port"]
        target_port = port_pair.value["target_port"]
      }
    }

    type = "LoadBalancer"
  }
}
