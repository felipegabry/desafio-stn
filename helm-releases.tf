
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "calico" {
  name  = "calico"
  chart = "tigera-operator"
  repository       = "https://projectcalico.docs.tigera.io/charts"
  namespace        = "tigera-operator"
  version          = "3.23.2"
  create_namespace = true
  wait             = true
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "monitoring"
  version          = "36.2.1"
  create_namespace = true
  wait             = true
  reset_values     = true
}