resource "azurerm_sql_server" "sql-server" {
  resource_group_name          = var.resource_group_name
  name                         = var.sql_server_name
  location                     = var.sql_location
  version                      = var.sql_version
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}


resource "azurerm_sql_database" "uipath-db" {
  name                = var.sql_orchestartor_db_name
  resource_group_name = azurerm_sql_server.sql-server.resource_group_name
  location            = azurerm_sql_server.sql-server.location
  server_name         = azurerm_sql_server.sql-server.name
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

resource "azurerm_sql_database" "identity-db" {
  name                = var.sql_identity_db_name
  resource_group_name = azurerm_sql_server.sql-server.resource_group_name
  location            = azurerm_sql_server.sql-server.location
  server_name         = azurerm_sql_server.sql-server.name
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

resource "azurerm_sql_database" "insights-db" {
  name                = var.sql_insights_db_name
  resource_group_name = azurerm_sql_server.sql-server.resource_group_name
  location            = azurerm_sql_server.sql-server.location
  server_name         = azurerm_sql_server.sql-server.name
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

resource "azurerm_sql_virtual_network_rule" "sql_vnet_rule" {
  name                = var.sql_vnet_rule_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql-server.name
  subnet_id           = var.sql_subnet_id
}


resource "azurerm_sql_firewall_rule" "primary" {
  name                = var.sql_firewall_rule_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql-server.name
  start_ip_address    = var.sql_firewall_start_ip
  end_ip_address      = var.sql_firewall_end_ip
}