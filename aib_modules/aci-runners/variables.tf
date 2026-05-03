variable "resource_group_name" {}
variable "location" {}
variable "image" {}
variable "gh_org" {}
variable "gh_repo" {}
variable "key_vault_name" {}
variable "secret_name" {}
variable "runner_group" {}
variable "key_vault_rg" {}
variable "acr_name" {}
variable "acr_id" {}
variable "subnet_ids" {}
variable "CICD_CLIENT_ID" {
  description = "A map of environment identities to their respective client IDs"
  type        = map(string)
}
