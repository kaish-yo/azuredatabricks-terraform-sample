resource "random_pet" "ai_services" {
  length = 4
}

resource "azurerm_ai_services" "ai_services" {
  name                  = "ai-services-demo"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  sku_name              = "S0"
  custom_subdomain_name = "ai-services-${random_pet.ai_services.id}"
  network_acls {
    default_action = "Deny"
    # ip_rules = [  ]
    virtual_network_rules {
      subnet_id = azurerm_subnet.private.id
    }
    virtual_network_rules {
      subnet_id = azurerm_subnet.public.id
    }
  }

  tags = {
    environment = var.environment
  }
  depends_on = [
    azurerm_subnet.private,
    azurerm_subnet.public
  ]
}


