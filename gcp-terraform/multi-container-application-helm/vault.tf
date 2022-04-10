locals {
  lb1_prod_stats_endpoint = data.vault_generic_secret.haproxy_exporter.data.lb1_prod_stats_endpoint
  lb1_prod_stats_username = data.vault_generic_secret.haproxy_exporter.data.lb1_prod_stats_username
  lb1_prod_stats_password = data.vault_generic_secret.haproxy_exporter.data.lb1_prod_stats_password
}

data "vault_generic_secret" "multi_container_application" {
  path = "devops_lab/haproxy-exporter"
}