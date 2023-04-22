locals {
  environment   = basename(dirname(path.cwd))
  config_name = basename(dirname(dirname(path.cwd)))
}

variable "dest_on_prem_cidr" {
  default = "192.168.0.0/16"
}