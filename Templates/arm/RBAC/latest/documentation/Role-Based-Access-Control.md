#### NIST Controls
AC-2 (7).a, AC-3, AC-6, AC-6 (8), AC-6 (10), AU-6 (7), AU-9, AU-9 (4), CM-5

## Implementation and Configuration
Read more about Role Based Access and Configuration [here](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-what-is).

See [this link](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles) for predefined roles that Azure offers. Also, see how to configure [custom roles](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-custom-roles).


## Compliance Documentation

**AC-2 (7).a: The organization establishes and administers privileged user accounts in accordance with a role-based access scheme that organizes allowed information system access and privileges into roles.**

This template can be used to implement the following system account types: Azure Active Directory users, which are used to manage access to Azure resources. Azure Active Directory account privileges are implemented using role-based access control.  Roles can be assiged at the subscription, management group or resource group level.

**AC-3: The information system enforces approved authorizations for logical access to information and system resources in accordance with applicable access control policies.**

This template can be used to enforce logical access authorizations using role-based access control enforced by Azure Active Directory and Active Directory Domain Services.

**AC-6: The organization employs the principle of least privilege, allowing only authorized accesses for users (or processes acting on behalf of users) which are necessary to accomplish assigned tasks in accordance with organizational missions and business functions.**

This template can be used to implement role-based access control to ensure users are assigned only the privileges explicitly necessary to perform their assigned duties.  

**AC-6 (8): The information system allows the ability to prevent certain users from executing at higher privilege levels than other users executing the software.**

This template can be used to implement role-based access control to assign users only the privileges explicitly necessary to perform their assigned duties. See [this link](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles) for predefined roles that Azure offers. Roles can be assiged at the subscription, management group or resource group level.

**AC-6 (10): The information system prevents non-privileged users from executing privileged functions to include disabling, circumventing, or altering implemented security safeguards/countermeasures.**

This template can be used to implement role-based access control to assign users only the privileges explicitly necessary to perform their assigned duties. See [this link](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles) for predefined roles that Azure offers. See how to configure [custom roles](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-custom-roles).

**AU-6 (7): The organization should specify the permitted actions for information system process, users associated with the review, analysis, and reporting of audit information. Organizations should specify permitted actions for information system processes, roles, and/or users associated with the review, analysis, and reporting of audit records through account management techniques. Specifying permitted actions on audit information is a way to enforce the principle of least privilege. Permitted actions are enforced by the information system and include, for example, read, write, execute, append, and delete.**

This template can be used to implement role-based access control to assign users only the privileges explicitly necessary to perform their assigned duties. See [this link](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles) for predefined roles that Azure offers. See how to configure [custom roles](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-custom-roles).

**AU-9: The information system protects audit information and audit tools from unauthorized access, modification, and deletion.**

Logical access controls are used to protect audit information and tools using this template from unauthorized access, modification, and deletion. Azure Active Directory enforces approved logical access using Active Directory policies and role-based group memberships. The ability to view audit information and use auditing tools is limited to users that require these permissions.

**AU-9 (4): The organization authorizes access to management of audit functionality to only organization-defined subset of privileged users.**

Azure Active Directory restricts the management of audit functionality to members of the appropriate security groups. Only personnel with a specific need to access the management of audit functionality are granted these permissions using this template.

**CM-5: The organization defines, documents, approves, and enforces physical and logical access restrictions associated with changes to the information system.**

This template can be used to implement role-based access control to assign users only the privileges explicitly necessary to perform their assigned duties. See [this link](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles) for predefined roles that Azure offers. See how to configure [custom roles](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-custom-roles).

**CM-5 (1): The information system enforces access restrictions and supports auditing of the enforcement actions.**

This template can be used to implement role-based access control to assign users only the privileges explicitly necessary to perform their assigned duties. See [this link](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles) for predefined roles that Azure offers. See how to configure [custom roles](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-custom-roles).
