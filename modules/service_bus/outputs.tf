output "primary_connection_string" {
  value = azurerm_servicebus_namespace.namespace.default_primary_connection_string
}

output "id" {
  description = "The ID of the servicebus_namespace."
  value       = azurerm_servicebus_namespace.namespace.id
  sensitive   = true
}

output "name" {
  description = "Name of servicebus_namespace created."
  value       = azurerm_servicebus_namespace.namespace.name
  sensitive   = true
}
