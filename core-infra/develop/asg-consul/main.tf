module "asg_consul" {
  source        = "../../../modules/asg-with-lt"
  asg_name = var.asg_name
  user_data_script = data.template_file.user_data.rendered
  vpc_id = module.vpc.vpc_id
  image_id = data.aws_ami.amazon_ami.id
  subnet_ids = module.vpc.private_subnet_ids
}

module "ssm_doc_stop_consul" {
  source        = "../../../modules/ssm-document"

  document_name = "${var.asg_name}-systemctl-stop"
  document_description = "Stopping systemctl of consul on termnated EC2"
  shell_commands = var.ssm_doc_commands
}