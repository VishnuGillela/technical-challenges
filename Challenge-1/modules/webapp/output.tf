output "asp_id" {
  value = azurerm_service_plan.asp.id
}

output "windowsapp_id" {
 value =  azurerm_windows_web_app.windowsapp.id
}
