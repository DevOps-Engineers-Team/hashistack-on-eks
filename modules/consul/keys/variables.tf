variable "datacenter_name" {}

variable "keys_config" {
    type = map(map(string))
    default = {}
}