Template parameter documentation:

Updates:

20181120: Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.
20181211: Updates deploy.ps1 to make it more flexible and resilient.
20181214: Implementing new template name as template.json
20190128: Added optional parameter to lock resourcegroup
20190205: Cleanup template folder

Optional Resource Group object parameters are:

"lock": Use this parameter in the desired rgNames object to specify if the resource group should be locked. Specify either "CanNotDelete", "ReadOnly" as the lock parameter. Following is an example of a CanNotDelete lock:

    "lock": "CanNotDelete"