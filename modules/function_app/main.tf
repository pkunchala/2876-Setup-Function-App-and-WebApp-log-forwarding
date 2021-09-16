# Data App Service Plan
data "azurerm_app_service_plan" "plan" {
  name                = element(split("/", var.func_app_service_plan_id), 8)
  resource_group_name = var.resource_group_name
}
resource "azurerm_storage_share" "storage_fileshare" {
  name                 = var.fileshare_name
  storage_account_name = var.storage_account_name
  quota                = var.quota
}

resource "azurerm_function_app" "function_app" {

  name                       = local.full_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.func_app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  os_type                    = lower(var.os_type) == "linux" ? "linux" : null
  tags                       = var.tags
  https_only                 = var.https_only
  version                    = var.function_version

  app_settings = local.app_settings

  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      always_on                   = lookup(site_config.value, "always_on", null)
      use_32_bit_worker_process   = lookup(site_config.value, "use_32_bit_worker_process", null)
      ftps_state                  = lookup(site_config.value, "ftps_state", null)
      http2_enabled               = lookup(site_config.value, "http2_enabled", null)
      linux_fx_version            = lookup(site_config.value, "linux_fx_version", null)
      min_tls_version             = lookup(site_config.value, "min_tls_version", null)
      ip_restriction              = concat(local.subnets, local.ip_address, local.service_tags)
      pre_warmed_instance_count   = lookup(site_config.value, "pre_warmed_instance_count", null)
      scm_ip_restriction          = lookup(site_config.value, "scm_ip_restriction", null)
      scm_type                    = lookup(site_config.value, "scm_type", null)
      scm_use_main_ip_restriction = lookup(site_config.value, "scm_use_main_ip_restriction", null)
      websockets_enabled          = lookup(site_config.value, "websockets_enabled", null)
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
# establish private connections
resource "azurerm_app_service_virtual_network_swift_connection" "swiftConnection" {
  count          = var.vnetint_enable ? 1 : 0
  app_service_id = azurerm_function_app.function_app.id
  subnet_id      = var.subnet_id
}
