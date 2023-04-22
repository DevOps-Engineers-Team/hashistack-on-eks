locals {
  environment   = basename(dirname(path.cwd))
  config_name = basename(dirname(dirname(path.cwd)))

  openvpn_files = {
    cert = module.vpn_client_endpoint.acm_cert
    key = module.vpn_client_endpoint.acm_key
  }
}

variable "dns_names" {
  type        = list(any)
  default     = ["witold-local.com"]
  description = "List of DNS names for which a certificate is being requested."
}
