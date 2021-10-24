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