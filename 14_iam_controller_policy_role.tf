resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("./iam_policy_alb.json") # IAM Policy
}

# Trust Policy -> role -> OIDC -> service account -> alb controller pod of Cluster
data "aws_iam_policy_document" "example_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.kubesystem_namespace}:${var.service_account_name_alb}"] # Attach only to service account with name XYZ(aws-load-balancer-controller) in kube-system namespace
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "AmazonEKSLoadBalancerControllerRole" {
  assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy.json # IAM ROLE Trust Policy
  name               = "AmazonEKSLoadBalancerControllerRole"                        # IAM ROLE
}

# Attach IAM Policy to IAM ROLE
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.AmazonEKSLoadBalancerControllerRole.name
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}

