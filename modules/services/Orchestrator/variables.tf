variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "orchestrator_subnet_id" {
  description = "Subnet ID where scaling set will be created"
  type        = string
}

variable "dns_lb_record_name" {
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

#Orchestrator/windows variables
variable "set_local_adminpass" {
  description = "Admin pass for windows"
  type = string
}

variable "admin_password" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_local_account_role" {
  description = "Admin pass for windows"
  type = string
}

variable "vm_size" {
  description = "Admin pass for windows"
  type = string
}

variable "vm_username" {
  description = "Admin pass for windows"
  type = string
}

variable "vm_password" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_version" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_passphrase" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_databaseservername" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_databasename" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_databaseusername" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_databaseuserpassword" {
  description = "Admin pass for windows"
  type = string
}

variable "orchestrator_orchestratoradminpassword" {
  description = "Admin pass for windows"
  type = string
}

variable "haa_master_network_ip" {
  description = "Admin pass for windows"
  type    = string
}

variable "haa-password" {
  description = "Admin pass for windows"
  type = string
}

