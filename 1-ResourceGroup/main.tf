provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
    name = "my-terraform-example-rg"
    location = "centralus"
}