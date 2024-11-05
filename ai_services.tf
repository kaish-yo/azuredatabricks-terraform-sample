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

# # Private Endpoint set for Azure AI Services
# resource "azurerm_private_endpoint" "ai_services_endpoint" {
#   name                = "ai-services-endpoint"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.others.id

#   private_service_connection {
#     name                           = "ai-services-privateserviceconnection"
#     private_connection_resource_id = azurerm_ai_services.ai_services.id
#     subresource_names              = ["account"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name                 = "ai-services-dns-zone-group"
#     private_dns_zone_ids = [azurerm_private_dns_zone.adb_private_dns_zone.id]
#   }
#   depends_on = [
#     azurerm_ai_services.ai_services,
#     azurerm_private_dns_zone.adb_private_dns_zone,
#     azurerm_subnet.others
#   ]
# }


