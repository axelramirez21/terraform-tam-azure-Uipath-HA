variable "resource_group_name" {
  description = "Resource group name for storage deployment"
  type        = string
}

variable "resource_group_location" {
  description = "Location where you want to provision the shared storage"
  type        = string
}

variable "storage_account_name" {
  description = "Name for the storage resource name"
  type        = string
}

variable "storage_account_tier" {
  description = "The account tier for the storage Ej.Standard"
  type        = string
}

variable "storage_account_replication_type" {
  description = "The account replication type Ej.LRS"
  type        = string
}

variable "storage_share_name" {
  description = "Name for the storage share in the storage account"
  type        = string
}

variable "storage_share_quota" {
  description = "Quota for the storage share"
  type        = number
}

variable "storage_share_directory_name" {
  description = "The name for the storage share"
  type        = string
}


variable "tag_owner" {
  description = "Should be an email address tam.account@uipath.com"
  type        = string
}

variable "tag_project" {
  description = "TAM"
  type        = string
}