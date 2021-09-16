# use the local backend because we won't have one yet...
terraform {
  backend "local" {}
}

# set up aliased providers for prod and dev
provider "azurerm" {
  alias = "dev"

  subscription_id = var.dev_subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.dev_client_id
  client_secret   = var.dev_client_secret

  features {}
}


# now create the state backends for  dev using the module
module "dev_state_backend" {
  source = "../modules/azure_state_backend"
  providers = {
    azurerm = azurerm.dev
  }

  name        = "tfstate-pxr"
  location    = "North Europe"
  environment = "dev"
  tags = {
    owner       = "devops"
    environment = "dev"
    product     = "phlexrim"
    service     = "terraform"
    name        = "statebackend"
  }
}
