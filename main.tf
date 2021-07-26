terraform {
  required_version = "~> 1"

  required_providers {
    oci = {
      source = "hashicorp/oci"
      version = "~> 4"
    }
  }
  
}

locals {
  compartment_id = var.compartment_id
  name = var.name
  
  subnets = var.subnets
  
  vcn = module.vcn.vcn
}

module "vcn" {
  source  = "Terraform-Modules-Lib/vcn/oci"
  
}
