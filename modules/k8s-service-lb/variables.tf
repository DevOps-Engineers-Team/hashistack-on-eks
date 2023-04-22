variable "service_lb_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "is_clb_internal" {
  type = bool
  default = true
}

variable "selectors_map" {
  type = map(string)
  default = {}
}

variable "ports_map" {
  type = map(map(number))
  default = {}
}
