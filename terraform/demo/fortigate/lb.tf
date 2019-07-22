resource azurerm_lb_backend_address_pool demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__DemoFWCorepublicLBBE {
  name                = "DemoFWCorepublicLBBE"
  resource_group_name = "${var.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer.id}"
}

resource azurerm_lb_backend_address_pool demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer__DemoFWCore-ILB-Demo-CoreToSpokes-BackEnd {
  name                = "DemoFWCore-ILB-Demo-CoreToSpokes-BackEnd"
  resource_group_name = "${var.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer.id}"
}

resource azurerm_lb_probe demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__lbprobe {
  name                = "lbprobe"
  resource_group_name = "${var.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer.id}"
  protocol            = "Tcp"
  port                = "8008"
  interval_in_seconds = "5"
  number_of_probes    = "2"
}

resource azurerm_lb_probe demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer__lbprobe {
  name                = "lbprobe"
  resource_group_name = "${var.rgname.fortigate}"
  loadbalancer_id     = "${azurerm_lb.demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer.id}"
  protocol            = "Tcp"
  port                = "8008"
  interval_in_seconds = "5"
  number_of_probes    = "2"
}

resource azurerm_lb_rule demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__jumpboxRDP {
  name                           = "jumpboxRDP"
  resource_group_name            = "${var.rgname.fortigate}"
  loadbalancer_id                = "${azurerm_lb.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer.id}"
  frontend_ip_configuration_name = "DemoFWCorepublicLBFE"
  protocol                       = "Tcp"
  frontend_port                  = "33890"
  backend_port                   = "33890"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__DemoFWCorepublicLBBE.id}"
  probe_id                       = "${azurerm_lb_probe.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__lbprobe.id}"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}

resource azurerm_lb_rule demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__RDSGW {
  name                           = "RDSGW"
  resource_group_name            = "${var.rgname.fortigate}"
  loadbalancer_id                = "${azurerm_lb.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer.id}"
  frontend_ip_configuration_name = "DemoFWCorepublicLBFE"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__DemoFWCorepublicLBBE.id}"
  probe_id                       = "${azurerm_lb_probe.demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer__lbprobe.id}"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}

resource azurerm_lb_rule demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer__lbruleFE2all {
  name                           = "lbruleFE2all"
  resource_group_name            = "${var.rgname.fortigate}"
  loadbalancer_id                = "${azurerm_lb.demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer.id}"
  frontend_ip_configuration_name = "DemoFWCore-ILB-Demo-CoreToSpokes-FrontEnd"
  protocol                       = "All"
  frontend_port                  = "0"
  backend_port                   = "0"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer__DemoFWCore-ILB-Demo-CoreToSpokes-BackEnd.id}"
  probe_id                       = "${azurerm_lb_probe.demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer__lbprobe.id}"
  enable_floating_ip             = true
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}

resource azurerm_lb demo-core-fwcore-rg__DemoFWCore-ExternalLoadBalancer {
  name                = "DemoFWCore-ExternalLoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "DemoFWCorepublicLBFE"
    public_ip_address_id = "${azurerm_public_ip.demo-core-fwcore-rg__DemoFWCore-ELB-PubIP.id}"
  }
  tags = "${var.tags}"
}

resource azurerm_lb demo-core-fwcore-rg__DemoFWCore-InternalLoadBalancer {
  name                = "DemoFWCore-InternalLoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  sku                 = "Standard"
  frontend_ip_configuration {
    name               = "DemoFWCore-ILB-Demo-CoreToSpokes-FrontEnd"
    subnet_id          = "${data.azurerm_subnet.Demo-CoreToSpokes.id}"
    private_ip_address = "100.96.116.4"
    private_ip_address_allocation = "Static"
  }
  tags = "${var.tags}"
}
