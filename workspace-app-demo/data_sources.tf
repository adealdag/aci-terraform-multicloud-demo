# NDO Sites
data "mso_site" "onprem" {
  name = "ACI-ONPREM"
}

data "mso_site" "aws" {
  name = "ACI-AWS"
}

data "mso_site" "azure" {
  name = "ACI-AZURE"
}

# Remote state
data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "cisco-dcn-ecosystem"
    workspaces = {
      name = "adealdag-cloud-aci-net"
    }
  }
}
