resource azurerm_lb_backend_address_pool FWCore-ExternalLoadBalancer__FWCorepublicLBBE {
  name                = "${var.envprefix}FWCorepublicLBBE"
  resource_group_name = "${local.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.FWCore-ExternalLoadBalancer.id}"
}

resource azurerm_lb_backend_address_pool FWCore-InternalLoadBalancer__FWCore-ILB-CoreToSpokes-BackEnd {
  name                = "${var.envprefix}FWCore-ILB-CoreToSpokes-BackEnd"
  resource_group_name = "${local.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.FWCore-InternalLoadBalancer.id}"
}

resource azurerm_lb_probe FWCore-ExternalLoadBalancer__lbprobe {
  name                = "lbprobe"
  resource_group_name = "${local.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.FWCore-ExternalLoadBalancer.id}"
  protocol            = "Tcp"
  port                = "8008"
  interval_in_seconds = "5"
  number_of_probes    = "2"
}

resource azurerm_lb_probe FWCore-InternalLoadBalancer__lbprobe {
  name                = "lbprobe"
  resource_group_name = "${local.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.FWCore-InternalLoadBalancer.id}"
  protocol            = "Tcp"
  port                = "8008"
  interval_in_seconds = "5"
  number_of_probes    = "2"
}

resource azurerm_lb_rule FWCore-ExternalLoadBalancer__jumpboxRDP {
  name                           = "jumpboxRDP"
  resource_group_name            = "${local.rgname.fortigate}"
  loadbalancer_id                = "${azurerm_lb.FWCore-ExternalLoadBalancer.id}"
  frontend_ip_configuration_name = "${var.envprefix}FWCorepublicLBFE"
  protocol                       = "Tcp"
  frontend_port                  = "33890"
  backend_port                   = "33890"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.FWCore-ExternalLoadBalancer__FWCorepublicLBBE.id}"
  probe_id                       = "${azurerm_lb_probe.FWCore-ExternalLoadBalancer__lbprobe.id}"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}

resource azurerm_lb_rule FWCore-ExternalLoadBalancer__RDSGW {
  name                           = "RDSGW"
  resource_group_name            = "${local.rgname.fortigate}"
  loadbalancer_id                = "${azurerm_lb.FWCore-ExternalLoadBalancer.id}"
  frontend_ip_configuration_name = "${var.envprefix}FWCorepublicLBFE"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.FWCore-ExternalLoadBalancer__FWCorepublicLBBE.id}"
  probe_id                       = "${azurerm_lb_probe.FWCore-ExternalLoadBalancer__lbprobe.id}"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}

resource azurerm_lb_rule FWCore-InternalLoadBalancer__lbruleFE2all {
  name                           = "lbruleFE2all"
  resource_group_name            = "${local.rgname.fortigate}"
  loadbalancer_id                = "${azurerm_lb.FWCore-InternalLoadBalancer.id}"
  frontend_ip_configuration_name = "${var.envprefix}FWCore-ILB-CoreToSpokes-FrontEnd"
  protocol                       = "All"
  frontend_port                  = "0"
  backend_port                   = "0"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.FWCore-InternalLoadBalancer__FWCore-ILB-CoreToSpokes-BackEnd.id}"
  probe_id                       = "${azurerm_lb_probe.FWCore-InternalLoadBalancer__lbprobe.id}"
  enable_floating_ip             = true
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}

resource azurerm_lb FWCore-ExternalLoadBalancer {
  name                = "${var.envprefix}FWCore-ExternalLoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "${var.envprefix}FWCorepublicLBFE"
    public_ip_address_id = "${azurerm_public_ip.FWCore-ELB-PubIP.id}"
  }
  tags = "${var.tags}"
}

resource azurerm_lb FWCore-InternalLoadBalancer {
  name                = "${var.envprefix}FWCore-InternalLoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  sku                 = "Standard"
  frontend_ip_configuration {
    name               = "${var.envprefix}FWCore-ILB-CoreToSpokes-FrontEnd"
    subnet_id          = "${data.azurerm_subnet.CoreToSpokes.id}"
    private_ip_address = "100.96.116.4"
    private_ip_address_allocation = "Static"
  }
  tags = "${var.tags}"
}
