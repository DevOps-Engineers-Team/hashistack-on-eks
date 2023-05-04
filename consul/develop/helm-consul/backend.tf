terraform {
  backend "s3" {
    bucket = "core-infra-gitops-terraform-backend"
    key = "develop/consul-helm-chart/terraform.state"
    region = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}