### Backend

terraform {
  backend "s3" {
    bucket = "core-infra-gitops-terraform-backend"
    key = "develop/asg-consul/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}