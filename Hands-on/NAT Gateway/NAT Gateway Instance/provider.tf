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