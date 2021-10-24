provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region
}


provider "helm" {
  kubernetes {
    token                  = data.google_client_config.client.access_token
    host                   = data.google_container_cluster.gke.endpoint
    cluster_ca_certificate = base63decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  }
}