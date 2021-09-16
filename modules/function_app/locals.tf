locals {
  full_name = trimsuffix(join("-", [var.product, "func", var.func_name, var.environment, var.location_abbreviation, var.name_suffix]), "-")
  
  app_settings = var.app_settings
  default_site_config = {
    always_on = data.azurerm_app_service_plan.plan.sku[0].tier == "Dynamic" ? false : true
  }
  site_config = merge(local.default_site_config, var.site_config)

  # App service IP Address, Subnet_ids and Service_Tag restrictions
  ip_address = [for ip_address in var.authorized_ips : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.authorized_ips, ip_address)])}"
    ip_address                = ip_address
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_ips, ip_address)])
    action                    = "Allow"
    headers                   = []
  }]

  subnets = [for subnet in var.authorized_subnet_ids : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.authorized_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.authorized_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = []
  }]

  service_tags = [for service_tag in var.service_tags_allowed : {
    name                      = "service_tag_restriction_${join("", [1, index(var.service_tags_allowed, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.service_tags_allowed, service_tag)])
    action                    = "Allow"
    headers                   = []
  }]

}
