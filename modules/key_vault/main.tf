# This creates a keyvault in the resource group specified in resource_group/main.tf.
# The secrets are also added to the vault at creation time

locals {
  full_name = trimsuffix(join("-", [var.product, var.vault_resource_name, var.environment, var.location_abbreviation, var.name_suffix]), "-")
}

# used for getting the current tenant ID
data "azurerm_client_config" "current" {}

# first create the key vault
resource "azurerm_key_vault" "keyvault" {
  name                        = local.full_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  tags                        = var.tags
}
# create an access policy to let Terraform access stuff
resource "azurerm_key_vault_access_policy" "terraform_access_policy" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["set", "get", "list", "delete"]
}
# now create access policies for the given object IDs
resource "azurerm_key_vault_access_policy" "keyvault_general" {
  for_each     = toset(var.access_policy_object_ids)
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.key

  secret_permissions = ["set", "get", "list"]
  depends_on = [
    azurerm_key_vault_access_policy.terraform_access_policy
  ]
}
# Load any secrets into the vault
resource "azurerm_key_vault_secret" "app_secret" {
  for_each = { for secret in var.keyvault_secrets : secret.name => secret }

  name         = each.value.name
  value        = each.value.value
  key_vault_id = azurerm_key_vault.keyvault.id

  tags = var.tags
}