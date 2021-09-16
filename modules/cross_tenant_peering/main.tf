locals {
  full_name = trimsuffix(join("-", [var.product, "vnet", var.environment, var.location_abbreviation, var.name_suffix]), "-")
  pri_name  = "${var.peer_names[0]}-to-${var.peer_names[1]}-peering"
  sec_name  = "${var.peer_names[1]}-to-${var.peer_names[0]}-peering"
}

provider "azurerm" {
  alias = "phlexglobal"

  subscription_id      = var.subscription_ids[0]
  tenant_id            = var.tenant_id_pri
  client_id            = var.client_id_pri
  client_secret        = var.secret_pri
  auxiliary_tenant_ids = [var.tenant_id_sec]
  features {}
}

provider "azurerm" {
  alias = "cunesoft"

  subscription_id      = var.subscription_ids[1]
  tenant_id            = var.tenant_id_sec
  client_id            = var.client_id_pri
  client_secret        = var.secret_pri
  auxiliary_tenant_ids = [var.tenant_id_pri]
  features {}
}

data "azurerm_virtual_network" "vnet_pri" {
  provider = azurerm.phlexglobal

  name                = var.vnet_names[0]
  resource_group_name = var.resource_group_names[0]
}

data "azurerm_virtual_network" "vnet_sec" {
  provider = azurerm.cunesoft

  name                = var.vnet_names[1]
  resource_group_name = var.resource_group_names[1]
}

resource "azurerm_virtual_network_peering" "vnet_peer_pri" {
  name                         = local.pri_name
  resource_group_name          = var.resource_group_names[0]
  virtual_network_name         = var.vnet_names[0]
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet_sec.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways

  provider = azurerm.phlexglobal
}

resource "azurerm_virtual_network_peering" "vnet_peer_sec" {
  name                         = local.sec_name
  resource_group_name          = var.resource_group_names[1]
  virtual_network_name         = var.vnet_names[1]
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet_pri.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways

  provider = azurerm.cunesoft
}


