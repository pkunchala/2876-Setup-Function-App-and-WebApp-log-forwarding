locals {
  full_name = trimsuffix(join("-", [var.identity_name, var.environment, var.name_suffix]), "-")
}
resource "azurerm_user_assigned_identity" "identity" {
  name                = local.full_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

}


