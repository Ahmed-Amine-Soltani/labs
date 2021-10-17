terraform {
  required_version = "~> 1.0.0"


  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.85.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.85.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region
}

#provider "helm" {
#kubernetes {
#token                  = data.google_client_config.client.access_token
#host                   = data.google_container_cluster.gke.endpoint
#cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
#}
#}




# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}
provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}