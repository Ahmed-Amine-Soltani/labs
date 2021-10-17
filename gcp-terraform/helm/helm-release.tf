resource "helm_release" "ahmed-redis" {
  name       = "redis"
  repository = "https://ahmed-amine-soltani.github.io/innovorder-labs/multi-container-application/helm/helm-chart/redis/"
  chart      = "multi-container-redis"
  namespace  = "default"
}