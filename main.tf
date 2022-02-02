terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.94.0"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name = "TF_RG_Blobstore"
    storage_account_name = "tfstorageaccountnh"
    container_name = "tfstatefile"
    key = "terraform.tfstate" 
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "imagebuild" {
  type = string
  description = "Latest Image Build"
  
}
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "terramainrg"
  location = "southafricanorth"
}

resource "azurerm_container_group" "tfcg_test" {
    name = "weatherapi"
    location = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    ip_address_type = "public"
    dns_name_label = "nicksdockerwa"
    os_type = "Linux"

    container {
      name = "weatherapi"
      image = "nicksdockerhub/weatherapi:${var.imagebuild}"
      cpu = "1"
      memory = "1"

      ports {
          port = 80
          protocol = "TCP"
      }
    }
}