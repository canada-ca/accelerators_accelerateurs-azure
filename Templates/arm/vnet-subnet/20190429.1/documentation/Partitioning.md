#### NIST Controls
SC-2, SC-3, SC-7 (13), SC-7 (21)

## Implementation and Configuration

This template can be configured to deploy resources in an architecture with separate subnets following ITSG-22 guidence.  It can also be used to seperate the management tools in a seperate vnet and/or subnets. Subnets are logically separated by network security groups and firewall rules applied to the individual subnets to restrict traffic between subnets to only that necessary for system and management functionality.


## Compliance Documentation
**SC-2: The information system separates user functionality (including user interface services) from information system management functionality. Information system management functionality includes, for example, functions necessary to administer databases, network components, workstations, or servers, and typically requires privileged user access.**

This template can be used to seperate user functionality from information system management functionality by deploying sperate vnets and subnets in a hub/spoke architecture.

**SC-3: The information system isolates security functions from nonsecurity functions.** 

This template can be used in an architecture with a separate management subnet for customer deployment of information security tools and support components. Subnets are logically separated by network security group rules.

**SC-7 (13): The organization isolates [Assignment: organization-defined information security tools, mechanisms, and support components] from other internal information system components by implementing physically separate subnetworks with managed interfaces to other components of the system.**

This template can be configured to deploy resources in an architecture with a separate management subnet for customer deployment of information security tools and support components. Subnets are logically separated by network security group rules.

**SC-7 (21): The organization employs boundary protection mechanisms to separate organization-defined information system components supporting organization-defined missions and/or business functions.**


This template can deploy resources in an architecture with a separate web subnet, database subnet, Active Directory subnet, and management subnet. Subnets are logically separated by network security groups and firewall rules applied to the individual subnets to restrict traffic between subnets to only that necessary for system and management functionality.