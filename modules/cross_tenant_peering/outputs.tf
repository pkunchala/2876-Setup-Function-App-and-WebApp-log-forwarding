output "vnet_peer_pri_id" {
  description = "The id of the newly created virtual network peering in on first virtual netowork. "
  value       = azurerm_virtual_network_peering.vnet_peer_pri.id
}

output "vnet_peer_sec_id" {
  description = "The id of the newly created virtual network peering in on second virtual netowork. "
  value       = azurerm_virtual_network_peering.vnet_peer_sec.id
}