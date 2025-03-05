resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [module.eks]
}

resource "helm_release" "argocd" {
  depends_on       = [module.eks, kubernetes_namespace.argocd, helm_release.cluster-autoscaler]
  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "5.27.3"
  namespace        = kubernetes_namespace.argocd.id
  create_namespace = false
  timeout          = "1200"
  values           = [templatefile("./argocd/install.yaml", {})]
}

# resource "null_resource" "password" {
#   provisioner "local-exec" {
#     working_dir = "./argocd"
#     command     = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
#   }
# }