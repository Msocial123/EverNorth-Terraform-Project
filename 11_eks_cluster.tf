#https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
module "eks" {
  depends_on = [module.vpc, module.ec2_bastion_instance]
  source     = "terraform-aws-modules/eks/aws"
  version    = "20.8.4"

  cluster_name                         = var.eks-cluster-name
  cluster_version                      = var.eks-cluster-version
  cluster_endpoint_public_access       = false
  cluster_endpoint_private_access      = true
  # cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = flatten([module.vpc.public_subnets, module.vpc.private_subnets])
  cluster_additional_security_group_ids = [aws_security_group.bastion_host_to_cluster.id]

  # create OpenID Connect Provider for EKS to enable IRSA
  enable_irsa = true

  # Default settings that will be applied to all node groups unless overridden
  eks_managed_node_group_defaults = {
    disk_size       = 8     # default volume size
    disk_type       = "gp2" # gp3 ebs volume
    disk_throughput = 100   # min throughput
    # Subnets to use (Recommended: Private Subnets)
    subnets = module.vpc.private_subnets
    update_config = {
      max_unavailable_percentage = 3 # or set `max_unavailable`
    }
  }

  # overridden default settings
  eks_managed_node_groups = {
    # override the setting specific for the node group
    node_group_one = {
      name            = var.eks-managed-nodegroup-name
      use_name_prefix = true
      capacity_type   = "ON_DEMAND" # node_group_one to be on-demand
      min_size        = 2
      max_size        = 5
      desired_size    = 3

      instance_types = ["t2.medium"]

      tags = {
        "k8s.io/cluster-autoscaler/enabled"                 = "true"
        "k8s.io/cluster-autoscaler/${var.eks-cluster-name}" = "owned"
      }
    }
  }

  #  enables granting administrator permissions to the entity that created the EKS cluster. It essentially gives the creator full control over the cluster.
  enable_cluster_creator_admin_permissions = true

  # enable cluster access to different user or users or IAM role
  # access_entries = {
  #     # One access entry with a policy associated
  #     bastion_host_access = {
  #         kubernetes_groups = []
  #         principal_arn     = aws_iam_role.bastion_host_iam_role.arn
  #     }
  # }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}

resource "aws_eks_access_entry" "bastion_host_access" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.bastion_host_iam_role.arn
  kubernetes_groups = []
  type              = "EC2_LINUX" #["EC2_LINUX" "EC2_WINDOWS" "FARGATE_LINUX" "STANDARD"]
}