variable "compartment" {}

provider "oci" {}

resource "oci_core_vcn" "main" {
    compartment_id = var.compartment

    dns_label = "main"
    cidr_blocks = [
        "192.168.0.0/16"
    ]
}

resource "oci_core_subnet" "private" {
    compartment_id = var.compartment
    vcn_id = oci_core_vcn.main.id

    cidr_block = "192.168.254.0/24"
    prohibit_public_ip_on_vnic = true
}

resource "oci_core_internet_gateway" "igw" {
    compartment_id = var.compartment
    vcn_id = oci_core_vcn.main.id

    enabled = true
}

resource "oci_core_route_table" "public" {
    compartment_id = var.compartment
    vcn_id = oci_core_vcn.main.id

    route_rules {
        network_entity_id = oci_core_internet_gateway.igw.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

resource "oci_core_subnet" "public" {
    compartment_id = var.compartment
    vcn_id = oci_core_vcn.main.id

    cidr_block = "192.168.1.0/24"
    dns_label = "subnet1"
    route_table_id = oci_core_route_table.public.id
}
