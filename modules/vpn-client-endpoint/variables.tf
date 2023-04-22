variable "name" {
  type        = string
  default     = ""
  description = "Client VPN Name"
}

variable "environment" {}

variable "cidr_block" {
  type        = string
  default     = ""
  description = "Client VPN CIDR"
}

variable "vpc_cidr" {
  type        = string
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet ID to associate clients"
}

variable "organization_name" {
  type        = string
  default     = "witold-local.com"
  description = "Name of organization to use in private certificate"
}

variable "logs_retention" {
  type        = number
  default     = 365
  description = "Retention in days for CloudWatch Log Group"
}

variable "route_cidr" {
  type        = list(any)
  default     = []
  description = "Client Route CIDR"
}

variable "route_subnet_ids" {
  type        = list(any)
  default     = []
  description = "Client Route Subnet Ids"
}

variable "network_cidr" {
  type        = list(any)
  default     = []
  description = "Client Network CIDR"
}


variable "split_tunnel_enable" {
  type        = bool
  default     = false
  description = "Indicates whether split-tunnel is enabled on VPN endpoint."
}

variable "dns_names" {
  type        = list(any)
  default     = []
  description = "List of DNS names for which a certificate is being requested."
}

variable "type" {
  type        = string
  default     = "certificate-authentication"
  description = "The type of client authentication to be used. "
}

variable "saml_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM SAML identity provider. "
}

variable "self_saml_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM SAML identity provider for the self service portal. "
}


variable "security_group_ids" {
  type    = list(any)
  default = []
  description = "The IDs of one or more security groups to apply to the target network. You must also specify the ID of the VPC that contains the security groups."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC to associate with the Client VPN endpoint. If no security group IDs are specified in the request, the default security group for the VPC is applied."
}

variable "sg_ingress_rules" {
    type = map(object({
        port_from = number
        port_to   = number
        protocol  = string
        cidr      =  set(string)
    }))
    default = {}
}

