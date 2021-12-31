terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.90.0"
        }
    }
    backend "azurerm" {
        resource_group_name = "tf_rg_blobstorage"
        storage_account_name = "tfstoragerolfe"
        container_name = "tfstatefile"
        key = "terraform.tfstate"
    }
}

provider "azurerm" {
    features {}
}

variable "imagebuild" {
    description = "Latest image build"
    type = "string"
}

resource "azurerm_resource_group" "tf_test" {
    name     = "tfmaingp"
    location = "West US"
}

resource "azurerm_container_group" "tfcg_test" {
    location            = azurerm_resource_group.tf_test.location
    name                = "weatherapi"
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type = "public"
    dns_name_label = "rolfeconsulting"
    os_type = "Linux"

    container {
        cpu    = "1"
        image  = "rolfeconsulting/weatherapi:${var.imagebuild}"
        memory = "1"
        name   = "weatherapi"

        ports {
            port = 80
            protocol = "TCP"
        }
    }
}