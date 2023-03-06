data "azurerm_storage_account" "humidity_data" {
    name                = var.storage_account_humiditydata_name
    resource_group_name = var.resource_group_name

}

output "storage_connection_string" {
    value = "${data.azurerm_storage_account.humidity_data.primary_connection_string}"
}
