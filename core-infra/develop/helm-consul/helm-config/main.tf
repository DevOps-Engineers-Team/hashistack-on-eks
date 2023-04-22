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
  }
}
