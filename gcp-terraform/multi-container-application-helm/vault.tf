locals {
  postgres_password = data.vault_generic_secret.multi_container_application.data.API_PASSWORD
}

data "vault_generic_secret" "multi_container_application" {
  path = "devops_lab/rds_api"
}