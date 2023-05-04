terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.17.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.19.0"
    }
  }
  required_version = ">= 1.0.0"
}
