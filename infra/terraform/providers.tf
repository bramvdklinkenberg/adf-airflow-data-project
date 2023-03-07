terraform {
    required_version = ">=1.3.9"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.46.0"
        }

        azapi = {
            source = "Azure/azapi"
            version = "1.4.0"
        }
    }
}

provider "azapi" {
}

provider "azurerm" {
    features {}
}
