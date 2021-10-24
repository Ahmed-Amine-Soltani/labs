resource "helm_release" "ahmed-redis" {
  name       = "redis"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/redis/"
  chart      = "multi-container-redis"
  namespace  = "default"
}

resource "helm_release" "ahmed-worker" {
  name       = "worker"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/worker/"
  chart      = "multi-container-worker"
  namespace  = "default"
  depends_on = [helm_release.ahmed-redis]
      values = [
    "${file("env-values-worker.yaml")}"
  ]
}

resource "helm_release" "ahmed-client" {
  name       = "client"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/client/"
  chart      = "multi-container-client"
  namespace  = "default"
}

resource "helm_release" "ahmed-postgres" {
  name       = "postgres"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/postgres/"
  chart      = "multi-container-postgres"
  namespace  = "default"

  set {
    name  = "username"
    value = "postgres"
  }
    set {
    name  = "password"
    value = "azerty123"
  }
}

resource "helm_release" "ahmed-server" {
  name       = "server"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/server/"
  chart      = "multi-container-server"
  namespace  = "default"
  depends_on = [helm_release.ahmed-postgres]

    values = [
    "${file("env-values-server.yaml")}"
  ]
}