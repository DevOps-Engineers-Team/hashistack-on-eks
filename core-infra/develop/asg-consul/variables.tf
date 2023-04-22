locals {
  environment   = basename(dirname(path.cwd))
  config_name = basename(dirname(dirname(path.cwd)))
  tool_name = "consul"
  application  = "gitops"
  cluster_name = "${local.config_name}-${local.environment}-${local.application}-cluster"
}

variable "asg_name" {
    default = "consul-asg"
}

variable "consul_version" {
    default = "1.15.2"
}

variable "datacenter_name" {
  default = "aws-eks"
}
