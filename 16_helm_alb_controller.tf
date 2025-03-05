# we need the EKS cluster to automatically create a load balancer using manifest files, 
# we need the add-on AWS Load Balancer Controller
# These add-ons can be provisioned manually after the cluster is created using either helm charts or Kubernetes manifest files or right now as automattion using terraform.
#https://andrewtarry.com/posts/terraform-eks-alb-setup/#google_vignette

resource "helm_release" "aws-load-balancer-controller" {
  name       = var.alb_helm_chart_name
  repository = var.alb_helm_chart_repo
  chart      = var.alb_helm_chart_release_name
  version    = var.alb_helm_chart_version
  namespace  = var.kubesystem_namespace

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name_alb # ALB Service account name
  }

  # set {
  #   name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   # value= aws_iam_role.AmazonEKSLoadBalancerControllerRole.arn # ARN of IAM Role
  #    value= iam_role_arn # ARN of IAM Role
  # }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller" #https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  }

  # If ALB Controller deploying along wiht VPC and EKS then explicitly depends on those resources
  depends_on = [
    module.eks,
    kubernetes_service_account.service-account # Service account
  ]
}

