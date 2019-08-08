resource "azurerm_resource_group" "devvm-RG" {
  name     = "${var.name}-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}