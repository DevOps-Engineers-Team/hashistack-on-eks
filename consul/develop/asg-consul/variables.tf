locals {
  environment   = basename(dirname(path.cwd))
  config_name = "core-infra"
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

variable "ssm_doc_commands" {
  type = list(string)
  default = ["systemctl stop consul"]
}