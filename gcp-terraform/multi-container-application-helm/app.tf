#resource "helm_release" "ahmed-redis" {
#name       = "redis"
#repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/redis/"
#chart      = "multi-container-redis"
#namespace  = "default"
#}

resource "helm_release" "ahmed-worker" {

  name             = "worker"
  repository       = "https://ahmed-amine-soltani.github.io/labs/multi-container-application/helm/helm-chart/worker"
  chart            = "multi-container-worker"
  namespace        = "default"
  create_namespace = true

  values = [
    "${file("${path.root}/templates/worker-values.yaml.tpl")}"
  ]
}

resource "helm_release" "ahmed-client" {
  name       = "client"
  repository = "https://ahmed-amine-soltani.github.io/labs/multi-container-application/helm/helm-chart/client"
  chart      = "multi-container-client"
  namespace  = "default"

  values = [
    "${file("${path.root}/templates/client-values.yaml.tpl")}"
  ]
}

resource "helm_release" "ahmed-server" {
  name             = "server"
  repository       = "https://ahmed-amine-soltani.github.io/labs/multi-container-application/helm/helm-chart/server"
  chart            = "multi-container-server"
  namespace        = "default"
  create_namespace = true

  values = [
    templatefile(
      "${path.root}/templates/server-values.yaml.tpl",
      {
        postgres_password = local.postgres_password
      }
    )
  ]
}

resource "kubectl_manifest" "ingress" {
  depends_on       = [helm_release.ahmed-server,helm_release.ahmed-client]

  yaml_body = templatefile("${path.root}/templates/ingress.yaml.tpl",
    {
      client_service_name = "client-service"
      server_service_name = "server-service"
    }
  )
}