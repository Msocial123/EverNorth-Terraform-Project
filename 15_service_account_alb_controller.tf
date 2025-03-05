# https://andrewtarry.com/posts/terraform-eks-alb-setup/#google_vignette

# Create IAM role for service account with trust policy using cluster OIDC
# module "lb_role" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name = "module_eks_lb"
#   attach_load_balancer_controller_policy = true # Create an IAM Policy and attach it to IAM Role

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }

# Add in 0_provider.tf file
# provider "kubernetes" {
#   host = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", var.eks-cluster-name]
#       command     = "aws"
#     }
# }

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = var.service_account_name_alb
    namespace = var.kubesystem_namespace
    labels = {
      "app.kubernetes.io/name"      = var.service_account_name_alb
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = aws_iam_role.AmazonEKSLoadBalancerControllerRole.arn # ARN of IAM Role
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
      # "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
    }
  }
  depends_on = [
    module.eks.eks_managed_node_groups,                                 # Depends on EKS cluster node group
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach, #Depends on IAM Role for service account,
    # module.lb_role
  ]
}

