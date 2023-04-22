module "asg_consul" {
  source        = "../../../modules/asg-with-lt"
  asg_name = var.asg_name
  user_data_script = data.template_file.user_data.rendered
  vpc_id = module.vpc.vpc_id
  image_id = data.aws_ami.amazon_ami.id
  subnet_ids = module.vpc.private_subnet_ids
}
