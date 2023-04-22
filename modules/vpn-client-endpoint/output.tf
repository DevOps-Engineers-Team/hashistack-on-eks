output "acm_cert" {
  value       = tls_locally_signed_cert.root.cert_pem
  description = "A mapping of tags to assign to the certificate."
  sensitive   = true
}

output "acm_key" {
  value       = tls_private_key.root.private_key_pem
  description = "A mapping of tags to assign to the key."
  sensitive   = true
}
