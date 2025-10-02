variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "azure-proxy-rg1"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "vnet_address_space" {
  description = "VNet address spaces"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vm_name" {
  description = "WireGuard VM name"
  type        = string
  default     = "azure-proxy-server"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2ats_v2"
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
  default     = "azureuser"
}

variable "client_count" {
  description = "Number of WireGuard clients"
  type        = number
  default     = 1
}

variable "vpn_ipv4_cidr" {
  description = "WireGuard tunnel IPv4 CIDR"
  type        = string
  default     = "10.10.0.0/24"
}

variable "tags" {
  description = "Azure resource tags"
  type        = map(string)
  default     = {}
}