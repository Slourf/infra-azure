resource "azurerm_network_security_group" "network_security_group" {
  name                = "${var.application_name}-network-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.application_name}-virtual-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Developpement"
  }
}


resource "azurerm_subnet" "frontend_subnet" {
  name                 = "${var.application_name}-frontend-subnet"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name

  delegation {
    name = "${var.application_name}-frontend-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "backend_subnet" {
  name                 = "${var.application_name}-backend-subnet"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name

  delegation {
    name = "${var.application_name}-backend-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "database_subnet" {
  name                 = "${var.application_name}-database-subnet"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.3.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name


  delegation {
    name = "${var.application_name}-database-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

/*

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.application_name}-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.virtual_network.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.virtual_network.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.virtual_network.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.virtual_network.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.virtual_network.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.virtual_network.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.virtual_network.name}-rdrcfg"
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = "${var.application_name}-application-gateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "${azurerm_subnet.frontend_subnet.name}-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend_subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
*/