variable "document_name" {}

variable "document_type" {
    default = "Command"
}

variable "schema_version" {
    default = "1.2"
}

variable "document_description" {}

variable "shell_commands" {
    type = list(string)
    default = []
}
