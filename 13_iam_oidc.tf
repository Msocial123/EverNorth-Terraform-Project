# data "aws_eks_cluster" "demo" {
#   name = module.eks.cluster_name
# }

# data "tls_certificate" "demo" {
#  url =  data.aws_eks_cluster.demo.identity[0].oidc[0].issuer
# }

# resource "aws_iam_openid_connect_provider" "demo" {
#   client_id_list = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.demo.certificates[0].sha1_fingerprint]
#   url = data.aws_eks_cluster.demo.identity[0].oidc[0].issuer
# }

# Not required as in eks we have set enable_irsa = true