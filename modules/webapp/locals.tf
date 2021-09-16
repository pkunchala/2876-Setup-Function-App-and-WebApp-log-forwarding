locals {
  full_name = trimsuffix(join("-", [var.product, var.webapp_name, var.environment, var.location_abbreviation, var.name_suffix]), "-")
  planid    = var.planid
  env_variables = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_REGISTRY_SERVER_URL          = "https://${var.acr_name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME     = var.acr_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.acr_password
  }
  staging_slot_name = var.slot_name
  container_type    = upper(var.container_type)
  container_image   = "mcr.microsoft.com/azure-app-service/samples/aspnethelloworld:latest"
  container_config  = base64encode("version: '3.4'\nservices:\n")
  supported_container_types = {
    COMPOSE = true
    DOCKER  = true
    KUBE    = true
  }
  check_supported_container_types = local.supported_container_types[local.container_type]
  default_site_config = {
    always_on          = "true"
    windows_fx_version = "${local.container_type}|${local.container_type == "DOCKER" ? local.container_image : local.container_config}"

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
