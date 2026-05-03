variable "data_scientist" {}
variable "ml_engineer" {}
variable "mlops" {}
variable "operations" {}
variable "devops" { default = [] }
variable "devops_lead" { default = [] }
variable "rg_name" {}
variable "vnet_id" {}
variable "uai_ws" {}
variable "aisearch_instance_id" {}
# variable "nl_rg_name" {}
# variable "live_openai_rg_name" {}
# variable "live_rg_name" {}
variable "aml_id" {}
variable "name" {}
variable "kv_id" {}
# variable "live_name" {}
variable "application_insights_id" {}
variable "analytics_workspace_id" {}
variable "storage_id" {}
variable "openai_rg_id" {}
variable "lab_filter" { default = "^lab" }
variable "nl_filter" { default = "^nl" }
variable "lv_filter" { default = "^lv" }
