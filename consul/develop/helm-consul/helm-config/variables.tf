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

variable "enable_tls" {
    type = bool
    default = false
}

variable "enable_auto_encrypt" {
    type = bool
    default = false
}

variable "ca_cert_secret_name" {
    default = null
}

variable "ca_cert_secret_key" {
    default = null
}

variable "ca_key_secret_name" {
    default = null
}

variable "ca_key_secret_key" {
    default = null
}

variable "datacenter_name" {}

variable "ui_service_type" {}

variable "image_version" {}
