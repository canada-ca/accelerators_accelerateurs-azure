Updates:

20181214: Implementing new template name as template.json
20190205: Cleanup template folder
20190426: Add DNS Name for fw.

Parameters:

"dnsName": Mandatory parameter that specify the desired DNS name for the firewall. Use the keywork [unique] to add a unique pattern to the name in place of the [unique] keyword. Here is an example of a DNS name with a unique keyword:

    "dnsName": "demo[unique]"

and one without:

    "dnsName": "demo"