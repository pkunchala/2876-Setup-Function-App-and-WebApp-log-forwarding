locals {
  full_name = trimsuffix(join("-", [var.product, var.environment, var.location_abbreviation, var.name_suffix]), "-")
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.full_name}"
  location = var.location
  tags     = var.tags
}

