variable "location" {
  type        = string
  description = "(Required) Location for the deployment"
}

variable "local_market_shortcut" {
  type        = string
  description = "(Required) Abbreviated form of the local market, used for naming convention."
  default     = ""
}

variable "environment" {
  type        = string
  description = "(Required) Environment for the deployment"
  default     = ""
  validation {
    condition     = can(regex("^(lab|live|non-live|prd)$", var.environment))
    error_message = "Environment must be one of lab, live, non-live"
  }
}

variable "data_disk_inc" {
  type        = string
  description = "(Optional) Increment value for data disk"
  default     = ""
}

variable "key_func" {
  type        = string
  description = "Key function value to differentiate"
  default     = ""
}

variable "hub" {
  type        = string
  description = "Resource being deployed in hub"
  default     = ""
}

variable "sub" {
  type        = string
  description = "(Optional) Subscription identifier where the resources are being deployed"
  default     = ""
}

variable "subnet_cidr" {
  type        = string
  description = "(Optional) Subscription identifier where the resources are being deployed"
  default     = ""
}

variable "context" {
  type        = string
  description = "(Optional) Context identifier of which resources are being deployed"
  default     = ""
}

variable "inc" {
  type = string
  #description = "(Optional) Context identifier of which resources are being deployed"
  default = ""
}

variable "local_market" {
  type        = string
  description = "(Optional) Local market identifier for the deployment"
  default     = ""

}

variable "application_id" {
  type        = string
  description = "5-digit business service ID (e.g., 00101, 20001)"
  default     = ""
  validation {
    condition     = var.application_id == "" || can(regex("^[0-9]{5}$", var.application_id))
    error_message = "Application ID must be a 5-digit numeric code (e.g., 00101, 20001) or empty."
  }
}

variable "routing_domain" {
  type        = string
  description = "3-digit routing domain ID (e.g., 130 for DUK, 110 for DDE)"
  default     = ""
  validation {
    condition     = var.routing_domain == "" || can(regex("^[0-9]{3}$", var.routing_domain))
    error_message = "Routing domain must be a 3-digit numeric code (e.g., 130, 110) or empty."
  }
}

variable "security_zone" {
  type        = string
  description = "(Optional) security zone ID for NSG"
  default     = ""
}

variable "resource" {
  type        = string
  description = "(Optional) Resource identifier for networking resources"
  default     = ""
}

variable "subscription_id" {
  type        = string
  description = "(Optional) Subscription id where the resources are being deployed"
  default     = ""
}

variable "md5_identifier" {
  type        = string
  description = "(Optional) md5_identifier to generate unique md5 hash value for a subscription."
  default     = ""
}

variable "vnet_name_suffix" {
  type        = string
  description = "(Optional) Suffix to construct Vnet name other then hub vnet"
  default     = ""
}

variable "er_provider" {
  type        = string
  description = "(Optional) Provider for Express Route"
  default     = ""
}

variable "pip_suffix" {
  type        = string
  description = "(Optional) Provider for Public Ip Address"
  default     = ""
}

