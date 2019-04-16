# Azure Templates Library

This folder contains a "consumer view" of all ARM Templates and associated versions used to deploy the demonstration found in the Deployments folder. You can also use those same templates to assemble and deploy resources in your Azure Subscriptions.

Each templates contains myltiple versions to ensure deployment consistency over time. If you start to deploy resources using a specific template you can be assured it will remain available as it is months down the road.

As new features and improvements are added overtime you are invited to review new templates versions and update your deployment to use them to remain current and secure.

Development of new template and versions is currently done in a seperate Azure Devops project (https://dev.azure.com/PSPC-CCC/Core) using individual repo for each templates. This is currently tightly coupled with Azure DevOps CI/CD pipelines. It will require time and effort to migrate the solution to github.
