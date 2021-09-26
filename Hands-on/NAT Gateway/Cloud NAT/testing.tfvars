# GCP Project

gcp_project_name = "innovorder-lab"
gcp_region       = "europe-west1"
gcp_zone         = "europe-west1-c"




# VPC
vpc_name                            = "vpc-io-lab"
vpc_description                     = "description"
vpc_auto_create_subnetworks         = false
vpc_mtu                             = 1430
vpc_routing_mode                    = "REGIONAL"
vpc_delete_default_routes_on_create = false


# Subnet

subnet_name           = "subnet"
subnet_ip_cider_range = "10.1.0.0/24"
subnet_description    = "description"

