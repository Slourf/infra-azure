terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "~>0.1.0"
    }
  }
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/florianchatelus"
  personal_access_token = "uaa54eks3qyn3s4oyqib47ah2xnp4rlv3wqp7rkt5pytrpdigqqa"
}

resource "azuredevops_project" "toh" {
  name = "Tour of Heroes"
  description = "Project Tour of Heroes"
}