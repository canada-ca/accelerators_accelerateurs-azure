Template parameter documentation:

Updates:

20181120: Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.
20181214: Implementing new template name as template.json
20190205: Cleanup template folder
20190302: Transformed the template to be resourcegroup deployed rather than subscription level deployed.
20190323: Adding a short sleep delay to help with issues due to azure starting peering before vnets are fully deployed.
**20190425:** Add support for optional subscriptionId parameter to support peering across subscriptions

Optional:

"subscriptionId": Add this parameter in the Peer array object to peer across subscription. When peering inside the same subscription this parameter is not needed. An example of the use of this parameter is:

            "peer": [
                        {
                            "vnetName": "PwS2-validate-vnet-peering-2-VNET",
                            "rgName": "PwS2-validate-vnet-peering-2-RG",
                -->         "subscriptionId": "sddfsd",     <--
                            "allowVirtualNetworkAccess": true,
                            "allowForwardedTraffic": true,
                            "allowGatewayTransit": true,
                            "useRemoteGateways": false
                        }
                    ]