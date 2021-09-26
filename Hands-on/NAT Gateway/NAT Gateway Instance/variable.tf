# GCP Project
variable "gcp_project_name" {
  type        = string
  description = ""
  default     = null
}

variable "gcp_region" {
  type        = string
  description = ""
  default     = null
}


variable "gcp_zone" {
  type        = string
  description = ""
  default     = null
}


# VPC

variable "vpc_name" {
  type        = string
  description = "required "
  default     = null
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
  type        = string
  description = "required"
}

variable "subnet_description" {
  type        = string
  description = "optional"
}


# Firewall




# main
# gcloud compute images list | grep ubuntu
variable "os" {
  type = list(object({
    centos-7        = string
    ubuntu-1604-lts = string
  }))
  default = [
    {
      centos-7        = "centos-7-v20210916"
      ubuntu-1604-lts = "ubuntu-1604-xenial-v20210429"
    }
  ]
}


# gcloud compute machine-types list | grep us-west1-a