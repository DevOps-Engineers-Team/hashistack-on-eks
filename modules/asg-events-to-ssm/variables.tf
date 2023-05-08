variable "cw_event_name" {}

variable "document_name" {}

variable "asg_arn" {}

variable "event_detail_types" {
    default = [
        "EC2 Instance-terminate Lifecycle Action"
    ]
}

variable "document_type" {
    default = "Command"
}

variable "schema_version" {
    default = "1.2"
}

variable "shell_commands" {
    type = list(string)
    default = []
}

