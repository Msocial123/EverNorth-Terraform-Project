resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
  depends_on = [module.eks]
}

#https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
resource "helm_release" "kube-prometheus" {
  depends_on = [module.eks, helm_release.metrics_server, kubernetes_namespace.prometheus, helm_release.cluster-autoscaler]
  name       = "kube-prometheus-stackr"
  namespace  = kubernetes_namespace.prometheus.id
  version    = "58.2.2"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  # values = [
  #   file("values.yaml")
  # ]
  timeout = 2000


  #   set {
  #     name  = "podSecurityPolicy.enabled"
  #     value = true
  #   }

  #   set {
  #     name  = "server.persistentVolume.enabled"
  #     value = false
  #   }

  #   # You can provide a map of value using yamlencode. Don't forget to escape the last element after point in the name
  #   set {
  #     name = "server\\.resources"
  #     value = yamlencode({
  #       limits = {
  #         cpu    = "200m"
  #         memory = "50Mi"
  #       }
  #       requests = {
  #         cpu    = "100m"
  #         memory = "30Mi"
  #       }
  #     })
  #   }

}