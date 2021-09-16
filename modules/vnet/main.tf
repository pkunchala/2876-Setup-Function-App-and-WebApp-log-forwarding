locals {
  full_name = trimsuffix(join("-", [var.product, "vnet", var.environment, var.location_abbreviation, var.name_suffix]), "-")
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.full_name
  address_space       = var.network_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
