# GCP Project
variable "gcp_project_name" {
  type    = string
  default = "innovorder-lab"
}

variable "region" {
  type    = string
  default = "europe-west1"
}


variable "zone" {
  type    = string
  default = "europe-west1-c"
}


# VPC

variable "vpc_name"{
  type    = string 
  default = "vpc-for-lab"
  description = "required "
}


variable "vpc_description"{
  type    = string 
  default = "vpc description"
  description = "optional "
}


variable "vpc_auto_create_subnetworks"{
  type    = bool 
  default = false 
  description = ""
}


variable "vpc_mtu"{
  type    = number 
  default = 1430 
}


variable "vpc_routing_mode"{
  type    = string 
  default = "REGIONAL" 
}


variable "vpc_delete_default_routes_on_create"{
  type    = bool 
  default = true  
}