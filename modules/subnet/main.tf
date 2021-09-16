locals {
  full_name = trimsuffix(join("-", [var.product, var.subnet_name, "subnet", var.environment, var.location_abbreviation]), "-")
}

resource "azurerm_subnet" "subnet" {
  name                                           = local.full_name
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = var.virtual_network_name
  address_prefixes                               = var.address_prefix
  service_endpoints                              = var.service_endpoints
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint
  enforce_private_link_service_network_policies  = var.enforce_private_link_service
  dynamic "delegation" {
    for_each = var.subnet_delegation
    content {
      name = delegation.key
      dynamic "service_delegation" {
        for_each = toset(delegation.value)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}