variable "manage_system_acl" {
    type = bool
}

variable "is_server_exposed_service" {
    type = bool
    default = true
}

variable "server_expose_service_type" {}

variable "server_replica_count" {
    type = number
}

variable "datacenter_name" {}

variable "ui_service_type" {}

variable "image_version" {}
