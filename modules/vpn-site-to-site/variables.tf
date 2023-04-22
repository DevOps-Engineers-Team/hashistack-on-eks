variable "cgw_ip" {}

variable "dest_on_prem_cidr" {}

variable "vpc_id" {}

variable "route_table_ids" {
    type = list(string)
    default = []
}

variable "bgp_asn" {
    type = number
    default = 65000
}

variable "tunnel_type" {
    default = "ipsec.1"
}

variable "use_static_routes" {
    type = bool
    default = true
}
