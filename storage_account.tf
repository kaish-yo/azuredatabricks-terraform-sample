# resource "random_pet" "storage_account" {
#   prefix = "databrickspublicstorage"
#   length = 1
# }

resource "azurerm_storage_account" "storage_account" {
  name                = "databrickspublicstorage"
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules       = var.allowed_ip_list
    # virtual_network_subnet_ids = [
    #   azurerm_subnet.private.id,
    #   azurerm_subnet.public.id
    # ]
  }

  tags = {
    environment = var.environment
  }
  depends_on = [
    azurerm_subnet.private,
    azurerm_subnet.public,
    # random_pet.storage_account
  ]
}

resource "azurerm_storage_container" "test" {
  name                  = "test"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

# Private Endpoint set for Storage Account
resource "azurerm_private_endpoint" "storage_account_endpoint" {
  name                = "storage-account-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.others.id

  private_service_connection {
    name                           = "storage-account-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-account-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.adb_private_dns_zone.id]
  }
  depends_on = [
    azurerm_storage_account.storage_account,
    azurerm_private_dns_zone.adb_private_dns_zone,
    azurerm_subnet.others
  ]
}
