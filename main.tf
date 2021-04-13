variable "compartment" {}

provider "oci" {}

resource "oci_core_vcn" "main" {
  compartment_id = var.compartment

  dns_label = "main"
  cidr_blocks = [
    "192.168.0.0/16"
  ]
}

resource "oci_core_security_list" "private" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  ingress_security_rules {
    stateless   = true
    protocol    = "all"
    source      = "192.168.0.0/16"
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    stateless        = true
    protocol         = "all"
    destination      = "192.168.0.0/16"
    destination_type = "CIDR_BLOCK"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_core_subnet" "private" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  cidr_block                 = "192.168.254.0/24"
  prohibit_public_ip_on_vnic = true

  security_list_ids = [oci_core_security_list.private.id]
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  enabled = true
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  ingress_security_rules {
    stateless   = true
    protocol    = "all"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    stateless        = true
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_core_subnet" "public" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  cidr_block = "192.168.1.0/24"
  dns_label  = "subnet1"

  security_list_ids = [oci_core_security_list.public.id]
  route_table_id    = oci_core_route_table.public.id
}
