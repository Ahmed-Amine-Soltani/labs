terraform {
    required_version = ">= 0.12"
    required_providers {
        source = "hashicorp/google"
        
    }
    

} 
# GCP provider
provider "google" {
  credentials = file(var.key)
  project     = var.google_project
  region      = var.region
  zone        = var.zone
}   ￼