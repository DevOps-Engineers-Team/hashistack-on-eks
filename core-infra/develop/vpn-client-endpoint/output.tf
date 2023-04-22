output "acm_cert" {
    sensitive = true
    value = module.vpn_client_endpoint.acm_cert
}

output "acm_key" {
    sensitive = true
    value = module.vpn_client_endpoint.acm_key
}
