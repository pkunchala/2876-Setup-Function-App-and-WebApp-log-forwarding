output "function_app_name" {
  value = azurerm_function_app.function_app.name

}
output "function_app_id" {
  value = azurerm_function_app.function_app.id

}
output "function_app_connection_string" {
  value = azurerm_function_app.function_app.connection_string

}

output "identity_id" {
  value = azurerm_function_app.function_app.identity.0.principal_id
}

