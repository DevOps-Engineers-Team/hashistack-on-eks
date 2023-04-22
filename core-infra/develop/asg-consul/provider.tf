provider "aws" {
    region = "eu-west-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "consul" {
  address    = "${local.tool_address}"
  scheme = "https"
  token = data.kubernetes_secret.tool_token.data["token"]
}