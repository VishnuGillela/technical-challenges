resource "azurerm_virtual_network" "vnet" {
  name = var.network_name
  resource_group_name = var.network_rg_name
  location = var.location
  address_space = var.vnet_base_cidr
  tags = var.tags
}

resource "azurerm_subnet" "subnet_with_delegation" {
  for_each = var.subnets
  name = each.key
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = var.network_rg_name
  address_prefixes = [lookup(each.value, "subnet_cidr")]
  private_endpoint_network_policies_enabled = lookup(each.value, "network_policies")
  service_endpoints = ["Microsoft.Sql", "Microsoft.Storage","Microsoft.KeyVault","Microsoft.Web"]

  delegation {
    #count = lookup(each.value, "delegation") == "" ? 1 : 0 
    name = "delegation"
    service_delegation {
      name = lookup(each.value, "delegation")
    }
  }
}

resource "azurerm_subnet" "subnet_without_delegation" {
  for_each = var.subnet_without_delegation
  name = each.key
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = var.network_rg_name
  address_prefixes = [lookup(each.value, "subnet_cidr")]
  private_endpoint_network_policies_enabled = lookup(each.value, "network_policies")
  service_endpoints = ["Microsoft.Sql", "Microsoft.Storage","Microsoft.KeyVault","Microsoft.Web"]

}