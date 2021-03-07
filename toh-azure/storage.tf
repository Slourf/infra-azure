resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.application_name}storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "log_storage_container" {
  name                  = "${var.application_name}-log-storage-container"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "frontend_http_log_storage_blob" {
  name                   = "${var.application_name}-frontend-http-log-storage-blob"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.log_storage_container.name
  type                   = "Block"
}

resource "azurerm_storage_blob" "frontend_application_log_storage_blob" {
  name                   = "${var.application_name}-frontend-application-log-storage-blob"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.log_storage_container.name
  type                   = "Block"
}

resource "azurerm_storage_blob" "backend_application_log_storage_blob" {
  name                   = "${var.application_name}-backend-application-log-storage-blob"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.log_storage_container.name
  type                   = "Block"
}

resource "azurerm_storage_blob" "backend_http_log_storage_blob" {
  name                   = "${var.application_name}-backend-http-log-storage-blob"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.log_storage_container.name
  type                   = "Block"
}