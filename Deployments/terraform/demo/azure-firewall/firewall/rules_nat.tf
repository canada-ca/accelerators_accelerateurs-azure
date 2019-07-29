resource "azurerm_firewall_nat_rule_collection" "firewall" {
  name                = "testcollection"
  azure_firewall_name = "${var.envprefix}-FW-firewall"
  resource_group_name = "${var.envprefix}-Core-NetCore-RG"
  priority            = 100
  action              = "Dnat"

  rule {
    name = "docker80"
    source_addresses = [ "*",  ]
    destination_addresses = [ "${module.fortigateap.fwpubip}", ]
    translated_address = "10.250.128.4"
    destination_ports = [ "80", ]
    translated_port    = "80"
    protocols = [ "TCP", ]
  }
  rule {
    name = "jumpboxRDS"
    source_addresses = [ "*",  ]
    destination_addresses = [ "${module.fortigateap.fwpubip}", ]
    translated_address = "100.96.120.4"
    destination_ports = [ "33890", ]
    translated_port    = "3389"
    protocols = [ "TCP", ]
  }

  depends_on = ["azurerm_firewall_network_rule_collection.firewall"]
}
