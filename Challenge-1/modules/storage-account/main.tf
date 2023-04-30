data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_storage_account" "storageaccount" {
  name = var.storage_account_name
  resource_group_name = var.resource_group_name
  location = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.replication_type
  account_kind                    = var.account_kind
  tags                            = var.tags
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  public_network_access_enabled   = var.public_network_access_enabled
}

resource "azurerm_storage_container" "container" {
  count                 = "${length(var.container_name_list)}"
  name                  = var.container_name_list[count.index]
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_account_network_rules" "storage" {
  storage_account_id = azurerm_storage_account.storageaccount.id

  default_action = "Deny"
  bypass         = ["Metrics", "Logging", "AzureServices"] #Allow Metrics and Logging to bypass the default action
  ip_rules = ["${chomp(data.http.myip.body)}"]
  virtual_network_subnet_ids = [var.web_subnet_id]
  depends_on = [azurerm_storage_container.container]
}
