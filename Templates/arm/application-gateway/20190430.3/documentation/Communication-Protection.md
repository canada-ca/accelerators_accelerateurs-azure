#### NIST Controls

AC-17 (2), SC-8, SC-8 (1), SC-23, SC-23 (1), SC-23 (3)

## Implementation and Configuration
This template can configure an Application Gateway in Web Application Firewall Mode to secure traffic going in and out of the architecture.  The solution enforces ssl/tls tunneling to be used with all external to the Architecture traffic.

## Compliance Documentation

**AC-17 (2): The information system implements cryptographic mechanisms to protect the confidentiality and integrity of remote access sessions.**

Auzre portal, remote desktop connection, and web application sessions are protected by cryptographic mechanisms.

**SC-8: The information system protects the confidentiality and integrity of transmitted information.**

SI-8 (1) implementation satisfies this control requirement.

**SC-8 (1): The information system implements cryptographic mechanisms to prevent unauthorized disclosure of information and detect changes to information during transmission unless otherwise protected by organization-defined alternative physical safeguards.**

This template can be configured to only allow resources to communicate using secure protocols. The WAF component of the Application Gateway can be configured to accept communicators from external uses over HTTPS/TLS and communicate with the backend pool only over HTTPS/TLS.

**SC-23: The information system protects the authenticity of communications sessions. This control addresses communications protection at the session, versus packet level (e.g., sessions in service-oriented architectures providing web-based services) and establishes grounds for confidence at both ends of communications sessions in ongoing identities of other parties and in the validity of information transmitted. Authenticity protection includes, for example, protecting against man-in-the-middle attacks/session hijacking and the insertion of false information into sessions.** 

This template can be configured to only allow resources to communicate using secure protocols between the client and the Azure Application Gateway. The WAF component of the Application Gateway can be configured to accept communicators from external users over HTTPS/TLS and communicate with the backend pool only over HTTPS/TLS. 

**SC-23 (1): The information system invalidates session identifiers upon user logout or other session termination.**

Session invalidation is being enforced through Azure Application Gateway - Web Application Firewall (WAF) rules.  The WAF employs an Open Web Application Security Project (OWASP) ruleset, applies cookie affinity per session and performs session timeout after 30 minutes (configurable post deployment to organization specific rules) of inactivity from the client

**SC-23 (3): The information system generates a unique session identifier for each session with organization-defined randomness requirements and recognizes only session identifiers that are system-generated.**

This template is using Azure Application Gateway - Web Application Firewall (WAF) to meet this requirement.