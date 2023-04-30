output "storage_account_uri" {
  value = azurerm_storage_account.storageaccount.primary_blob_endpoint
}