resource "consul_keys" "keys" {
  datacenter = var.datacenter_name

  dynamic "key" {
    for_each = var.keys_config
    # iterator = 
    content {
        path  = key.value["path"]
        value = key.value["value"]
    }
  }
}
