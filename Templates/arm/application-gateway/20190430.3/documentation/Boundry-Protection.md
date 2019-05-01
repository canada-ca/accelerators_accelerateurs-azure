#### NIST Controls / ITSG-33 Controls
AC-17 (3), SC-5, SC-7.a, SC-7.b, SC-7.c, SC-7 (3), SC-7 (5), SC-7 (11)

## Recommended Implementation and Configuration
- WAF Mode: Prevention
- WAF Rule Set Type: OWASP
- WAF Rule Set Version: 3.0
  - REQUEST-910-IP-REPUTATION	Contains rules to protect against known spammers or malicious activity.
  - REQUEST-911-METHOD-ENFORCEMENT	Contains rules to lock down methods (PUT, PATCH< ..)
  - REQUEST-912-DOS-PROTECTION	Contains rules to protect against Denial of Service (DoS) attacks.
  - REQUEST-913-SCANNER-DETECTION	Contains rules to protect against port and environment scanners.
  - REQUEST-920-PROTOCOL-ENFORCEMENT	Contains rules to protect against protocol and encoding issues.
  - REQUEST-921-PROTOCOL-ATTACK	Contains rules to protect against header injection, request smuggling, and response splitting
  - REQUEST-930-APPLICATION-ATTACK-LFI	Contains rules to protect against file and path attacks.
  - REQUEST-931-APPLICATION-ATTACK-RFI	Contains rules to protect against Remote File Inclusion (RFI)
  - REQUEST-932-APPLICATION-ATTACK-RCE	Contains rules to protect again Remote Code Execution.
  - REQUEST-933-APPLICATION-ATTACK-PHP	Contains rules to protect against PHP injection attacks.
  - REQUEST-941-APPLICATION-ATTACK-XSS	Contains rules for protecting against cross site scripting.
  - REQUEST-942-APPLICATION-ATTACK-SQLI	Contains rules for protecting against SQL injection attacks.
  - REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION	Contains rules to protect against Session Fixation Attacks.

## Compliance Documentation

**AC-17 (3): The information system routes all remote accesses through organization-defined number of managed network access control points.**
This template deploys an Application Gateway that can be used to route all web application traffic through.  It includes a web application firewall and load balancing capabilities.

**SC-5: The information system protects against or limits the effects of the following types of denial of service attacks: organization-defined types of denial of service attacks or references to sources for such information by employing organization-defined security safeguards. A variety of technologies exist to limit, or in some cases, eliminate the effects of denial of service attacks. For example, boundary protection devices can filter certain types of packets to protect information system components on internal organizational networks from being directly affected by denial of service attacks. Employing increased capacity and bandwidth combined with service redundancy may also reduce the susceptibility to denial of service attacks.**

This template deploys an Application Gateway that includes a web application firewall and load balancing capabilities.  Traffic can be filtered or routed based on configured rules.  OWASP rules can be enabled that prevent denial of service and other common attacks.

**SC-7.a: The information system monitors and controls communications at the external boundary of the system and at key internal boundaries within the system.**

This template deploys an Application Gateway and load balancer to control communications at external boundaries and between internal subnets. Application Gateway and load balancer event and diagnostic logs are collected by OMS Log Analytics to allow customer monitoring.

**SC-7.b: The information system implements subnetworks for publicly accessible system components that are physically and logically separated from internal organizational networks.**

The application gateway used in this template can be deployed with a Web Application Firewall (WAF). WAF logs are integrated with Azure Monitor to track WAF alerts and logs and easily monitor trends. Customization of the WAF firewall can be done by following [this documentation](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-customize-waf-rules-portal). Application Gateway actively blocks intrusions and attacks detected by its rules. The attacker receives a 403 unauthorized access exception and the connection is terminated. Prevention mode continues to log such attacks in the WAF.

**SC-7.c: The information system connects to external networks or information systems only through managed interfaces consisting of boundary protection devices arranged in accordance with an organizational security architecture.**

This template can be used to deploy an Application Gateway to manage external connections to a customer-deployed web application. External connections for management access are restricted to a bastion host / jumpbox deployed in a management subnet with network security rules applied to restrict external connections to authorized IP addresses.

**SC-7 (3): The organization limits the number of external network connections to the information system.**

This template can be configured with two IP addresses: one associated with the public connection to the Application Gateway; one associated with the internal IP used within the network.

The template can be configured to only include access to backend systems located in a Public Access Zone (PAZ) through the backend pool settings.  Access to other zones should not be done via a public interface.

**SC-7 (5): The information system at managed interfaces denies network communications traffic by default and allows network communications traffic by exception (i.e., deny all, permit by exception).**

Only rulesets configured in the Application Gateway will be allowed.  All other traffic will be denied.

**SC-7 (11): The information system only allows incoming communications from organization-defined authorized sources to be routed to organization-defined authorized destinations.**

This template can be used to deploy an Application Gateway to manage external connections to a customer-deployed web application. External connections for management access are restricted to a bastion host / jumpbox deployed in a management subnet with network security rules applied to restrict external connections to authorized IP addresses.
