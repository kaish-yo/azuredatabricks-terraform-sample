variable "resource_group_location" {
  type        = string
  default     = "japaneast"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "adb-terraform-test"
  description = "Name of the resource group."
}

variable "environment" {
  type        = string
  default     = "Development"
  description = "Environment of the resource."
}

variable "vnet_name" {
  type        = string
  default     = "adbvirtualnetwork"
  description = "Name of the virtual network."
}

variable "allowed_ip_list" {
  type    = list(string)
  default = []
}
