# Challenge-1 : 3 Tier environment deployment to Azure using terraform

## Requirements (In Windows Machine)
``Terraform Version`` Terraform v1.4.6 <br />
``Azure CLI`` Latest Azure CLI

## Folder Structure
Root of the folder contains main deployment files.

**modules** - Individual modules for each resource type to keep resources standard accross organization.

**environments** - This folder contains environment specific ``tfvars`` file to provide as input for terraform execution.

## Steps to execute terraform deployment:
**Login to Azure** ``az login`` <br />
**Select Azure Subscription** ``az account set -s "subscription_id"`` <br />
**Terraform Initialize** ``terraform init`` <br />
**Terraform Plan** <br /> For DEV environment ``terraform plan -var-file="./environments/wus-dev.tfvars"`` <br />
                    For QA environment ``terraform plan -var-file="./environments/wus-qa.tfvars"`` <br />
**Terraform Apply** <br /> For DEV environment ``terraform apply -var-file="./environments/wus-dev.tfvars"`` <br />
                    For QA environment ``terraform apply -var-file="./environments/wus-qa.tfvars"`` <br />

This terraform is designed for a single application with app serivces as front end, VM in application tier and Azure SQL in database tier.

**Re-usability:** Single main.tf file with environment specific inputs are managed through respective ``tfvars`` file makes this terraform template highly reusable and also maintain same standards accross environments.

**Resources deployed In Azure** <br />
![Deployed-Resources](Challenge-1-Azure-Resources.JPG)