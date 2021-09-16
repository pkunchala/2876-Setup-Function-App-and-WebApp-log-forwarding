
resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}
resource "time_rotating" "main" {
  rotation_rfc3339 = var.password_end_date
  rotation_years   = var.password_rotation_in_years
  triggers = {
    end_date = var.password_end_date
    years    = var.password_rotation_in_years
  }
}
data "azurerm_storage_account_blob_container_sas" "main" {
  connection_string = var.connection_string
  container_name    = azurerm_storage_container.storage_container.name
  https_only        = true
  start             = timestamp()
  expiry            = time_rotating.main.rotation_rfc3339
  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
  content_type        = "application/json"
}
# Service app plan for windows container OS, supported SKU are ["PC2", "PC3", "PC4"]
resource "azurerm_app_service" "appsvc" {
  name                = local.full_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = local.planid
  https_only          = var.https_only

  dynamic "site_config" {
    for_each = [merge(local.default_site_config, var.site_config)]
    content {
      always_on                            = lookup(site_config.value, "always_on", null)
      app_command_line                     = lookup(site_config.value, "app_command_line", null)
      default_documents                    = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version             = lookup(site_config.value, "dotnet_framework_version", null)
      ftps_state                           = lookup(site_config.value, "ftps_state", null)
      health_check_path                    = lookup(site_config.value, "health_check_path", null)
      http2_enabled                        = lookup(site_config.value, "http2_enabled", null)
      ip_restriction                       = concat(local.subnets, local.ip_address, local.service_tags)
      linux_fx_version                     = lookup(site_config.value, "linux_fx_version", null)
      local_mysql_enabled                  = lookup(site_config.value, "local_mysql_enabled", null)
      managed_pipeline_mode                = lookup(site_config.value, "managed_pipeline_mode", null)
      min_tls_version                      = lookup(site_config.value, "min_tls_version", null)
      python_version                       = lookup(site_config.value, "python_version", null)
      remote_debugging_enabled             = lookup(site_config.value, "remote_debugging_enabled", null)
      remote_debugging_version             = lookup(site_config.value, "remote_debugging_version", null)
      scm_type                             = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process            = lookup(site_config.value, "use_32_bit_worker_process", null)
      websockets_enabled                   = lookup(site_config.value, "websockets_enabled", null)
      windows_fx_version                   = lookup(site_config.value, "windows_fx_version", null)
      acr_use_managed_identity_credentials = lookup(site_config.value, "acr_use_managed_identity_credentials", null)
      acr_user_managed_identity_client_id  = lookup(site_config.value, "acr_user_managed_identity_client_id", null)

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", [])
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
    }
  }
  logs {
    application_logs {
      azure_blob_storage {
        level             = "Information"
        retention_in_days = 30
        sas_url           = data.azurerm_storage_account_blob_container_sas.main.sas
      }
    }
  }

  app_settings = local.env_variables
  dynamic "storage_account" {
    for_each = var.mount_points
    content {
      name         = lookup(storage_account.value, "name", format("%s-%s", storage_account.value["account_name"], storage_account.value["share_name"]))
      type         = lookup(storage_account.value, "type", "AzureFiles")
      account_name = lookup(storage_account.value, "account_name", null)
      share_name   = lookup(storage_account.value, "share_name", null)
      access_key   = lookup(storage_account.value, "access_key", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }
  identity {
    type         = var.identity_ids != null ? "UserAssigned" : "SystemAssigned"
    identity_ids = [var.identity_ids]
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      app_settings,
      site_config[0].windows_fx_version, # deployments are made outside of Terraform
      site_config[0].ip_restriction
    ]
  }
}

# Slots for app servcie
resource "azurerm_app_service_slot" "slot_name" {

  name                = local.staging_slot_name
  app_service_name    = azurerm_app_service.appsvc.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = local.planid
  https_only          = var.https_only

  app_settings = local.env_variables
  dynamic "site_config" {
    for_each = [merge(local.default_site_config, var.site_config)]
    content {
      auto_swap_slot_name                  = "production"
      always_on                            = lookup(site_config.value, "always_on", null)
      app_command_line                     = lookup(site_config.value, "app_command_line", null)
      default_documents                    = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version             = lookup(site_config.value, "dotnet_framework_version", null)
      ftps_state                           = lookup(site_config.value, "ftps_state", null)
      health_check_path                    = lookup(site_config.value, "health_check_path", null)
      http2_enabled                        = lookup(site_config.value, "http2_enabled", null)
      ip_restriction                       = concat(local.subnets, local.ip_address, local.service_tags)
      linux_fx_version                     = lookup(site_config.value, "linux_fx_version", null)
      local_mysql_enabled                  = lookup(site_config.value, "local_mysql_enabled", null)
      managed_pipeline_mode                = lookup(site_config.value, "managed_pipeline_mode", null)
      min_tls_version                      = lookup(site_config.value, "min_tls_version", null)
      python_version                       = lookup(site_config.value, "python_version", null)
      remote_debugging_enabled             = lookup(site_config.value, "remote_debugging_enabled", null)
      remote_debugging_version             = lookup(site_config.value, "remote_debugging_version", null)
      scm_type                             = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process            = lookup(site_config.value, "use_32_bit_worker_process", null)
      websockets_enabled                   = lookup(site_config.value, "websockets_enabled", null)
      windows_fx_version                   = lookup(site_config.value, "windows_fx_version", null)
      acr_use_managed_identity_credentials = lookup(site_config.value, "acr_use_managed_identity_credentials", null)
      acr_user_managed_identity_client_id  = lookup(site_config.value, "acr_user_managed_identity_client_id", null)

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", [])
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
    }
  }
  logs {
    application_logs {
      azure_blob_storage {
        level             = "Information"
        retention_in_days = 30
        sas_url           = data.azurerm_storage_account_blob_container_sas.main.sas
      }
    }
  }
  identity {
    type         = var.identity_ids != null ? "UserAssigned" : "SystemAssigned"
    identity_ids = [var.identity_ids]
  }
  lifecycle {
    ignore_changes = [
      app_settings,
      site_config[0].windows_fx_version, # deployments are made outside of Terraform
      site_config[0].ip_restriction
    ]
  }
}
# establish private connections
resource "azurerm_app_service_virtual_network_swift_connection" "swiftConnection" {
  count          = var.vnetint_enable ? 1 : 0
  app_service_id = azurerm_app_service.appsvc.id
  subnet_id      = var.subnet_id
}
