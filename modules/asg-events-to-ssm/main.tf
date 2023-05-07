resource "aws_cloudwatch_event_rule" "cw_event_rule" {
  name        = var.cw_event_name

  event_pattern = jsonencode({
    source = [
      "aws.autoscaling"
    ]
    detail-type = var.event_detail_types
  })
}

resource "aws_cloudwatch_event_target" "cw_event_target" {
  arn                 = replace(aws_ssm_document.ssm_document_template.arn, "document/", "automation-definition/")
  rule = aws_cloudwatch_event_rule.cw_event_rule.id
  role_arn = aws_iam_role.ssm_automation_role.arn

  input_transformer {
    input_paths = {
      asgname = "$.detail.AutoScalingGroupName",
      instanceid = "$.detail.EC2InstanceId",
      lchname = "$.detail.LifecycleHookName"
    }
    input_template ="{\"InstanceId\":[<instanceid>],\"ASGName\":[<asgname>],\"LCHName\":[<lchname>],\"automationAssumeRole\":[\"${aws_iam_role.ssm_automation_role.arn}\"]}"
  }
}

resource "aws_iam_role" "ssm_automation_role" {
  name = "${var.cw_event_name}-ssm-role"

  assume_role_policy = jsonencode({
    Version: "2008-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: [
            "ec2.amazonaws.com",
            "ssm.amazonaws.com"
        ]
        },
        Action: "sts:AssumeRole",
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_automation_attachments" {
  role       = aws_iam_role.ssm_automation_role.name
  policy_arn = aws_iam_policy.ssm_automation_policy.arn
}

resource "aws_iam_policy" "ssm_automation_policy" {
  name        = "${var.cw_event_name}-ssm-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:CompleteLifecycleAction*",
        ]
        Effect   = "Allow"
        Resource = var.asg_arn
      },
      {
        Action = [
            "ec2:CreateImage",
            "ec2:DescribeImages",
            "ssm:DescribeInstanceInformation",
            "ssm:ListCommands",
            "ssm:ListCommandInvocations"
        ],
        Resource = "*",
        Effect = "Allow"
        },
        {
         Action = [
            "ssm:SendCommand"
        ],
        Resource = aws_ssm_document.ssm_document_template.arn,
        Effect = "Allow"
      },
     {
       Action = [
         "ssm:SendCommand"
        ],
       Resource ="arn:aws:ec2:*:*:instance/*",
       Effect = "Allow"
     }
    ]
  })
}

resource "aws_ssm_document" "ssm_document_template" {
    name          = var.document_name
    document_type = var.document_type

    content = jsonencode({
        schemaVersion: var.schema_version,
        description: "SSM document ${var.document_name} for ${var.cw_event_name} lifecycle",
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
