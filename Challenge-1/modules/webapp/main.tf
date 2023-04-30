resource "azurerm_service_plan" "asp" {
  name = var.asp_name
  resource_group_name = var.resource_group_name
  location = var.location
  os_type = var.asp_os_type
  sku_name = var.sku
  tags = var.tags
}


resource "azurerm_windows_web_app" "windowsapp" {
  name = var.webapp_name
  resource_group_name = var.resource_group_name
  location = var.location
  service_plan_id = azurerm_service_plan.asp.id
  https_only = true
  identity {
    type = "SystemAssigned"
  }
  
  virtual_network_subnet_id = var.subnet_id
  site_config {
    minimum_tls_version = "1.2"
    vnet_route_all_enabled = true
  }
  tags = var.tags
}


resource "azurerm_private_endpoint" "appsvc" {
  name                      = var.private_link_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  subnet_id                 = var.private_link_subnet_id
  tags                      = var.tags
  
  private_service_connection {
      name                           = azurerm_windows_web_app.windowsapp.name
      private_connection_resource_id = azurerm_windows_web_app.windowsapp.id
      is_manual_connection           = false
      subresource_names              = ["sites"]
  }
}