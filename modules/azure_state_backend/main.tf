locals {
  full_name = "${var.name}-${var.environment}"
}

resource "azurerm_resource_group" "backend_rg" {
  name     = "rg-${local.full_name}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "backend_storage" {
  name                     = replace(local.full_name, "-", "") # storage account name cannot have dashes
  resource_group_name      = azurerm_resource_group.backend_rg.name
  location                 = azurerm_resource_group.backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "RAGZRS" # geo zone-redundant storage with read access in secondary region
  allow_blob_public_access = false
  tags                     = var.tags
}

resource "azurerm_storage_container" "state_container" {
  name                 = var.backend_container_name
  storage_account_name = azurerm_storage_account.backend_storage.name
}
