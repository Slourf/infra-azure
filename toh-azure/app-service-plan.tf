resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.application_name}-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"

  sku {
    tier = "Standard"
    size = "S1"
  }

  reserved = true
}

resource "azurerm_app_service" "frontend_app_service" {
  name                = "${var.application_name}-frontend-app-service"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id


  site_config {
    linux_fx_version          = "DOCKER|nginx:latest"
    // use_32_bit_worker_process = true
  }

  logs {
    application_logs {
      azure_blob_storage {
        level             = "Verbose"
        sas_url           = azurerm_storage_blob.frontend_application_log_storage_blob.url
        retention_in_days = 3
      }
    }

    http_logs {
      azure_blob_storage {
        sas_url           = azurerm_storage_blob.frontend_http_log_storage_blob.url
        retention_in_days = 3
      }
    }
  }

  #app_settings = {
  #  "DOCKER_REGISTRY_SERVER_PASSWORD" = "T/Ug+o0VcQk0qVAuarVTLEk/txoQfh1V"
  #  "DOCKER_REGISTRY_SERVER_URL" = "https://tohacr.azurecr.io"
  #  "DOCKER_REGISTRY_SERVER_USERNAME" = "tohacr"
  #  "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  #}
}

resource "azurerm_app_service" "backend_app_service" {
  name                = "${var.application_name}-backend-app-service"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version          = "DOCKER|nginx:latest"
    // use_32_bit_worker_process = true

    ip_restriction {
      name = "Frontend connection"
      virtual_network_subnet_id = azurerm_subnet.frontend_subnet.id
      priority = 1
      action = "Allow"
    }

    scm_use_main_ip_restriction = true
  }

  logs {
    application_logs {
      azure_blob_storage {
        level             = "Verbose"
        sas_url           = azurerm_storage_blob.backend_application_log_storage_blob.url
        retention_in_days = 3
      }
    }

    http_logs {
      azure_blob_storage {
        sas_url           = azurerm_storage_blob.backend_http_log_storage_blob.url
        retention_in_days = 3
      }
    }
  }

  #app_settings = {
  #  "DOCKER_REGISTRY_SERVER_PASSWORD" = "T/Ug+o0VcQk0qVAuarVTLEk/txoQfh1V"
  #  "DOCKER_REGISTRY_SERVER_URL" = "https://tohacr.azurecr.io"
  #  "DOCKER_REGISTRY_SERVER_USERNAME" = "tohacr"
  #  "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  #}
}

resource "azurerm_app_service_virtual_network_swift_connection" "backend_vnet_connection" {
  app_service_id = azurerm_app_service.backend_app_service.id
  subnet_id      = azurerm_subnet.backend_subnet.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "frontend_vnet_connection" {
  app_service_id = azurerm_app_service.frontend_app_service.id
  subnet_id      = azurerm_subnet.frontend_subnet.id
}