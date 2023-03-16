data "azurerm_storage_account" "humidity_data" {
    name                = var.storage_account_humiditydata_name
    resource_group_name = var.resource_group_name
}


resource "azurerm_data_factory" "data_project_adf" {
    name                = "${var.project_name}-adf"
    location            = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "humidity_data" {
    name = var.storage_account_humiditydata_container_name
    data_factory_id = azurerm_data_factory.data_project_adf.id
    connection_string = data.azurerm_storage_account.humidity_data.primary_connection_string
}

resource "azurerm_data_factory_linked_service_postgresql" "weather_data" {
    name              = "${var.project_name}-db"
    data_factory_id   = azurerm_data_factory.data_project_adf.id
    connection_string = var.postgresql_connection_string
}

data "azurerm_key_vault" "data_project_kv" {
    name                = "${var.project_name}-kv"
    resource_group_name = var.resource_group_name
}

resource "azapi_resource" "adf_airflow" {
    type = "Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01"
    name = "${var.project_name}-adf-airflow"
    parent_id = azurerm_data_factory.data_project_adf.id
    schema_validation_enabled = false

    body = jsonencode({
        properties = {
            type = "Airflow"
            description = "Airflow integration runtime"
            typeProperties = {
                computeProperties = {
                    location = var.location
                    computeSize = var.airflow_compute_size
                    extraNodes = 0
                }
                airflowProperties = {
                    environmentVariables = {
                        project = var.project_name
                        client_id = var.client_id
                    }
                    airflowVersion = var.airflow_version
                    enableAADIntegration = true
                    airflowRequiredArguments = ["apache-airflow-providers-microsoft-azure"]
                    airflowEntityReferences = []
                    encryptedSecrets = []
                    secrets = []
                }
            }
        }
    })
}

resource "azurerm_storage_account" "airflow" {
    name                     = var.storage_account_airflow_name
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "dags" {
    name                  = var.storage_account_airflow_container_name
    storage_account_name  = azurerm_storage_account.airflow.name
    container_access_type = var.container_access_type
}

resource "azurerm_storage_blob" "dags_blob" {
    name                   = "airflow/dags/env_test_dag.py"
    storage_account_name   = azurerm_storage_account.airflow.name
    storage_container_name = azurerm_storage_container.dags.name
    type                   = "Block"
    source                 = "${var.workspace}/apache-airflow/dags/azure_data_dude/etl_dags/env_test_dag.py"
}

resource "azurerm_storage_blob" "plugins_blob" {
    name                   = "airflow/plugins/test_plugin.py"
    storage_account_name   = azurerm_storage_account.airflow.name
    storage_container_name = azurerm_storage_container.dags.name
    type                   = "Block"
    source                 = "${var.workspace}/apache-airflow/dags/azure_data_dude/etl_dags/plugins/test_plugin.py"
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "airflow_dags" {
    name = azurerm_storage_account.airflow.name
    data_factory_id = azurerm_data_factory.data_project_adf.id
    connection_string = azurerm_storage_account.airflow.primary_connection_string
}