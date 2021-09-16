
locals {
  auth_rule_name = "SendAndListenAccess"
}

# Creating servicebus topic

resource "azurerm_servicebus_topic" "servicebus_topic" {
  name                = var.name
  resource_group_name = var.resource_group_name
  namespace_name      = var.namespace_name

  status                                  = var.status
  default_message_ttl                     = var.default_message_ttl
  enable_batched_operations               = var.enable_batched_operations
  enable_express                          = var.enable_express
  enable_partitioning                     = var.enable_partitioning
  max_size_in_megabytes                   = var.max_size_in_megabytes
  requires_duplicate_detection            = var.requires_duplicate_detection
  support_ordering                        = var.support_ordering
  duplicate_detection_history_time_window = var.duplicate_detection_history_time_window
}
# Creating servicebus topic authorization rule

resource "azurerm_servicebus_topic_authorization_rule" "sbt_ar" {

  name                = "${local.auth_rule_name}-ar"
  resource_group_name = var.resource_group_name
  namespace_name      = var.namespace_name
  topic_name          = azurerm_servicebus_topic.servicebus_topic.name

  listen = var.listen
  send   = var.send
  manage = var.manage

  depends_on = [azurerm_servicebus_topic.servicebus_topic]
}