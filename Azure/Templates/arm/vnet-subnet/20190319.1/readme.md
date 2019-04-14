Template documentation:

This template will deploy vnets and associated subnets.

Updates:

20181120: Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.
20181214: Implementing new template name as template.json
20190205: Cleanup template folder
20190302: Transformed the template to be resourcegroup deployed rather than subscription level deployed.
20190313: Adding support for subnet NSG as an option.

Optional subnets object parameters:

"routeTableName": Use this parameter in the desired subnets object to provide the name of an existing routetable that should be applied to the subnet. Here is an example of the parameter syntax:

    "routeTableName": "routeTable-core-to-spokes"

"networkSecurityGroupName": Use this parameter in the desired subnets object to provide the name of an existing NSG that should be applied to the subnet. Here is an example of the parameter syntax:

    "networkSecurityGroupName": "nsgName"

"dhcpOptions": Use this parameter to configure custom DNSs for the VNet served through DHCP to VMs when they are created. Add this parameter before the "subnets" parameter section. Here is an example of the parameter syntax.

    "dhcpOptions":  {
                        "dnsServers": [
                            "10.250.6.5",
                            "10.250.6.6"
                        ]
                    }
                    

VM parameters Examples:

See deploy-vnet-subnet.parameters-sample.json for examples