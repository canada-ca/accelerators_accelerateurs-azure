Template parameter documentation:

This template is used to deploy other templates using parameter files stored on a private blob storage.

Updates:

20190317: 1st release

Optional Deployment object parameters are:

"dependOn": Use this parameter array in the desired deployment object to provide the name of dependent resources. A maximum of 4 dependent resources can be passed. An exampole can be found below:

       "dependsOn": [
                        "storage-vmdiag-Shared-Sandbox",
                        "core-cisco-asav"
                    ]

Notes:

Azure does not support deployment to more than 5 resourcegroups target through link templates. This will apparently be solved in 2019...

There is also an issue with passing the dependsOn property an array of string as one would expect it would accept. For this reason I had to improvide an ugly hack that essentially copy dependsOn values if they exists in the deploymentArray object. If not then it will depend on the "start" resource created at the begining of the deployment. Nasty but until a fix is found for the dependsOn array it will have to do.