# Define Local Values in Terraform
locals {
  owners      = var.business_divsion
  environment = var.environment
  name        = "${var.business_divsion}-${var.environment}"
  common_tags = {
    creator                                         = local.owners
    environment                                     = local.environment
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
  }
}
