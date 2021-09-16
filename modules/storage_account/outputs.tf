output "connection_string" {
  value = azurerm_storage_account.storage_account.primary_connection_string
}

output "primary_access_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
}
output "name" {
  value = azurerm_storage_account.storage_account.name
}
output "id" {
  value = azurerm_storage_account.storage_account.id
}
output "fileshare" {
  value = azurerm_storage_share.storage_fileshare.name
}
output "container" {
  value = azurerm_storage_container.container.name
}