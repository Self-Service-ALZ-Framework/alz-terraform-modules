variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "vnet_address_space" {}
variable "hub_dns_zone_name" {}
variable "hub_rg" {}
variable "ci_subnet_create" {
  default = false
}
# variable "log_analytics_workspace_id" {}

# for compatibility with DIAS
variable "logic_apps_subnet_name" {
  default = "LogicAppsSubnet"
}