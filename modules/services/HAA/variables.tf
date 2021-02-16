variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "haa_subnet_id" {
  description = "Subnet ID for the virtual machine"
  type        = string
}

variable "availability_set_name" {
  description = "Availability set name"
  type        = string
}

variable "availability_set_fault_domain_count" {
  description = "Availability set Fault domain count for the VMs"
  type        = number
}

variable "availability_update_domain_count" {
  description = "Availability set update domain count for the VMs"
  type        = number
}

variable "availability_set_managed" {
  description = "Availability set update domain count for the VMs"
  type        = bool
}

variable "master_network_interface_name" {
  description = "The master network interface name"
  type        = string
}

variable "master_IP_configuration_name" {
  description = "The master IP configuration name"
  type        = string
}

variable "private_ip_allocation" {
  description = "Private Ip allocation type, dynamic or static"
  type        = string
}

variable "slave_network_interface_name" {
  description = "Slave network interface name"
  type        = string
}

variable "slave_IP_configuration_name" {
  description = "Slave IP configuration name"
  type        = string
}

variable "slave_instance_number" {
  description = "Number of slave machines to provision"
  type        = number
}

variable "master_vm_name" {
  description = "Master Virtual machine name"
  type        = string
}

variable "slave_vm_name" {
  description = "Slave Virtual Machine name"
  type        = string
}

variable "master_vm_size" {
  description = "Master Virtual machine size ej. Standard_D4s_v3"
  type        = string
}

variable "slave_vm_size" {
  description = "Slave Virtual machine size ej. Standard_D4s_v3"
  type        = string
}

variable "master_vm_username" {
  description = "Master Virtual Machine Linux username"
  type        = string
}

variable "master_vm_password" {
  description = "Master Virtual Machine password"
  type        = string
}

variable "slave_vm_username" {
  description = "Slave Virtual machine username"
  type        = string
}

variable "slave_vm_password" {
  description = "Slave Virtual Machine password"
  type        = string
}

variable "master_vm_disable_password_authentication" {
  description = "Master virtual machine disable password authentication"
  type        = bool
}

variable "slave_vm_disable_password_authentication" {
  description = "Slave virtual machine disable password authentication"
  type        = bool
}

variable "master_os_caching" {
  description = "Master virtual machine OS caching"
  type        = string
}

variable "master_storage_account_type" {
  description = "Master Virtual Machine Storage HD type"
  type        = string
}

variable "master_source_image_offer" {
  description = "Master virtual machine image offer"
  type        = string
}

variable "master_source_image_sku" {
  description = "Master virtual machine image sku"
  type        = string
}

variable "master_source_image_version" {
  description = "Master virtual machine image version"
  type        = string
}

variable "slave_os_caching" {
  description = "Slave Virtual Machine OS caching"
  type        = string
}

variable "slave_storage_account_type" {
  description = "Slave storage account HD type"
  type        = string
}

variable "master_source_image_publisher" {
  description = "Master virtual machine Image reference"
  type        = string
}

variable "slave_source_image_publisher" {
  description = "Master virtual machine Image reference"
  type        = string
}

variable "slave_source_image_offer" {
  description = "Master virtual machine image offer"
  type        = string
}

variable "slave_source_image_sku" {
  description = "Master virtual machine image sku"
  type        = string
}

variable "slave_source_image_version" {
  description = "Slave virtual machine image offer"
  type        = string
}

variable "haa-user" {
  description = "High Availability Add on username, usually it is an email address email@uipath.com"
  type        = string
}

variable "haa-password" {
  description = "High Availability Add on password"
  type        = string
}

variable "haa-license" {
  description = "High Availability Add on license number"
  type        = string
}

variable "tag_owner" {
  description = "tag for the owner, use your email"
  type        = string
}

variable "tag_project" {
  description = "tag for the project"
  type        = string
}

variable "tag_AlwaysPoweredOn" {
  description = "Tag to specify if you want the VM to be always on, this is madatory in Azure"
  type        = string
}