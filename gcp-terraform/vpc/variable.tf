# GCP Project
variable "gcp_project_name" {
  type    = string
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}


variable "gcp_zone" {
  type    = string
  default = "europe-west1-c"
}


# VPC

variable "vpc_name" {
  type        = string
  description = "required "
}


variable "vpc_description" {
  type        = string
  default     = "vpc description"
  description = "optional "
}


variable "vpc_auto_create_subnetworks" {
  type        = bool
  default     = false
  description = "optional"
}


variable "vpc_mtu" {
  type        = number
  default     = 1430
  description = "optional"
}


variable "vpc_routing_mode" {
  type        = string
  default     = "REGIONAL"
  description = "optional"
}


variable "vpc_delete_default_routes_on_create" {
  type        = bool
  default     = false
  description = "optional"
}




# Subnets
variable "subnet_name" {
  type        = string
  description = "required"
}

variable "subnet_ip_cider_range" {
  type    = string
  description = "required"
}

variable "subnet_description" {
  type    = string
  description = "optional"
}

