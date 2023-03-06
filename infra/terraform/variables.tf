variable "project_name" {
    type = string
}

variable "location" {
    type = string
    default = "West Europe"
}

variable "resource_group_name" {
    type = string
}

variable "storage_account_humiditydata_name" {
    type = string
    sensitive = true
}

variable "storage_account_humiditydata_container_name" {
    type = string
    sensitive = true
}

variable "postgresql_connection_string" {
    type = string
    sensitive = true
}



