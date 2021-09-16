
output "id" {
  description = "The ID of the servicebus_topic."
  value       = azurerm_servicebus_topic.servicebus_topic.id

}

output "name" {
  description = "Name of servicebus_topic created."
  value       = azurerm_servicebus_topic.servicebus_topic.name

}

output "primary_connection_string" {
  description = "Name of servicebus_topic created."
  value       = azurerm_servicebus_topic_authorization_rule.sbt_ar.primary_connection_string

}

output "secondary_connection_string" {
  description = "Name of servicebus_topic created."
  value       = azurerm_servicebus_topic_authorization_rule.sbt_ar.secondary_connection_string

}
# primary shared access key with send and listen rights
output "primary_send_and_listen_shared_access_key" {
  value = azurerm_servicebus_topic_authorization_rule.sbt_ar.primary_key
}

# secondary shared access key with send and listen rights
output "secondary_send_and_listen_shared_access_key" {
  value = azurerm_servicebus_topic_authorization_rule.sbt_ar.secondary_key
}