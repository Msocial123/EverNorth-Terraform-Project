resource "helm_release" "metrics_server" {
  depends_on = [module.eks]
  # Name of the release in the cluster
  name = "metrics-server"

  # Name of the chart to install
  repository = "https://kubernetes-sigs.github.io/metrics-server/"

  # Version of the chart to use
  chart = "metrics-server"

  # Set the namespace to install the release into
  namespace = var.kubesystem_namespace

  # Recent updates to the Metrics Server do not work with self-signed certificates by default.
  # Since Docker For Desktop uses such certificates, you’ll need to allow insecure TLS
  set {
    name  = "args"
    value = "{--kubelet-insecure-tls=true}"
  }

  # Wait for the release to be deployed
  wait = true
}