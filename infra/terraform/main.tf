resource "azurerm_data_factory" "data_project_adf" {
    name                = var.project_name
    location            = var.location
    resource_group_name = var.resource_group_name
}