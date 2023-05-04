locals {
  tool_name = basename(dirname(dirname(path.cwd)))
  environment   = basename(dirname(path.cwd))
  config_name = "core-infra"
  application  = "gitops"
  cluster_name = "${local.config_name}-${local.environment}-${local.application}-cluster"
  tool_address = "${local.tool_name}.${var.target_domain}"
}

variable "target_domain" {
  default = "witold-demo.com"
}