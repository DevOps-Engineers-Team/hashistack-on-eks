data "template_file" "init" {
  template = file("${path.module}/templates/values.yaml.tpl")
  vars = {
    server_replica_count = var.server_replica_count
    ui_service_type = var.ui_service_type
    manage_system_acl = var.manage_system_acl
    is_server_exposed_service = var.is_server_exposed_service
    server_expose_service_type = var.server_expose_service_type
    image_version = var.image_version
    datacenter_name = var.datacenter_name
    enable_tls = var.enable_tls
    enable_auto_encrypt = var.enable_auto_encrypt
    ca_cert_secret_name = var.ca_cert_secret_name
    ca_cert_secret_key = var.ca_cert_secret_key
    ca_key_secret_name = var.ca_key_secret_name
    ca_key_secret_key = var.ca_key_secret_key
  }
}
