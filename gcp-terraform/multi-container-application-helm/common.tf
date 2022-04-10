terraform {
  required_version = "~> 1.0.0"

  backend "gcs" {
    bucket = "innovorder-terraform"
    prefix = "infrastructure/google/multi-container-application-pfe-ahmed"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.85.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.85.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.24.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.13.0"
    }
  }
}



data "google_client_config" "current" {}

data "google_container_cluster" "gke_app" {
  name     = "gke-app-${terraform.workspace}"
  location = "europe-west1"
}

provider "google" {
  region  = "europe-west1"
  project = "innovorder-${terraform.workspace}"
}

provider "google-beta" {
  region  = "europe-west1"
  project = "innovorder-${terraform.workspace}"
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.gke_app.endpoint}"
    token                  = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.gke_app.master_auth.0.cluster_ca_certificate)
  }
}
provider "vault" {
  # The following environment variables should be set:
  # VAULT_ADDR=https://vault.example.net:8200 for example
  # VAULT_TOKEN=
}

provider "kubectl" {
  host                   = "https://${data.google_container_cluster.gke_app.endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke_app.master_auth.0.cluster_ca_certificate)
}