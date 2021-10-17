# GCP Project
variable "gcp_project_name" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}


variable "gcp_zone" {
  type    = string
  default = "europe-west1-c"
}

# GKE

variable "gke_cluster_name" {
  type        = string
  description = "GKE Cluster name"
}


variable "gke_regional" {
  type = bool
}



variable "gke_zones" {
  type        = list(string)
  description = "List of zones for the GKE Cluster"
}


# variable "gke_service_account_name" {
# type        = string
# description = "GKE service accout name"
# }



