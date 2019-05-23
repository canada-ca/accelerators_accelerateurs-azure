# Azure Templates Library

UPDATE:

Work has begun migrating all template development to it's final home at https://github.com/canada-ca-azure-templates

This new GitHub Organisation will contain individual repo for each templates. This will allow you to contribute updates to the templates or to consume them when needed.

For example, to deploy a server template using the version 20190506 (https://github.com/canada-ca-azure-templates/servers/tree/20190506) you would use the following repo link: https://raw.githubusercontent.com/canada-ca-azure-templates/servers/20190506/template/azuredeploy.json

The current Templates/arm folder in this repo will not be updated anymore but will remain as a template source for legacy deployments that still use it.

## List of templates available in new github organisation

| Link                                                                                          | Name                            |
| --------------------------------------------------------------------------------------------- | ------------------------------- |
| [active-directory](https://github.com/canada-ca-azure-templates/active-directory)             | Active Directory Service        |
| [asg](https://github.com/canada-ca-azure-templates/asg)                                       | Application Security Groups     |
| [availabilityset](https://github.com/canada-ca-azure-templates/availabilityset)               | Availability Sets               |
| [azurefirewall](https://github.com/canada-ca-azure-templates/azurefirewall)                   | Azure Firewall                  |
| [backup-policy](https://github.com/canada-ca-azure-templates/backup-policy)                   | Backup Policies                 |
| [ciscoasav2nic](https://github.com/canada-ca-azure-templates/ciscoasav2nic)                   | Cisco ASAv Firewall with 2 NICs |
| [ciscoasav4nic](https://github.com/canada-ca-azure-templates/ciscoasav4nic)                   | Cisco ASAv Firewall with 4 NICs |
| [dns](https://github.com/canada-ca-azure-templates/dns)                                       | DNS records                     |
| [devtestlab](https://github.com/canada-ca-azure-templates/devtestlab)                         | Dev & Test labs                 |
| [fortigate2nic](https://github.com/canada-ca-azure-templates/fortigate2nic)                   | Fortigate Firewall with 2 NICs  |
| [fortigate4nic](https://github.com/canada-ca-azure-templates/fortigate4nic)                   | Fortigate Firewall with 4 NICs  |
| [keyvaults](https://github.com/canada-ca-azure-templates/keyvaults)                           | Key Vaults                      |
| [loadbalancers](https://github.com/canada-ca-azure-templates/loadbalancers)                   | Loadbalancer                    |
| [loganalytics](https://github.com/canada-ca-azure-templates/loganalytics)                     | Workspaces log analytic         |
| [masterdeploy](https://github.com/canada-ca-azure-templates/masterdeploy)                     | Master Deployments              |
| [nsg](https://github.com/canada-ca-azure-templates/nsg)                                       | Network Security Groups         |
| [rbac](https://github.com/canada-ca-azure-templates/rbac)                                     | Role Based Access Control       |
| [rds](https://github.com/canada-ca-azure-templates/rds)                                       | Remote Desktop Service          |
| [recovery-service-vault](https://github.com/canada-ca-azure-templates/recovery-service-vault) | Recovery Service Vault          |
| [resourcegroups](https://github.com/canada-ca-azure-templates/resourcegroups)                 | Resourcegroups                  |
| [routes](https://github.com/canada-ca-azure-templates/routes)                                 | User Defined Route Tables       |
| [s2d](https://github.com/canada-ca-azure-templates/s2d)                                       | Storage Space Direct            |
| [servers](https://github.com/canada-ca-azure-templates/servers)                               | Servers                         |
| [servers-decyptVMDisks](https://github.com/canada-ca-azure-templates/servers-decyptVMDisks)   | Servers Encrypt VM Disks        |
| [servers-encryptVMDisks](https://github.com/canada-ca-azure-templates/servers-encryptVMDisks) | Servers Decrypt VM Disks        |
| [sql-server-cluster](https://github.com/canada-ca-azure-templates/sql-server-cluster)         | SQL Server Cluster              |
| [storage](https://github.com/canada-ca-azure-templates/storage)                               | Storage Accounts                |
| [vnet-peering](https://github.com/canada-ca-azure-templates/vnet-peering)                     | VNET Peering                    |
| [vnet-subnet](https://github.com/canada-ca-azure-templates/vnet-subnet)                       | VNETs                           |
| [vpn](https://github.com/canada-ca-azure-templates/vpn)                                       | Virtual Private Network         |