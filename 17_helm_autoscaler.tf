# # Resource: IAM Policy for Cluster Autoscaler
resource "aws_iam_policy" "AmazonEKSClusterAutoscalerPolicy" {
  name   = "AmazonEKSClusterAutoscalerPolicy"
  policy = file("./iam_policy_autoscaler.json") # IAM Policy
}

# Trust Policy -> role -> OIDC -> service account -> node autoscaler controller pod of Cluster
data "aws_iam_policy_document" "cluster_autoscaler_iam_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.kubesystem_namespace}:${var.service_account_name_autoscaler}"] # Attach only to service account with name XYZ(autoscaler-controller) in kube-system namespace
    }
  }
}

resource "aws_iam_role" "AmazonEKSClusterAutoScalerrRole" {
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_iam_role.json # IAM ROLE Trust Policy
  name               = "AmazonEKSClusterAutoScalerrRole"                             # IAM ROLE
}

# Attach IAM Policy to IAM ROLE
resource "aws_iam_role_policy_attachment" "aws_node_autoscaler_attach" {
  role       = aws_iam_role.AmazonEKSClusterAutoScalerrRole.name
  policy_arn = aws_iam_policy.AmazonEKSClusterAutoscalerPolicy.arn
}

resource "kubernetes_service_account" "service-account-cluster-autoscaler" {
  metadata {
    name      = var.service_account_name_autoscaler
    namespace = var.kubesystem_namespace
    labels = {
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app"   = var.service_account_name_autoscaler
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.AmazonEKSClusterAutoScalerrRole.arn
    }
  }
  depends_on = [
    aws_iam_role.AmazonEKSClusterAutoScalerrRole
  ]
}

# All helm version :"https://gallery.ecr.aws/eks-anywhere/cluster-autoscaler/charts/cluster-autoscaler"
# https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler
resource "helm_release" "cluster-autoscaler" {
  name = "ca" # Create resources with same name : ServiceAccount, Role, Role-Binding, ClusterRole, ClusterRoleBinding
  # Check that this is good, kube-system should already exist
  namespace  = var.kubesystem_namespace       # Create resources in "kube-system" namespace
  repository = var.autoscaler_helm_chart_repo # Use these repor .YAML manifest file to create resources : ServiceAccount, Role, Role-Binding, ClusterRole, ClusterRoleBinding
  chart      = "cluster-autoscaler"
  version    = var.autoscaler_helm_chart_version #Helm chart version

  # Terraform keeps this in state, so we get it automatically!
  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.pspEnabled"
    value = "false"
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = var.service_account_name_autoscaler # autoscaler Service account name
  }

  # set {
  #   name  = "image.repository"
  #   value = var.autoscaler_helm_chart_app_image # autoscaler-image
  # }

  # helm repo add autoscaler https://kubernetes.github.io/autoscaler
  # helm search repo autoscaler --versions | head
  # set {
  #   name  = "image.tag"
  #   value = var.autoscaler_helm_chart_app_version # autoscaler-image:tag
  # }

  depends_on = [module.eks, kubernetes_service_account.service-account-cluster-autoscaler]
}