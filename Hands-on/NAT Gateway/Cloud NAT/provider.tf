terraform {
  required_version = "~> 1.0.0"

  backend "remote" {
    hostname = "app.terraform.innovorder"
    organization = "my-org"

  workspaces {
    name = "my-workspace-innovorder-lab"

  }


  }



  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.48.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.48.0"
    }
  }
}

provider "google" {
  region  = "europe-west1"
  project = "innovorder-${terraform.workspace}"
}

provider "google-beta" {
  region  = "europe-west1"
  project = "innovorder-${terraform.workspace}"
}


provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region
}