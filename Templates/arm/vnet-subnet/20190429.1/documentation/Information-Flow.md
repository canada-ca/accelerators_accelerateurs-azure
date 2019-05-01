#### NIST Control(s): 
AC-4

# Implementation and Configuration
This template can be configured to split vnets and subnets into there own logical boundries following ITSG-22 guidence.  This template should be used in conjunction with NSG's, Routing, Firewall and/or the Application Gateway to meet this control.

#### Network
+ **Azure VNET**: Provisioned with separate subnet for each individual tier

# Compliance Documentation
**AC-4: The information system enforces approved authorizations for controlling the flow of information within the system and between interconnected systems based on [Assignment: organization-defined information flow control policies]. Information flow control regulates where information is allowed to travel within an information system and between information systems (as opposed to who is allowed to access the information) and without explicit regard to subsequent accesses to that information. Flow control restrictions include, for example, blocking outside traffic that claims to be from within the organization, restricting web requests to the Internet that are not from the internal web proxy server. Enforcement occurs, for example, in boundary protection devices (e.g., gateways, routers, guards, encrypted tunnels, firewalls) that employ rule sets or establish configuration settings that restrict information system services, provide a packet-filtering capability based on header information, or message-filtering capability based on message content (e.g., implementing key word searches or using document characteristics).**

This template can be used to logically speprate vnets and subnets to support forced routing, NSG's and firewall flows. 