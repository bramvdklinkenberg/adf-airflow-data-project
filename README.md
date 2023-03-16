# Azure Data Factory and Apache Airflow

![GitHub](https://img.shields.io/github/license/bramvdklinkenberg/my_first_data_project?style=flat-square)
![GitHub language count](https://img.shields.io/github/languages/count/bramvdklinkenberg/adf-airflow-data-project?style=flat-square)
![GitHub top language](https://img.shields.io/github/languages/top/bramvdklinkenberg/adf-airflow-data-project?style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bramvdklinkenberg/adf-airflow-data-project/terraform.yml?label=Terraform&style=flat-square)


## Project Status: Work In Progress
Currently the project is still a work in progress. I have registered multiple questions/issues with the Azure Data Factory team:
- How to get environments variables into Managed Airflow via IaC (Terraform)
- How to create an Azure Key Vault secrets backend in Managed Airflow via IaC (Terraform)
- I am unable to import DAGs from an Azure Storage Account into the Managed Airflow instance

## Introduction
In my first data [project](https://github.com/bramvdklinkenberg/my_first_data_project) I created a simple data pipeline using Github Workflows and Python Scripts that would Extract, Transform and Load data into a PostgreSQL database.In this project I will be using Azure Data Factory and Apache Airflow to create a similar data pipeline.

This project focusses on deploying Azure Data Factory and Apache Airflow using Infrastructure as Code (IaC) templates and running DAGs with the Azure managed Airflow instance. The DAGs will be simple and I will re-use the python scripts from my first data project.
Like with my first project I will also write a blog post about this project. You can find the blog post [here](https://bramvandenklinkenberg.com/2023/03/07/azure-data-factory-and-apache-airflow//).


## Prerequisites

Before we can run the pipelines we need to have some requirements in place:

- **An Azure Account**
  - If you don\'t have an Azure Account, you can create a free account by following [these](https://azure.microsoft.com/en-us/free/) instructions.
- **An Azure Storage Account**
  - If you don\'t have an Azure Storage Account, you can create one by following [these](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create) instructions in this.
- **An Azure PostgreSQL database**
  - If you don\'t have an Azure PostgreSQL database (single server), you can create one by following the instructions in this [quickstart guide](https://learn.microsoft.com/en-gb/azure/postgresql/single-server/quickstart-create-server-database-portal).
- **Hygrometer data**
  - You can checkout the format of the [CSV](./apache-airflow/data/humidity_livingroom.csv) file I exported from my hygrometer.
- **Weather API Key**
  - You can [register](https://www.visualcrossing.com/) and get an API key.
- **Github Actions Secrets**
  - You need to create the following secrets in your Github repository

## Project Structure
- **.github/workflows**: This directory contains the Github Workflows.
    - **terraform.yml**: This workflow has two jobs:
        - **terraform_plan**: This job will run [tf_plan.sh](./infra/scripts/tf_plan.sh) and uploads the plan file as artifact to Workflow run.
        - **terraform_apply**: This job will run [tf_apply.sh](./infra/scripts/tf_apply.sh), which downloads the artifact, applies the plan file and removes it after the Workflow run has finished.
- **apache-airflow**: This directory contains the Apache Airflow DAGs.
    - **dags**: This directory contains the DAGs and Python modules.
        - Work in progress
    - **data**: This directory contains the data files.
        - **humidity_livingroom.csv**: This file contains the hygrometer data.
    - **include**: This directory contains the include files.
        - **TODO**
    - **requirements.txt**: This file contains the Python requirements for the DAGs.
- **infra**: This directory contains the code to manage the Azure resources.
    - **bicep**: This directory contains the Bicep code.
        - **TODO**
    - **pulumi**: This directory contains the Pulumi code.
        - **TODO**
    - **terraform**: This directory contains the Terraform code.
        - **backend.tf**: This file contains the Terraform backend configuration.
        - **main.tf**: This file contains the Azure resources.
        - **providers.tf**: This file contains the Terraform providers.
        - **variables.tf**: This file contains the Terraform variables.
    - **scripts**: This directory contains scripts to run the IaC templates.
        - **tf_apply.sh**: This script will run the Terraform init and apply commands
        - **tf_plan.sh**: This script will run the Terraform init and plan commands
            - The state file is saved in an Azure Storage Account (see [backend.tf](./infra/terraform/backend.tf)).

## DAGs

