resource "google_compute_network" "vpc_network" {
  project                         = var.gcp_project_name
  name                            = var.vpc_name
  description                     = var.vpc_description
  auto_create_subnetworks         = var.vpc_auto_create_subnetworks
  mtu                             = var.vpc_mtu
  routing_mode                    = var.vpc_routing_mode
  delete_default_routes_on_create = var.vpc_delete_default_routes_on_create
}


resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "test-subnetwork"
  ip_cidr_range = var.subnet_ip_cider_range
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
}