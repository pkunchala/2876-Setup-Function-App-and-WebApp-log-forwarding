output "webapp_id" {
  value       = azurerm_app_service.appsvc.id
  description = "The ID of the web app."
}
output "webapp_name" {
  value       = azurerm_app_service.appsvc.name
  description = "The name of the web app."
}
output "sas_url" {
  value = data.azurerm_storage_account_blob_container_sas.main.sas
  sensitive = true
}

output "outbound_ips" {
  value       = split(",", azurerm_app_service.appsvc.outbound_ip_addresses)
  description = "A list of outbound IP addresses for the App Service."
}

output "possible_outbound_ips" {
  value       = split(",", azurerm_app_service.appsvc.possible_outbound_ip_addresses)
  description = "A list of possible outbound IP addresses for the App Service. Superset of outbound_ips."
}