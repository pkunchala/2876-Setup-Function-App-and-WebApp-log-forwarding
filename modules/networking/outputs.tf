output "vnet_name" {
  value = module.vnet.name
}

output "vnet_id" {
  value = module.vnet.id
}

output "subnets" {
  value = { for s in module.subnet : "${s.subnet_name}" => s.subnet_id }
}

output "subnet_ids" {
  value = flatten([for s in module.subnet : s.subnet_id])
}