resource "azurerm_mssql_server" "sqlserver" {
  name = var.sql_server_name
  resource_group_name = var.resource_group_name
  location = var.location
  version = "12.0"
  administrator_login = "azsql_admin"
  administrator_login_password = var.admin_password
  minimum_tls_version = "1.2"
  public_network_access_enabled = var.public_network_access_enabled
  tags = var.tags
}


resource "azurerm_mssql_database" "db" {
  name = var.sql_db_name
  server_id = azurerm_mssql_server.sqlserver.id
  collation = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb = var.max_size_gb
  sku_name = var.sku_name
  geo_backup_enabled = var.geo_backup_enabled
  storage_account_type = var.storage_account_type
  tags = var.tags
}

resource "azurerm_mssql_virtual_network_rule" "service-endpoint" {
  name = "${var.sql_server_name}-vnet-rules"
  server_id = azurerm_mssql_server.sqlserver.id
  subnet_id = var.db_subnet_id
  depends_on = [azurerm_mssql_database.db]
}