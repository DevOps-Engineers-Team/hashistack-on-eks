data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

data "kubernetes_secret" "tool_token" {
  metadata {
    name = "${local.tool_name}-${local.environment}-${local.tool_name}-server-token-dk594"
    namespace = local.tool_name
  }
}
