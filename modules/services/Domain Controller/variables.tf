variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}


############# VARIABLES IN ALL MODULES WITH VMS #############################
variable "network_interface_name" {
  description = "The network interface name"
  type        = string
}

variable "IP_configuration_name" {
  description = "The master IP configuration name"
  type        = string
}

variable "private_ip_allocation" {
  description = "Private Ip allocation type, dynamic or static"
  type        = string
}

variable "private_ip_address" {
  description = "The Static IP address that will need to be added to the VNET for domain controller"
  type        = string
}

variable "vm_name" {
  description = "Virtual machine name"
  type        = string
}

variable "vm_size" {
  description = "Virtual machine size ej. Standard_D4s_v3"
  type        = string
}

variable "vm_username" {
  description = "Virtual Machine Linux username"
  type        = string
}

variable "vm_password" {
  description = "Virtual Machine password"
  type        = string
}

variable "os_caching" {
  description = "virtual machine OS caching"
  type        = string
}

variable "storage_account_type" {
  description = "Virtual Machine Storage HD type"
  type        = string
}

variable "source_image_publisher" {
  description = "virtual machine Image reference"
  type        = string
}

variable "source_image_offer" {
  description = "virtual machine image offer"
  type        = string
}

variable "source_image_sku" {
  description = "virtual machine image sku"
  type        = string
}

variable "source_image_version" {
  description = "virtual machine image offer"
  type        = string
}

############# VARIABLES IN ALL MODULES WITH VMS #############################

variable "dc_subnet_id" {
  description = "Subnet ID where scaling set will be created"
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

