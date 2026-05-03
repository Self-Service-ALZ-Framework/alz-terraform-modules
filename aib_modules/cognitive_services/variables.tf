variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "vnet_id" {}
variable "storage_account_id" {}
variable "subscription_id" {}
variable "cognitive_search_sku" { default = "standard" } # free SKU does not support Private Endpoint
variable "disable_cognitive_search" { default = false }


variable "sku_name" {
  type        = string
  description = "The SKU of the Cognitive Service Account.  e.g., 'S0'"
  default     = "S0"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the resources."
  default     = {}
}
