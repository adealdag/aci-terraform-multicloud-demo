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

# NDO Users
data "mso_user" "current_user" {
  username = var.mso_username
}
