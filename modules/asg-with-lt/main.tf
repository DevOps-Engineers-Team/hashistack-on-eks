resource "aws_security_group" "asg_sg" {
  name        = "${var.asg_name}-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    iterator = ingress
    content {
      from_port   = ingress.value["port_from"]
      to_port     = ingress.value["port_to"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "asg_lt" {
    name = "${var.asg_name}-launch-template"

    ebs_optimized = var.enable_ebs_optmization

    monitoring {
        enabled = var.enable_monitoring
    }

    # block_device_mappings {
    #   device_name = "/dev/xvda"
    #   ebs {
    #     delete_on_termination = true
    #     volume_type           = "gp3"
    #     volume_size           = var.volume_size
    #     encrypted             = var.volume_encryption
    #     iops                  = null
    #   }
    # }

    iam_instance_profile  {
      arn = aws_iam_instance_profile.asg_profile.arn
    }

    tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.asg_name
    }
  }

    instance_type = var.instance_type
    image_id = var.image_id

    vpc_security_group_ids = tolist([aws_security_group.asg_sg.id])

    user_data = var.user_data_script != null ? base64encode(var.user_data_script) : null
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity   = var.desired_cap
  max_size           = var.max_cap
  min_size           = var.min_cap
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.asg_lt.id
  }
}

resource "aws_autoscaling_lifecycle_hook" "asg_termination_lifecycle_hook" {
  name                   =  "${var.asg_name}-lifecycle-hook"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lifecycle_transition   = var.asg_lifecycle_transition
  default_result         = var.asg_default_result
  role_arn                = aws_iam_role.asg_role.arn
  notification_target_arn = aws_sns_topic.asg_sns_topic.arn
}

resource "aws_sns_topic" "asg_sns_topic" {
  name = "${var.asg_name}-sns-topic"
}

resource "aws_iam_instance_profile" "asg_profile" {
  name = "${var.asg_name}-profile"
  role = aws_iam_role.asg_role.name
}

resource "aws_iam_role" "asg_role" {
  name = "${var.asg_name}-role"

  assume_role_policy = jsonencode({
    Version: "2008-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: [
            "ec2.amazonaws.com",
            "autoscaling.amazonaws.com"
          ]
        },
        Action: "sts:AssumeRole",
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "managed_policies_attachments" {
  count      = length(var.managed_policies_arns)
  role       = aws_iam_role.asg_role.name
  policy_arn = element(var.managed_policies_arns, count.index)
}