variable "container_apps" {
  type = map(object({
    url = string
    ip  = string
  }))
}
variable "name" {}
variable "vnet_id" {}
variable "resource_group_name" {}
variable "location" {}