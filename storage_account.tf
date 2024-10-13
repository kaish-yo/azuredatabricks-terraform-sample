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
    virtual_network_subnet_ids = [
      azurerm_subnet.private.id,
      azurerm_subnet.public.id
    ]
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
