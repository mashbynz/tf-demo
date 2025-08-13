terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<=1.43.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  # Configuration options
}

data "terraform_remote_state" "demo_state" {
  backend = "azurerm"
  config = {
    storage_account_name = var.lowerlevel_storage_account_name
    container_name       = var.lowerlevel_container_name
    resource_group_name  = var.lowerlevel_resource_group_name
    key                  = var.lowerlevel_key
  }
}

## Resource Group
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups

  name     = "${each.value.name}${var.rg_suffix}"
  location = each.value.location
  tags     = lookup(each.value, "tags", null) == null ? local.tags : merge(local.tags, each.value.tags)
}

## Networks
# VNet
resource "azurerm_virtual_network" "vnet" {
  for_each = var.networking_object.vnet

  name                = "${each.value.name}${var.vnet_suffix}"
  location            = each.value.location
  resource_group_name = each.value.virtual_network_rg
  address_space       = each.value.address_space
  tags                = lookup(each.value, "tags", null) == null ? local.tags : merge(local.tags, each.value.tags)

  dns_servers = lookup(each.value, "dns", null)

  dynamic "ddos_protection_plan" {
    for_each = lookup(each.value, "enable_ddos_std", false) == true ? [1] : []

    content {
      id     = each.value.ddos_id
      enable = each.value.enable_ddos_std
    }
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Other Subnets
resource "azurerm_subnet" "subnet" {
  for_each = var.networking_object.subnets

  name                 = each.value.name
  resource_group_name  = each.value.virtual_network_rg
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.cidr
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  # enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null)
  # enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", null)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []

    content {
      name = lookup(each.value.delegation, "name", null)

      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
