# Template Name

## Introduction

This template is used for [Role Based Access Control](<https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-template>)

* For a single role assignment use azuredeploy.json.
* For multiple role assignments use ProBRBAC.ps1 which takes an array of roles

## Security Controls

The following security controls can be met through configuration of this template:

* [Establish User Account Types](documentation/Establish-User-Account-Types.md): AC-2.a.
* [Role Based Access Controls](documentation/Role-Based-Access-Control.md): AC-2 (7).a, AC-3, AC-6, AC-6 (8), AC-6 (10), AU-6 (7), AU-9, AU-9 (4), CM-5.

## Dependancies

The following items are assumed to exist already in the deployment:

* Subscription, management group or resource group
* User or Group to assign the role to

## Parameter format

```JSON
{
       "principalID":{
           "value": "a1d5b802-c5bf-463a-ae3c-5459adda02b9"
       },
       "roleDefinitionID":{
           "value": "b24988ac-6180-42a0-ab88-20f7382dd24c"
       },
       "scopeLevel":{
           "value": "resourceGroup"
       },
       "managementGroupID":{
           "value":""
       }
}
```

## Parameter Values

### Main Template

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|principalID |string |Yes      |A user or group ID to asign the role to. |
|roleDefinitionID |string |Yes      |The ID of the role you would like to asign. See [Built-in Roles](<https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles>) for examples.    |
|scopeLevel |string |Yes      |The scope level to apply to the role - subscription, managementGroup, resourceGroup|
|managementGroupID |string |No      |The ID of the management group. Note the ID is a string not GUID|
|assignmentName |string |No      |An ID to assign to the role assignment.  Default is a new GUID. |

## History

|Date       | Change                |
|-----------|-----------------------|
|2019-03-21 | Intial Version|
|2019-03-23 | Support to call multiple roles via ProBRBAC.json|
|2019-05-09 | Added documentation and support for resource group scope|
