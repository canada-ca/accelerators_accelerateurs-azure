output "publicip" {
  value = "${azurerm_public_ip.PubIP.ip_address}"
}