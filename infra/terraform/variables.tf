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

variable "storage_account_airflow_name" {
    type = string
    sensitive = true
}

variable "storage_account_airflow_container_name" {
    type = string
}

variable "container_access_type" {
    type = string
    default = "private"
}

variable "client_id" {
    type = string
    sensitive = true
}

variable "client_secret" {
    type = string
    sensitive = true
}

variable "tenant_id" {
    type = string
    sensitive = true
}

variable "subscription_id" {
    type = string
    sensitive = true
}

variable "airflow_compute_size" {
    type = string
    default = "Small"
}

variable "airflow_version" {
    type = string
    default = "2.4.3"
}
