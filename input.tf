variable "region" {
    default = "West Europe"
}

variable "rg_name" {}
variable "rg_tags" {
  type = "map"
  default = {
      Company = "Sentia"
  }
}
variable "is_sa_prefixed" {
  default = true
}
variable "sa_prefix" {
  default = "sentia"
}
variable "sa_name" {}

variable "sa_acc_tier" {
  default = "Standard"
}
variable "sa_acc_rep_type" {
  default = "LRS"
}

variable "file_encryption" {
  default = true
}
variable "blob_encryption" {
  default = true
}

variable "vn_name" {
  default = "sentia_vn"
}

variable "vn_addr_space" {
  type = "list"
}

variable "vn_subnets" {
  type = "list"
}



variable "enabled_resource_types" {
  type = "list"
  default = [
            {
               field = "type"
               like = "Microsoft.Compute/*"
            },
            {
               field = "type"
               like = "Microsoft.Network/*"
            },
            {
               field = "type"
               like = "Microsoft.Storage/*"
            }
  ]
}

locals {
    enabled_resource_types_map = {
        if = {
            not = {
                anyOf = "${var.enabled_resource_types}"
            }
        }
        then = {
            effect = "deny"
        }
    }
}

