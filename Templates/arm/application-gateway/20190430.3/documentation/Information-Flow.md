#### NIST Control(s): 
AC-4

# Implementation and Configuration
This template uses Web Application Firewall Mode to enforce information flow throughout the architecture.  This template should be used with NSG's, Routing, Firewall and VNet to meet this control.  The following WAF rules can be configured:

#### WAF - Application Gateway

+ **WAF**:Deploys Application Gateway with WAF turned on in prevention mode with OWASP rulest 3.0
+ **WAF**:Deploys Application Gateway with WAF turned on to accept incloning requests only on SSL/TLS on Port 443
+ **WAF**:Configures Backend Pools for the Application Gateway to communicate only on Ports 80 and 443 for the ASE ILB IP addresses

# Compliance Documentation
**AC-4: The information system enforces approved authorizations for controlling the flow of information within the system and between interconnected systems based on [Assignment: organization-defined information flow control policies]. Information flow control regulates where information is allowed to travel within an information system and between information systems (as opposed to who is allowed to access the information) and without explicit regard to subsequent accesses to that information. Flow control restrictions include, for example, blocking outside traffic that claims to be from within the organization, restricting web requests to the Internet that are not from the internal web proxy server. Enforcement occurs, for example, in boundary protection devices (e.g., gateways, routers, guards, encrypted tunnels, firewalls) that employ rule sets or establish configuration settings that restrict information system services, provide a packet-filtering capability based on header information, or message-filtering capability based on message content (e.g., implementing key word searches or using document characteristics).**

This template enforces information flow restrictions through the deployment and application of the Azure Application Gateway and its Web Application Firewall (WAF) mode.  See the configuration for WAF above.