#### NIST Controls
CP-6.a, CP-6.b, CP-6 (1), CP-6 (2)

## Implementation and Configuration

This template can be used to ensure storage redundancy by enabling the geo-redundant storage (GRS) on the storage accounts.

Geo-redundant storage (GRS) replicates your data asynchronously in two geographic regions that are at least hundreds of miles apart.  Other Azure Storage redundancy options include zone-redundant storage (ZRS), which replicates your data across availability zones in a single region, and locally redundant storage (LRS), which replicates your data in a single data center in a single region.

Setting the reduncancy is achieved by using Standard_GRSstorage types for all storage accounts. Storage account types for all storage accounts can be configured by editing the default values for storage account types in the parameters section of this template.

To verify if the Storage account is geo-redundant:

1) Login to the Azure Portal

2) Goto the Storage Account

3)  In the storage dashboard, verify that the **Replication** is set to 'Geo-redundant storage (GRS)' or 'Zone-redundant storage (ZRS)'


## Compliance Documentation

**CP-6.a: The organization establishes an alternate storage site including necessary agreements to permit the storage and retrieval of information system backup information**

Storage accounts deployed by this template can be configured to enable replication ensuring high availability either by using geo-redundant storage (GRS). GRS ensures that data is replicated to a secondary region.

**CP-6.b: The organization ensures that the alternate storage site provides information security safeguards equivalent to that of the primary site.**

Storage accounts deployed by this template can be configured to enable replication ensuring high availability using geo-redundant storage (GRS). Physical security controls are implemented uniformly across Azure datacenters.

**CP-6 (1): The organization identifies an alternate storage site that is separated from the primary storage site to reduce susceptibility to the same threats.**

Storage accounts deployed by this template can be configured to enable replication ensuring high availability using geo-redundant storage (GRS). GRS ensures that data is replicated to a secondary region. Primary and secondary regions are paired to ensure necessary distance between datacenters to ensure availability in the event of an area-wide outage or disaster.  See [Availability Paired Regions](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions) for more details.

**CP-6 (2): The organization configures the alternate storage site to facilitate recovery operations in accordance with recovery time and recovery point objectives.**

Storage accounts deployed by this template can be configured to enable replication ensuring  high availability using geo-redundant storage (GRS). GRS ensures that data is replicated to a secondary region.
