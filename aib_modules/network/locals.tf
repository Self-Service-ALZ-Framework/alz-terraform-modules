locals {
  core_services_vnet_subnets            = cidrsubnets(var.vnet_address_space, 6, 6, 5, 4, 3, 2, 1)
  cicd_runners_subnet_address_prefix    = local.core_services_vnet_subnets[0]
  logic_subnet_address_prefix           = local.core_services_vnet_subnets[1]
  proxy_subnet_address_prefix           = local.core_services_vnet_subnets[2]
  firewall_subnet_address_space         = local.core_services_vnet_subnets[3]
  bastion_subnet_address_prefix         = local.core_services_vnet_subnets[4]
  shared_services_subnet_address_prefix = local.core_services_vnet_subnets[5]
  infra_subnet_address_prefix           = local.core_services_vnet_subnets[6]
}
