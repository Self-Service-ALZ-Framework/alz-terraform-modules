##################################################
# VARIABLES                                      #
##################################################
variable "custom_role_definitions" {
  type        = map(any)
  description = "Specifies a map of custom roles"
}
variable "resource_name" {
  type        = string
  default     = ""
  description = "Name of the environment. Can be empty."
}
