# Módulo EKS
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

# Data Source aws_eks_cluster-auth
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth

# Módulo metrics-server
# https://registry.terraform.io/modules/lablabs/eks-metrics-server/aws/latest

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}

    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  
  eks_managed_node_groups = {
    monitor = {
      min_size               = 1
      max_size               = 5
      desired_size           = 2
      vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
      instance_types         = ["t3.large"]
    }
  }
}

module "eks-metrics-server" {
  source  = "lablabs/eks-metrics-server/aws"
  version = "1.0.0"
}