variable "asg_name" {}

variable "vpc_id" {}

variable "image_id" {}

variable "user_data_script" {
    default = null
}

variable "enable_ebs_optmization" {
    type = bool
    default = false
}

variable "enable_monitoring" {
    type = bool
    default = false
}

variable "instance_type" {
    default = "t2.micro"
}

variable "az_list" {
    type = list(string)
    default = []
}

variable "min_cap" {
    type = number
    default = 1
}

variable "max_cap" {
    type = number
    default = 3
}

variable "desired_cap" {
    type = number
    default = 1
}

variable "subnet_ids" {
    type = list(string)
    default = []
}

variable "asg_lifecycle_transition" {
    default = "autoscaling:EC2_INSTANCE_TERMINATING"
}

variable "asg_default_result" {
    default = "CONTINUE"
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

variable "managed_policies_arns" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
}
