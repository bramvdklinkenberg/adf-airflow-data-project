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

        random = {
            source = "hashicorp/random"
            version = "3.4.3"
        }
    }
}

provider "azapi" {
}

provider "azurerm" {
    features {
        key_vault {
            purge_soft_delete_on_destroy    = true
            recover_soft_deleted_key_vaults = true
        }
    }
}

provider "random" {
}