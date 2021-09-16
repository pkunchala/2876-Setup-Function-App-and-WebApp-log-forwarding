locals {
  full_name      = trimsuffix(join("-", [var.product, "sb", var.environment, var.location_abbreviation, var.name_suffix]), "-")
  auth_rule_name = "SendAndListenAccess"

}


# Creating servicebus namespace

resource "azurerm_servicebus_namespace" "namespace" {
  name                = local.full_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sb_sku
  zone_redundant      = (var.sb_sku != "Premium" ? "false" : "true")
  capacity            = (var.sb_sku != "Premium" ? 0 : var.sb_capacity)
  tags                = var.tags
}


# Creating namespace_authorization_rule 
resource "azurerm_servicebus_namespace_authorization_rule" "sbnsar" {
  name                = "${local.auth_rule_name}-ar"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.namespace.name
  listen              = var.listen
  send                = var.send
  manage              = var.manage
  depends_on          = [azurerm_servicebus_namespace.namespace]
}
