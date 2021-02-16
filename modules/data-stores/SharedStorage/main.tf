## STORAGE SHARE FOR NUGET
resource "azurerm_storage_account" "storage-account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

resource "azurerm_storage_share" "storage-share" {
  name                 = var.storage_share_name
  storage_account_name = azurerm_storage_account.storage-account.name
  quota                = var.storage_share_quota
}

resource "azurerm_storage_share_directory" "storage-shared-directory" {
  name                 = var.storage_share_name
  share_name           = azurerm_storage_share.storage-share.name
  storage_account_name = azurerm_storage_account.storage-account.name
}