variable "region" {
  type    = string
  default = "Sweden Central"
}

variable "prefix" {
  type        = string
  description = "Organization prefix for resource naming (e.g., 'myorg')"
  default     = "ssalz"
}

variable "name" {
  type = string
}

variable "program" {
  type = string
}

variable "ips" {}
variable "private_endpoint_connections" {}
variable "moderation_policy" {
  type = any
  default = {
    displayName = ""
    properties = {
      basePolicyName = "Microsoft.Default"
      type           = "UserManaged"
      # NOTE: High -> Allow low and medium. Filter on High only.
      # cannot completely remove without approval from Azure.
      # REF: https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/content-filters#undgrerstand-content-filter-configurability
      contentFilters = [
        # Sadly to turn off `blocking` We require permissions from `Azure`.
        # REF: aka.ms/oai/rai/exceptions
        # Input / output
        { name = "selfharm", blocking = true, enabled = true, allowedContentLevel = "High", source = "Prompt" },
        { name = "selfharm", blocking = true, enabled = true, allowedContentLevel = "High", source = "Completion" },
        { name = "Hate", blocking = true, enabled = true, allowedContentLevel = "High", source = "Prompt" },
        { name = "Sexual", blocking = true, enabled = true, allowedContentLevel = "High", source = "Prompt" },
        { name = "Violence", blocking = true, enabled = true, allowedContentLevel = "High", source = "Prompt" },
        { name = "Hate", blocking = true, enabled = true, allowedContentLevel = "High", source = "Completion" },
        { name = "Sexual", blocking = true, enabled = true, allowedContentLevel = "High", source = "Completion" },
        { name = "Violence", blocking = true, enabled = true, allowedContentLevel = "High", source = "Completion" },
      ]
    }
  }
}

variable "cognitive_deployments" {
  type = list(object({
    model_name    = string
    model_version = string
    capacity      = number
    sku_name      = string
    policy        = string
  }))
  description = "List of Cognitive Service Deployments to create."
  default = [
    {
      model_name    = "gpt-35-turbo-instruct"
      model_version = "0914"
      capacity      = 240
      sku_name      = "Standard"
      policy        = "aibContentFilter"
    },
    {
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      capacity      = 240
      sku_name      = "Standard"
      policy        = "aibContentFilter"
    },
    {
      model_name    = "gpt-35-turbo-16k"
      model_version = "0613"
      capacity      = 300
      sku_name      = "Standard"
      policy        = "aibContentFilter"
    },
    {
      model_name    = "gpt-4-32k"
      model_version = "0613"
      capacity      = 80
      sku_name      = "Standard"
      policy        = "aibContentFilter"
    },
    {
      model_name    = "gpt-4"
      model_version = "0613"
      capacity      = 40
      sku_name      = "Standard"
      policy        = "aibContentFilter"
    },
    {
      model_name    = "gpt-4o"
      model_version = "2024-05-13"
      capacity      = 200
      sku_name      = "Standard"
      policy        = "aibContentFilter"
    },
    {
      model_name    = "gpt-4o-mini"
      model_version = "2024-07-18"
      capacity      = 200
      sku_name      = "Standard"
      policy        = "aibContentFilter"
    }
  ]
}


