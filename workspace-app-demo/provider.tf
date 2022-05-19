terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 2.1.0"
    }
    mso = {
      source  = "CiscoDevNet/mso"
      version = "~> 0.5.0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.1.1"
    }
  }
}

# provider "aci" {
#   alias = "onprem"

#   username = var.aci_username
#   password = var.aci_password
#   url      = var.aci_url_site1
#   insecure = true
# }

# provider "aci" {
#   alias = "aws"

#   username = var.aci_username
#   password = var.aci_password
#   url      = var.aci_url_site2
#   insecure = true
# }

# provider "aci" {
#   alias = "azure"

#   username = var.aci_username
#   password = var.aci_password
#   url      = var.aci_url_site3
#   insecure = true
# }

provider "mso" {
  username = var.mso_username
  password = var.mso_password
  url      = var.mso_url
  insecure = true
  platform = "nd"
}

# provider "vsphere" {
#   user                 = var.vsphere_username
#   password             = var.vsphere_password
#   vsphere_server       = var.vsphere_server_site1
#   allow_unverified_ssl = true
# }

