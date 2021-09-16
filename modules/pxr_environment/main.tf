provider "azurerm" {
  alias = "phlexglobal"

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}
data "azurerm_container_registry" "acr" {
  provider = azurerm.phlexglobal

  name                = "phlexglobal"
  resource_group_name = "pxg-pxv"
}

resource "azurerm_role_assignment" "acr_role" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.identity.principal_id
}

module "resource_group" {
  source = "../resource_group"

  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  tags                  = local.tags
}

module "identity" {
  source = "../identity"

  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.name
  tags                = local.tags
  identity_name       = var.product
}
# --------- ENVIRONMENT RESOURCES ------------

module "logs_storage_account" {
  source = "../storage_account"

  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  sa_name               = "logs"
  tags                  = local.tags

  tier                = "Standard"
  replication_type    = "LRS"
  fileshare_name      = var.fileshare_name
  quota               = var.quota
  container_name      = "nlog"
  resource_group_name = module.resource_group.name
}

module "web_app_service_plan" {
  source = "../app_service_plan"

  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  plantype              = "web"
  tags                  = local.tags
  kind                  = var.appsvc_kind
  sku = {
    tier = var.appsvc_sku
    size = var.appsvc_size
  }
  resource_group_name = module.resource_group.name
}

module "func_app_service_plan" {
  source = "../app_service_plan"

  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  plantype              = "func"
  tags                  = local.tags
  kind                  = var.func_kind
  sku = {
    tier = var.func_sku
    size = var.func_size
  }
  resource_group_name = module.resource_group.name
}

module "pxr_webapps" {
  source = "../webapp"

  for_each              = toset(var.appsvc_names)
  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  acr_name              = var.acr_name
  acr_username          = var.acr_username
  acr_password          = var.acr_password
  resource_group_name   = module.resource_group.name
  tags                  = local.tags
  webapp_name           = each.key

  container_type = "DOCKER"
  planid         = module.web_app_service_plan.app_service_plan_id
  site_config = {
    authorized_ips                       = var.web_authorized_ips
    authorized_subnet_ids                = var.web_authorized_subnet_ids
    acr_use_managed_identity_credentials = "true"
    acr_user_managed_identity_client_id  = module.identity.client_id
  }
  slot_name              = var.slot_name
  storage_account_name   = module.logs_storage_account.name
  connection_string      = module.logs_storage_account.connection_string
  storage_container_name = lower("${each.key}-logs")
  identity_ids           = module.identity.id
  vnetint_enable         = var.app_vnetint_enable #"true"
  subnet_id              = var.app_subnet_id
  mount_points = [
    {
      account_name = module.logs_storage_account.name
      share_name   = module.logs_storage_account.fileshare
      access_key   = module.logs_storage_account.primary_access_key
      mount_path   = "/logs"
    }
  ]
}

module "function_app" {
  source = "../function_app"

  for_each                   = local.function_app
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  product                    = var.product
  environment                = var.environment
  tags                       = local.tags
  func_name                  = each.key
  resource_group_name        = module.resource_group.name
  storage_account_name       = module.logs_storage_account.name
  storage_account_access_key = module.logs_storage_account.primary_access_key
  func_app_service_plan_id   = module.func_app_service_plan.app_service_plan_id
  fileshare_name             = each.key
  app_settings = merge(each.value.app_settings,
    { "ConnectionString"                         = module.service_bus.primary_connection_string
      "FUNCTIONS_WORKER_RUNTIME"                 = "dotnet"
      "BlobConnectionString"                     = module.logs_storage_account.connection_string
      "BlobContainerName"                        = "nlog"
      "WEBSITE_RUN_FROM_PACKAGE"                 = "1"
      "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = module.logs_storage_account.connection_string
      "WEBSITE_CONTENTSHARE"                     = each.key
  })

  function_version = "~3"
  site_config = {
    authorized_ips        = var.func_authorized_ips
    authorized_subnet_ids = var.func_authorized_subnet_ids
  }
  os_type        = var.os_type
  vnetint_enable = var.func_vnetint_enable #"true"
  subnet_id      = var.func_subnet_id
}


module "service_bus" {
  source = "../service_bus"

  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  tags                  = local.tags
  sb_sku                = "Standard"
  sb_capacity           = "0"

  resource_group_name = module.resource_group.name
}


#  Creating Servicebus Topic 
module "servicebus_topic" {
  source   = "../service_bus_topic"
  for_each = var.servicebus

  name                  = each.key
  resource_group_name   = module.resource_group.name
  namespace_name        = module.service_bus.name
  max_size_in_megabytes = "1024"

  depends_on = [module.service_bus.name]
}

#  Creating Servicebus Subscription  
resource "azurerm_servicebus_subscription" "sb_subscription" {
  for_each = local.service_bus_map

  name                = each.value.subscription_name
  topic_name          = each.value.name
  namespace_name      = module.service_bus.name
  resource_group_name = module.resource_group.name
  max_delivery_count  = "1"

  depends_on = [module.servicebus_topic.name]
}

# --------- END ENVIRONMENT RESOURCES ------------

# --------------- APP RESOURCES ------------------

module "app_key_vault" {
  source = "../key_vault"

  vault_resource_name   = "kv" # long name is long
  location              = var.location
  location_abbreviation = var.location_abbreviation
  product               = var.product
  environment           = var.environment
  tags                  = local.tags

  resource_group_name = module.resource_group.name

  access_policy_object_ids = [
    var.devops_security_group,
    var.software_tester_security_group,
    var.developer_security_group,
    var.developer_ness_security_group
  ]

  keyvault_secrets = [

    {
      name  = "MessageBus--AzureServiceBus--ConnectionString"
      value = module.service_bus.primary_connection_string
    }
  ]
}
