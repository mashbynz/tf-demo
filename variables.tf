variable "lowerlevel_storage_account_name" {}
variable "lowerlevel_container_name" {}
variable "lowerlevel_resource_group_name" {}
variable "lowerlevel_key" {}

variable "resource_groups" {
  description = "(Required) Map of the Resource Groups to create"
}

variable "rg_suffix" {
  description = "(Optional) You can use a suffix to add to the list of Resource Groups you want to create"
}

variable "tags" {
  default     = ""
  description = "(Required) tags for the deployment"
}

variable "networking_object" {
  description = "(Required) configuration object describing the networking configuration, as described in README"
}

variable "vnet_suffix" {
  description = "(Optional) You can use a suffix to add to the list of Virtual Networks you want to create"
  type        = string
}