variable "location-map" {
  description = "Azure location map used for naming abbreviations"
  type        = map(any)
  default = {
    "Global"               = "glb",
    "Australia Central 2"  = "azuau2",
    "Australia Central"    = "azuauc",
    "Australia East"       = "azuaue",
    "Australia Southeast"  = "azuase",
    "australiacentral"     = "azuauc",
    "australiacentral2"    = "azuau2",
    "australiaeast"        = "azuaue",
    "australiasoutheast"   = "azuase",
    "Brazil South"         = "azubrs",
    "brazilsouth"          = "azubrs",
    "Canada Central"       = "azucac",
    "Canada East"          = "azucae",
    "canadacentral"        = "azucac",
    "canadaeast"           = "azucae",
    "Central India"        = "azucin",
    "Central US"           = "azucus",
    "centralindia"         = "azucin",
    "centralus"            = "azucus",
    "East Asia"            = "azueas",
    "East US 2"            = "azueu2",
    "East US"              = "azueus",
    "eastasia"             = "azueas",
    "eastus"               = "azueus",
    "eastus2"              = "azueu2",
    "France Central"       = "azufrc",
    "France South"         = "azufrs",
    "francecentral"        = "azufrc",
    "francesouth"          = "azufrs",
    "Germany North"        = "azugno",
    "Germany West Central" = "azugwc",
    "germanynorth"         = "azugno",
    "germanywestcentral"   = "azugwc",
    "Italy North"          = "azuitn",
    "italynorth"           = "azuitn",
    "Japan East"           = "azujae",
    "Japan West"           = "azujaw",
    "japaneast"            = "azujae",
    "japanwest"            = "azujaw",
    "Korea Central"        = "azukrc",
    "Korea South"          = "azukos",
    "koreacentral"         = "azukrc",
    "koreasouth"           = "azukos",
    "North Central US"     = "azuncu",
    "North Europe"         = "azuneu",
    "northcentralus"       = "azuncu",
    "northeurope"          = "azuneu",
    "South Africa North"   = "azusan",
    "South Africa West"    = "azusaw",
    "South Central US"     = "azuscu",
    "South India"          = "azusin",
    "southafricanorth"     = "azusan",
    "southafricawest"      = "azusaw",
    "southcentralus"       = "azuscu",
    "Southeast Asia"       = "azusea",
    "southeastasia"        = "azusea",
    "southindia"           = "azusin",
    "UAE Central"          = "azuuac",
    "UAE North"            = "azuuan",
    "uaecentral"           = "azuuac",
    "uaenorth"             = "azuuan",
    "UK South"             = "azuuks",
    "UK West"              = "azuukw",
    "uksouth"              = "azuuks",
    "ukwest"               = "azuukw",
    "West Central US"      = "azuwcus",
    "West Europe"          = "azuweu",
    "West India"           = "azuwin",
    "West US 2"            = "azuwu2",
    "West US 3"            = "azuwu3",
    "West US"              = "azuwus",
    "westcentralus"        = "azuwcus",
    "westeurope"           = "azuweu",
    "westindia"            = "azuwin",
    "westus"               = "azuwus",
    "westus2"              = "azuwu2",
    "westus3"              = "azuwu3",
    "Sweden Central"       = "azuswc",
    "swedencentral"        = "azuswc",
    "Norway East"          = "azunoe",
    "norwayeast"           = "azunoe",
    "Norway West"          = "azunow",
    "norwaywest"           = "azunow",
    "Poland Central"       = "azuplc",
    "polandcentral"        = "azuplc",
    "Switzerland North"    = "azuswn",
    "switzerlandnorth"     = "azuswn",
    "Switzerland West"     = "azusws",
    "switzerlandwest"      = "azusws",
    "Central US EUAP"      = "azucue",
    "centraluseuap"        = "azucue",
    "Israel Central"       = "azuisc",
    "israelcentral"        = "azuisc",
    "Qatar Central"        = "azuqac",
    "qatarcentral"         = "azuqac",
    "East US 2 EUAP"       = "azue2e",
    "eastus2euap"          = "azue2e",
    "Brazil Southeast"     = "azubse",
    "brazilsoutheast"      = "azubse"
  }
}

#----------------------------------------------------------
# Application Gateway related variables
#----------------------------------------------------------
variable "fe_type" {
  type        = string
  description = "(Optional) Frontend type for Application Gateway"
  default     = ""
}
variable "ip_version" {
  type        = string
  description = "(Optional) IP version for Application Gateway"
  default     = ""
}
variable "agwbe_port" {
  type        = string
  description = "(Optional) Backend port for Application Gateway"
  default     = ""
}
variable "agwhp_type" {
  type        = string
  description = "(Optional) Health probe type for Application Gateway"
  default     = ""
}
variable "agwrrl_type" {
  type        = string
  description = "(Optional) Routing rule type for Application Gateway"
  default     = ""
}
variable "agwbs_type" {
  type        = string
  description = "(Optional) Backend settings type for Application Gateway"
  default     = ""
}
variable "agwls_port" {
  type        = string
  description = "(Optional) Listener port for Application Gateway"
  default     = ""
}

variable "usage" {
  type        = string
  description = "(Optional) Usage identifier for resources like Public IP (e.g., bas, vgw, afw) or Route Table usage"
  default     = ""
}
