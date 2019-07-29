resource azurerm_lb_rule jumpboxRDP-LB-Rule {
  name                           = "jumpboxRDP"
  resource_group_name            = "${var.envprefix}-Core-FWCore-RG"
  loadbalancer_id                = "${module.fortigateap.loadbalancer_id}"
  frontend_ip_configuration_name = "${var.envprefix}FWpublicLBFE"
  protocol                       = "Tcp"
  frontend_port                  = "33890"
  backend_port                   = "33890"
  backend_address_pool_id        = "${module.fortigateap.backend_address_pool_id}"
  probe_id                       = "${module.fortigateap.probe_id}"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}

resource azurerm_lb_rule dockerweb-LB-Rule {
  name                           = "dockerweb"
  resource_group_name            = "${var.envprefix}-Core-FWCore-RG"
  loadbalancer_id                = "${module.fortigateap.loadbalancer_id}"
  frontend_ip_configuration_name = "${var.envprefix}FWpublicLBFE"
  protocol                       = "Tcp"
  frontend_port                  = "80"
  backend_port                   = "80"
  backend_address_pool_id        = "${module.fortigateap.backend_address_pool_id}"
  probe_id                       = "${module.fortigateap.probe_id}"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}