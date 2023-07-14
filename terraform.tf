terraform {
    required_version = "= 1.3.9"
    required_providers {
        oci = {
            source = "oracle/oci"
            version = "5.2.1"
        }
    }
}

variable "terraform_data" {
    type = object({
        provider = object({
            user = string
            fingerprint = string
            tenancy = string
            region = string
            key_file = string
            key_password = optional(string,null)
        })
        vm_info = object({
            compartmentId = optional(string,null)
            ZDMVCNName = optional(string,"ZDM_VCN")
            ZDMVCNSubnet = optional(string,"ZDM_Subnet")
            ZDMVCNSGName = optional(string,"ZDM_SG")
            InstanceName = optional(string,"ZDM")
            importImageUri = string
            importImageType = string
            shape = string
            ocpus = number
            memory_in_gbs = number
            public_ssh_key_path = string
        })
    })
}

provider "oci" {
    user_ocid = var.terraform_data.provider.user
    fingerprint = var.terraform_data.provider.fingerprint
    tenancy_ocid = var.terraform_data.provider.tenancy
    region = var.terraform_data.provider.region
    private_key_path = var.terraform_data.provider.key_file
    private_key_password = var.terraform_data.provider.key_password
}

locals {
    compartment_id = var.terraform_data.vm_info.compartmentId == null ? var.terraform_data.provider.tenancy :  var.terraform_data.vm_info.compartmentId
    availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
    is_flexible_node_shape = contains(local.compute_flexible_shapes, var.terraform_data.vm_info.shape)
    ingress_zdm_ports = [80, 111, 139, 443, 445, 2049, 53306]
    ingress_remote_ports = [22, 3389]
    compute_flexible_shapes = [
        "VM.Standard.E3.Flex",
        "VM.Standard.E4.Flex",
        "VM.Standard.A1.Flex",
        "VM.Optimized3.Flex",
        "VM.Standard3.Flex",
    ]
}

data "oci_identity_availability_domains" "availability_domains" {
    compartment_id = local.compartment_id
}

resource "oci_core_vcn" "zdm_vcn" {
    lifecycle {
        create_before_destroy = true
    }
    cidr_block    = "10.0.0.0/16"
    display_name  = var.terraform_data.vm_info.ZDMVCNName
    compartment_id = local.compartment_id
}

resource "oci_core_internet_gateway" "ig" {
    #Required
    compartment_id = local.compartment_id
    vcn_id = oci_core_vcn.zdm_vcn.id

    #Optional
    display_name = "${var.terraform_data.vm_info.ZDMVCNName}_ig"
}

# 서브넷 생성
resource "oci_core_subnet" "zdm_subnet" {
    lifecycle {
        create_before_destroy = true
    }
    cidr_block      = "10.0.0.0/24"
    display_name    = var.terraform_data.vm_info.ZDMVCNSubnet
    vcn_id          = oci_core_vcn.zdm_vcn.id
    compartment_id  = local.compartment_id
    availability_domain = local.availability_domain
    dhcp_options_id = oci_core_vcn.zdm_vcn.default_dhcp_options_id
    route_table_id = oci_core_vcn.zdm_vcn.default_route_table_id
    security_list_ids = [oci_core_vcn.zdm_vcn.default_security_list_id]
}

resource "oci_core_default_route_table" "update_route_table" {
    manage_default_resource_id = oci_core_subnet.zdm_subnet.route_table_id

    route_rules {
        #Required
        network_entity_id = oci_core_internet_gateway.ig.id
        destination = "0.0.0.0/0"
    }
}

resource "oci_core_network_security_group" "zdm_security_group" {
    lifecycle {
        create_before_destroy = true
    }
    vcn_id         = oci_core_vcn.zdm_vcn.id
    display_name   = var.terraform_data.vm_info.ZDMVCNSGName
    compartment_id = local.compartment_id
}

resource "oci_core_network_security_group_security_rule" "zdm_security_group_rules_ingress" {
    count = length(local.ingress_zdm_ports)

    #Required
    network_security_group_id = oci_core_network_security_group.zdm_security_group.id
    direction = "INGRESS"
    protocol = "6"
    source = "0.0.0.0/0"

    tcp_options {
        destination_port_range {
            min = local.ingress_zdm_ports[count.index]
            max = local.ingress_zdm_ports[count.index]
        }
    }
}

data "http" "myip" {
    url = "http://ipv4.icanhazip.com"
}

resource "oci_core_network_security_group_security_rule" "zdm_security_group_rules_remote_ingress" {
    count = length(local.ingress_remote_ports)

    #Required
    network_security_group_id = oci_core_network_security_group.zdm_security_group.id
    direction = "INGRESS"
    protocol = "6"
    source = "${chomp(data.http.myip.body)}/32"

    tcp_options {
        destination_port_range {
            min = local.ingress_remote_ports[count.index]
            max = local.ingress_remote_ports[count.index]
        }
    }
}

resource "oci_core_image" "imported_image" {
    lifecycle {
        create_before_destroy = true
    }

    compartment_id = local.compartment_id
    display_name = basename(var.terraform_data.vm_info.importImageUri)
    image_source_details {
        source_type = "objectStorageUri"
        source_uri = var.terraform_data.vm_info.importImageUri
        source_image_type = var.terraform_data.vm_info.importImageType
    }
}

resource "oci_core_instance" "zdm_instance" {
    lifecycle {
        create_before_destroy = true
    }
    compartment_id        = local.compartment_id
    display_name          = var.terraform_data.vm_info.InstanceName
    availability_domain   = local.availability_domain
    shape                 = var.terraform_data.vm_info.shape
    
    dynamic "shape_config" {
        for_each = local.is_flexible_node_shape ? [1] : []
        content {
            ocpus         = var.terraform_data.vm_info.ocpus
            memory_in_gbs = var.terraform_data.vm_info.memory_in_gbs
        }
    }
    
    create_vnic_details {
        nsg_ids = [ oci_core_network_security_group.zdm_security_group.id ]
        subnet_id = oci_core_subnet.zdm_subnet.id
    }
    
    source_details {
        source_type             = "image"
        source_id               = oci_core_image.imported_image.id
        boot_volume_size_in_gbs = 50
    }

    metadata = {
        ssh_authorized_keys = file(var.terraform_data.vm_info.public_ssh_key_path)
    }
}

output "result" {
  value = {
    Instance_name = var.terraform_data.vm_info.InstanceName
    PublicIp = oci_core_instance.zdm_instance.public_ip
    PrivateIp = oci_core_instance.zdm_instance.private_ip
    Username = "ubuntu"
    Privatekey = "Use the private key of the ssh public key you registered"
  }
}