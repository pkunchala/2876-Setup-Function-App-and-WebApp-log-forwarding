locals {
  full_name            = trimsuffix(join("-", [var.product, var.plantype, "asp", var.environment, var.location_abbreviation, var.name_suffix]), "-")
  default_sku_capacity = var.sku["tier"] == "Dynamic" ? null : 2

}

# App Service Plan

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = local.full_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = var.kind
  reserved            = var.kind == "linux" ? true : null
  is_xenon            = var.kind == "xenon" ? true : null

  sku {
    size = lookup(var.sku, "size", null)
    tier = lookup(var.sku, "tier", null)
  }

  tags = var.tags
}




