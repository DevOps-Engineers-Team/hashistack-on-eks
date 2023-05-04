resource "aws_ssm_document" "ssm_document_template" {
    name          = var.document_name
    document_type = var.document_type

    content = jsonencode({
        schemaVersion: var.schema_version,
        description: var.document_description,
        parameters: {},
        runtimeConfig: {
            "aws:runShellScript": {
                properties: [
                    {
                        id: "0.aws:runShellScript",
                        runCommand: var.shell_commands
                    }
                ]
            }
        }
    })
}
