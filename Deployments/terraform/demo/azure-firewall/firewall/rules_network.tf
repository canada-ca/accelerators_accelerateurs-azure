resource "azurerm_firewall_network_rule_collection" "firewall" {
  name                = "testcollection"
  azure_firewall_name = "${var.envprefix}-FW-firewall"
  resource_group_name = "${var.envprefix}-Core-NetCore-RG"
  priority            = 100
  action              = "Allow"

  rule {
    name = "all"
    source_addresses = ["*",]
    destination_ports = ["*",]
    destination_addresses = ["*",]
    protocols = [ "Any"]
  }

  depends_on = ["module.fortigateap"]
}