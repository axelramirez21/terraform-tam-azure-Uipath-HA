variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "cyberark_subnet_id" {
  description = "Location of the resource group"
  type        = string
}

variable "tag_owner" {
  description = "tag for the resources"
  type        = string
}

variable "tag_project" {
  description = "tag for the resources"
  type        = string
}

variable "tag_AlwaysPoweredOn" {
  description = "tag for the resources"
  type        = string
}

variable "dns_private_zone_name" {
  description = "Subnet ID where scaling set will be created"
  type        = string
}

variable "dns_lb_record_name" {
  description = "Subnet ID where scaling set will be created"
  type        = string
}