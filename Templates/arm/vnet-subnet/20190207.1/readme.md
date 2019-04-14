Template documentation:

This template will deploy vnets and associated subnets.

Updates:

20181120: Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.
20181214: Implementing new template name as template.json
20190205: Cleanup template folder

Optional subnets object parameters:

"routeTableName": Use this parameter in the desired subnets object to provide the name of an existing routetable that should be applied to the subnet. Here is an example of the parameter syntax:

    "routeTableName": "routeTable-core-to-spokes"

"dhcpOptions": Use this parameter to configure custom DNSs for the VNet served through DHCP to VMs when they are created. Add this parameter before the "subnets" parameter section. Here is an example of the parameter syntax.

    "dhcpOptions":  {
                        "dnsServers": [
                            "10.250.6.5",
                            "10.250.6.6"
                        ]
                    }
                    

VM parameters Examples:

See deploy-vnet-subnet.parameters-sample.json for examples