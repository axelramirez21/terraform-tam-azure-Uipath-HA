
####### RESOURCE GROUP VARIABLES########
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Resource group location"
  type        = string
}


####### PRIMARY SQL NODE ########
variable "sql_server_name" {
  description = "SQL Server name"
  type        = string
}

variable "sql_version" {
  description = "SQL Version"
  type        = string
}

variable "sql_admin_login" {
  description = "SQL Administrator login username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server Administrator password"
  type        = string
}

variable "sql_vnet_rule_name" {
  description = "SQL vnet rule"
  type        = string
}

variable "sql_subnet_id" {
  description = "SQL subnet id"
  type        = string
}

variable "sql_location" {
  description = "SQL server location"
  type        = string
}

variable "sql_orchestartor_db_name" {
  description = "SQL Orchestrator database name"
  type        = string
}

variable "sql_identity_db_name" {
  description = "SQL Identity server database name"
  type        = string
}

variable "sql_insights_db_name" {
  description = "SQL Insights database name"
  type        = string
}

variable "sql_firewall_rule_name" {
  description = "Firewall rule name"
  type        = string
}

variable "sql_firewall_start_ip" {
  description = "Firewall start IP address to whitelist"
  type        = string
}

variable "sql_firewall_end_ip" {
  description = "Firewall end IP address to whitelist"
  type        = string
}

###### tag variables######
variable "tag_owner" {
  description = "tag for the resources"
  type        = string
}

variable "tag_project" {
  description = "tag for the resources"
  type        = string
}