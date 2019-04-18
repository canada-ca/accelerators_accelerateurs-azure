Updates:

**20181214**: Implementing new template name as template.json
**20190205**: Cleanup template folder
**20190226**: Add the ability to use a special token ([unique]) in the keyvault name to ensure keyvault name uniqueness.
**20190301**: Transformed the template to be resourcegroup deployed rather than subscription level deployed.

Optional:

[unique]: When specifying the name of a keyvault simply include the token [unique] (including the []) as part of the name. The resulting name will replace the [unique] word with a unique string of characters. For example:

    "key-[unique]-deploy" -> "key-sd8kjdf678k9-deploy"
    "keyvault-test-[unique]" -> "keyvault-test-7djkf90jkdf"

This is helpfull to ensure there will be no keyvault duplicates in Azure as it need to be unique.