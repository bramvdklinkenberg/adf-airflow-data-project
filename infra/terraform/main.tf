resource "azurerm_data_factory" "data_project_adf" {
    name                = var.project_name
    location            = var.location
    resource_group_name = var.resource_group_name
}

data "azurerm_storage_account" "humidity_data" {
    name                = var.storage_account_humiditydata_name
    resource_group_name = var.resource_group_name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "humidity_data" {
    name = var.storage_account_humiditydata_container_name
    data_factory_id = azurerm_data_factory.data_project_adf.id
    connection_string = data.azurerm_storage_account.humidity_data.primary_connection_string
}