
Modified:
- Removed server creation and using our arm servers template
- Added in support for adding the SSL certificates
- Removed depricated xSQLServer and replaced with SqlServerDsc (not working on test, reverted back to xSQLServer for now)
- Modified SqlRS to use the windows account for connection as the service/machine accounts do not have permisions on the external DB
- Modified code to point at external DB
- Modified service account to run as a domain account else the database fails to initalize


TODO: 
- Verify SSL Parameters
- Verify script works with listner name instead of IP
- Remove all passwords and use keyvault
- Custom SQL imgage with less features enabled.  see "[xSqlServerSetup]InstallSql", "[File]InstallSqlServerModule"
- Verify if SSRS databases should include failover
- Verify antimalware settings and deployment