resource "helm_release" "ahmed-redis" {
  name       = "redis"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/redis/"
  chart      = "multi-container-redis"
  namespace  = "default"
}

resource "helm_release" "ahmed-worker" {

  depends_on = [helm_release.ahmed-redis]
  name       = "worker"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/worker/"
  chart      = "multi-container-worker"
  namespace = "default"
  create_namespace = true

  values = [
    "${file("env-values-worker.yaml")}"
  ]
}

resource "helm_release" "ahmed-client" {
  name       = "client"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/client/"
  chart      = "multi-container-client"
  namespace  = "default"

  values = [
    "${file("env-values-worker.yaml")}"
  ]
}

resource "helm_release" "ahmed-server" {

  depends_on = [helm_release.ahmed-postgres]
  name       = "server"
  repository = "http://charts.sandermann.cloud" #https://github.com/ksandermann/helm-charts/tree/master/haproxy-exporter
  chart      = "multi-container-server"
  namespace = "default"
  create_namespace = true

  values = [
    templatefile(
      "${path.root}/templates/server-values.yaml.tpl",
      {
        haproxy_exporter_image_tag = var.haproxy_exporter_image_tag
      }
    )
  ]
}