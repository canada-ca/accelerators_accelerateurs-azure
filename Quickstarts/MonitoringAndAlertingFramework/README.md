
# Azure Monitoring and Alerting Framework

The Monitoring and Alerting Framework for Azure enables performance and health monitoring and alerting of a number of Azure resource types, including Virtual Machines, App Services (via Application Insights) and more.  It builds on the native capabilities already provided by Azure Monitor.  

The framework supports notifications based on any action supported by Azure Action Groups, including email notifications, SMS, phone calls notification, web hook invocations, etc.

Which resources are to be monitored, what is to be monitored as well as which Action Groups (ie. ops support teams) are to be notified is controlled through a simple and flexible tag-based approach. Alert threshold conditions are defined in JSON parameter files and stored in this repo, and can be easily expanded (eg. to monitor a new metric) or updated (eg. to specify a custom trigger threshold).

To begin using the framework, please refer to "Monitoring and Alerting Framework for Azure Implementation Guide.docx" in this folder.  

To understand the design of the framework in order to enhance/extend it, please refer to "Monitoring and Alerting Framework for Azure Solution Design.docx" in this folder.


