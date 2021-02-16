variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "bastion_subnet_id" {
  description = "Location of the resource group"
  type        = string
}

variable "bastion_public_ip_address_id" {
  description = "Location of the resource group"
  type        = string
}

variable "bastion_host_name" {
  description = "Location of the resource group"
  type        = string
}

variable "bastion_ip_configuration_name" {
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