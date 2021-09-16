locals {
  full_name = join("", [var.product, "sa", var.sa_name, var.environment, var.location_abbreviation, var.name_suffix])
}

resource "azurerm_storage_account" "storage_account" {
  name                = local.full_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  account_kind             = "StorageV2"
  account_tier             = var.tier
  account_replication_type = var.replication_type
  allow_blob_public_access = false
}

resource "azurerm_storage_share" "storage_fileshare" {
  name                 = var.fileshare_name
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = var.quota
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}