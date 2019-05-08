#### NIST Controls
CP-10 (2)

## Implementation and Configuration

This template can enable the **Automated backup** feature for the IaaS Sql server VM by leveraging the SQL IAAS Agent Extension. The automated backup that uses this feature lets us configure the backup storage location, retention period, and encryption credentials. Read [this link](<https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-automated-backup>) for more information.

The SQL IAAS Agent Extension can be seen [here](<https://github.com/AppliedIS/azure-blueprint/blob/master/nestedtemplates/preparingSqlServer.json#L163>).
You can configure the parameters:
- Retention Period
- Storage Account
- Enable Encryption(this is to enable encryption of the Database backups at rest)
- Credential (This is needed when Encryption is enabled)

The Automated backup feature may be enabled from the 'SQL Server Configuration' tab inside the IaaS SQL Server VM in Azure portal or by using the IaaS Extension using powershell.

To verify if the Automated backup has been enabled for the IaaS Sql Server VM

1) Goto the Storage Account --> Containers
2)  Check the **automaticbackup** folder. This folder will contain the .cer, .pvk, .key files for the backup
3)  There will be another folder with the name <<IaasSqlServerVM>>-mssqlserver. Replace <<IaasSqlServerVM>>-with the IaaS Sql Server VM name.
4) Login to the Sql server VM and connect to SSMS
5) In Security --> Credentials, a new credential will be added with the name 'AutoBackup_Credential'
6) Create a new database in the Sql Server
7) In Storage Account --> Containers --> <<IaasSqlServerVM>>-mssqlserver, the .bak(backup file) and .log(log files) will be written to the storage account
8) .Bak and .Log files are then written as per SQL Server load.

## Compliance Documentation

CP-10 (2): The information system implements transaction recovery for systems that are transaction-based.

This Azure Blueprint Solution installs the SQL IAAS agent extension to each SQL VM in the domain with **Automated backup** enabled.