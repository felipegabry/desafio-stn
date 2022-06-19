# Módulo EKS
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "desafio"
  cluster_version                 = "1.22"
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    monitor = {
      min_size               = 1
      max_size               = 5
      desired_size           = 2
      vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
      instance_types         = ["t2.micro"]
    }
  }
}