# ZConverter DR Manager(ZDM) Auto Versioning using Terraform

ZConverter Cloud DR enables you to minimize business data loss by configuring instantaneous recovery systems to the cloud in the event of a disaster or disaster. AutoVersion terraform distributes preinstalled ZDM images to user accounts in the ubuntu 20.04 image of oracle.

### Prerequisites

- You must download the Terraform executable beforehand. Check and download the operating system and architecture [terraform v1.3.9](https://releases.hashicorp.com/terraform/1.3.9/)

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-group`, `subnets`, and `instances`.

- Quota to create the following resources: 1 VCNS, 1 subnets, 1 security-groups, 1 user custom image, and 1 compute instance.

- If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## Deploy Using the Terraform CLI

### Clone the Module
- Create a local copy of this repository (Example when Linux):
    ```
    git clone https://github.com/ZConverter/oracle-auto-zdm-versioning.git
    cd oracle-auto-zdm-versioning
    ls
    ```

- If git is not installed, download and decompress [ZIP FILE](https://github.com/ZConverter/oracle-auto-zdm-versioning/archive/refs/heads/main.zip)

### Set Up and Configure Terraform
- If you do not have a value for the configuration data to enter into the provider, you can refer to the [CREATE KEY](https://github.com/ZConverter/oracle-auto-zdm-versioning/blob/createKey/README.md#create-api-key).
- If you have not determined the input value of the shape, refer to the following address : [OCI Shape](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm)
- Create a `terraform.tfvars` file, and specify the following variables:

    ```
    terraform_data {
        provider {
            user = "<your user-ocid of config data>"
            fingerprint = "<your user-ocid of config data>"
            tenancy = "<your user-ocid of config data>"
            region = "<your user-ocid of config data>"
            key_file = "<Absolute path of the private key in the config data>"
        }
        vm_info {
            InstanceName = "<if you want to specify an instance name, Use this key-value - default : ZDM>"
            ZDMVCNName = "<If you want to specify a separate VCN name, use this key-value - default : ZDM_VCN>"
            ZDMVCNSubnet = "<If you want to specify a separate Subnet name, use this key-value - default : ZDM_Subnet>"
            ZDMVCNSGName = "<If you want to specify a separate Subnet name, use this key-value - default : ZDM_SG>"
            importImageUri = "<The downloadable address of the custom image of zdm stored in the bucket. Contact your administrator for an address.>"
            importImageType = "<QCOW2 or VMDK>"
            shape = "<Enter the oci compute shape you want to use>"
            ocpus = <If the shape you want to use is Flex, enter the number of cpu you want to use as an integer>
            memory_in_gbs = <If the shape you want to use is Flex, enter the memory you want to use as an integer in GB>
            public_ssh_key_path = "<The public key of the ssh key to be used when accessing the instance>"
        }
    }
    ````
- You can also replace it with json.
Create the file 'terraform.json' and specify the following variables (equivalent to the terraform.tfvars in the input of the variable):

    ```
    {
        "terraform_data": {
            "provider": {
                "user": "<your user-ocid of config data>",
                "fingerprint": "<your user-ocid of config data>",
                "tenancy": "<your user-ocid of config data>",
                "region": "<your user-ocid of config data>",
                "key_file": "<Absolute path of the private key in the config data>"
            },
            "vm_info": {
                "InstanceName" : "<if you want to specify an instance name, Use this key-value - default : ZDM>",
                "ZDMVCNName" : "<If you want to specify a separate VCN name, use this key-value - default : ZDM_VCN>",
                "ZDMVCNSubnet" : "<If you want to specify a separate Subnet name, use this key-value - default : ZDM_Subnet>",
                "ZDMVCNSGName" : "<If you want to specify a separate Subnet name, use this key-value - default : ZDM_SG>",
                "importImageUri" : "<The downloadable address of the custom image of zdm stored in the bucket. Contact your administrator for an address.>",
                "importImageType" : "<QCOW2 or VMDK>",
                "shape":"<Enter the oci compute shape you want to use>",
                "ocpus":<If the shape you want to use is Flex, enter the number of cpu you want to use as an integer>,
                "memory_in_gbs":<If the shape you want to use is Flex, enter the memory you want to use as an integer in GB>,
                "public_ssh_key_path":"<The public key of the ssh key to be used when accessing the instance>"
            }
        }
    }
    ```

### Create the Resources
1. Add a terraform executable to a cloned or decompressed directory - see : [Clone the Module](https://github.com/ZConverter/oracle-auto-zdm-versioning/tree/main#clone-the-module), [Prerequisites](https://github.com/ZConverter/oracle-auto-zdm-versioning/tree/main#prerequisites)
2. Run the following commands:
    ```
    terraform init
    terraform plan -var-file=<Absolute path to terraform.tfvars or terraform.json created in the previous step>
    terraform apply -var-file=<Absolute path to terraform.tfvars or terraform.json created in the previous step> -auto-approve
    ```

### Destroy the Deployment
1. When you no longer need the deployment, you can run this command to destroy the resources:
    ```
    terraform destroy -var-file=<Absolute path to terraform.tfvars or terraform.json created in the previous step> -auto-approve
    ```
