locals {
  environment   = basename(dirname(path.cwd))
  config_name = basename(dirname(dirname(path.cwd)))
}

variable "domain" {
  default = "witold-demo"
}

variable "top_domain" {
  default = "com"
}

variable "is_private" {
  type = bool
  default = true
}
