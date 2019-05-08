#### NIST Controls / ITSG-33 Controls: 
SC-28, SC-28 (1)

# Implementation and Configuration
This template can provide protection for information at rest by enabling SQL Server's Transparent Data Encryption (TDE) feature and through Storage Service Encryption on the managed disks.

It is also recommended that you use bitlocker across all VMs in the system.

# Compliance Documentation
**SC-28: The information system protects the confidentiality and integrity of all information at rest throughout the system.**

SC-28 (1) implementation satisfies this control requirement.

**SC-28 (1): The information system implements cryptographic mechanisms to prevent unauthorized disclosure and modification of information on all information system components storing customer data deemed sensitive.**

Virtual machines deployed by this template and the post encryption template implement disk encryption to protect the confidentiality and integrity of information at rest. Azure disk encryption for Windows is implemented using the BitLocker feature of Windows. SQL Database is configured to use Transparent Data Encryption (TDE), which performs real-time encryption and decryption of data and log files to protect information at rest. TDE provides assurance that stored data has not been subject to unauthorized access. Customer may elect to implement additional application-level controls to protect the integrity of stored information. Confidentiality and integrity of all storage blobs deployed by this template (including those used for backup, log storage **list all deployed storage account uses**) are protected through use of Azure Storage Service Encryption (SSE). SSE safeguards data at rest within Azure storage accounts using 256-bit AES encryption.