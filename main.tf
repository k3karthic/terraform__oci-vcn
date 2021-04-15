/*
 * Variables
 */

variable "compartment" {}

variable "vcn_cidr" {}
variable "public1_cidr" {}
variable "private1_cidr" {}

/*
 * Providers
 */

provider "oci" {}

/*
 * Configuration
 */

//
// Network
//

resource "oci_core_vcn" "main" {
  compartment_id = var.compartment

  dns_label = "main"
  cidr_blocks = [
    var.vcn_cidr
  ]
}

//
// Subnets
//

resource "oci_core_subnet" "public" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  cidr_block = var.public1_cidr
  dns_label  = "subnet1"

  security_list_ids = [oci_core_security_list.public.id]
  route_table_id    = oci_core_route_table.public.id
}

resource "oci_core_subnet" "private" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  cidr_block                 = var.private1_cidr
  prohibit_public_ip_on_vnic = true

  security_list_ids = [oci_core_security_list.private.id]
}

//
// Gateways
//

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  enabled = true
}

//
// Route Tables
//

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

//
// Security Lists
//

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

resource "oci_core_security_list" "private" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id

  ingress_security_rules {
    stateless   = true
    protocol    = "all"
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    stateless        = true
    protocol         = "all"
    destination      = var.vcn_cidr
    destination_type = "CIDR_BLOCK"
  }

  lifecycle {
    create_before_destroy = true
  }
}
