locals {
  tags = {
    environment = lower(var.environment)
    owner       = "devops"
    service     = "phlexrim"
    location    = lower(var.location)
    costcentre  = lower(var.cost_centre)
  }
  subnets     = var.subnet_names
  subnetnames = { for subnet in local.subnets : subnet.name => subnet }
}
module "vnet" {
  source = "../vnet"

  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  tags                  = local.tags

  resource_group_name = var.resource_group_name
  network_address_space  = var.vnet_address_space
}
#-------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/servie network policies, service endpoints and Deligation.
#--------------------------------------------------------------------------------------------------------
module "subnet" {
  source                = "../subnet"
  for_each              = local.subnetnames
  subnet_name           = each.key
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  resource_group_name   = var.resource_group_name
  virtual_network_name  = module.vnet.name

  address_prefix                = each.value.cidr
  service_endpoints             = lookup(each.value, "service_endpoints", [])
  subnet_delegation             = lookup(each.value, "subnet_delegation", {})
  enforce_private_link_endpoint = lookup(each.value, "enforce_private_link_endpoint", false)
}