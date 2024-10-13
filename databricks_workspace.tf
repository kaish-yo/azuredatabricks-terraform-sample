# Azure Databricks workspace
resource "azurerm_databricks_workspace" "databricks-workspace" {
  name                        = "databricks-workspace-demo"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "premium"
  managed_resource_group_name = "databricks-managed-rg"
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = azurerm_virtual_network.vnet.id
    public_subnet_name                                   = azurerm_subnet.public.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public_nsg_association.id
    private_subnet_name                                  = azurerm_subnet.private.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private_nsg_association.id
    storage_account_name                                 = "databricksprivatestorage"
  }
  tags = {
    Environment = var.environment
  }
  depends_on = [
    azurerm_subnet_network_security_group_association.private_nsg_association,
    azurerm_subnet_network_security_group_association.public_nsg_association
  ]
}
