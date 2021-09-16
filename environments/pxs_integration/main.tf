terraform {
  backend "azurerm" {
    key = "pxs/integration.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}


module "phlexsubmission_integration" {
  source = "../../modules/pxr_environment"

  environment                = "int"
  location                   = "northeurope"
  location_abbreviation      = "eun"
  product                    = "pxs"
  appsvc_names               = ["jobengine", "jobservice"]
  slot_name                  = "int"
  is_production              = false
  fileshare_name             = "webapplicationlogs"
  function_language          = "dotnet"
  func_Environment           = "PhlexSubmissionQA"
  BaseDBContext              = var.BaseDBContext
  max_app_scaleout           = "10"
  acr_name                   = "phlexglobal"
  acr_username               = "phlexglobal"
  acr_password               = var.acr_password
  web_authorized_ips         = ["10.31.0.0/21"]
  web_authorized_subnet_ids  = [module.phlexsubmission_network_integration.subnets["pxs-func-subnet-int-eun"]]
  func_authorized_ips        = ["10.31.0.0/21"]
  func_authorized_subnet_ids = []
  func_vnetint_enable        = "true"
  func_subnet_id             = module.phlexsubmission_network_integration.subnets["pxs-func-subnet-int-eun"]
  servicebus = {
    topic-cunesoft-engine  = ["sub-cunesoft-engine"]
    topic-cunesoft-service = ["sub-cunesoft-service"]
  }
}

#--------------- NETWORKING----------------

module "phlexsubmission_network_integration" {
  source = "../../modules/networking"

  environment           = "int"
  location              = "northeurope"
  location_abbreviation = "eun"
  product               = "pxs"
  resource_group_name   = "rg-pxs-int-eun"
  vnet_address_space    = ["10.31.0.0/21"]
  subnet_names = [
    {
      name              = "func"
      cidr              = ["10.31.0.0/27"]
      service_endpoints = ["Microsoft.Storage"]
      subnet_delegation = {
        app-service-plan = [
          {
            name    = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
          }
        ]
      }
    },
    {
      name              = "app"
      cidr              = ["10.31.0.32/27"]
      service_endpoints = ["Microsoft.Sql"]
      subnet_delegation = {
        app-service-plan = [
          {
            name    = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
          }
        ]
      }
    }
  ]
}
#---------------END NETWORKING----------------