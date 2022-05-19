#
# Create Tenant
resource "mso_tenant" "demo" {
  name         = "cloud-tf-demo"
  display_name = "cloud-tf-demo"

  site_associations {
    site_id = data.mso_site.onprem.id
  }

  site_associations {
    site_id                = data.mso_site.aws.id
    vendor                 = "aws"
    aws_account_id         = var.aws_account
    is_aws_account_trusted = true
  }

  site_associations {
    site_id                 = data.mso_site.azure.id
    vendor                  = "azure"
    azure_access_type       = "shared"
    azure_shared_account_id = var.azure_account
  }

  user_associations {
    user_id = data.mso_user.current_user.id
  }
}

# Schema and Templates
resource "mso_schema" "demo" {
  name          = "cloud-tf-schema"
  template_name = "Stretched"
  tenant_id     = mso_tenant.demo.id
}

resource "mso_schema_template" "cloud_only" {
  schema_id    = mso_schema.demo.id
  name         = "Cloud-Only"
  display_name = "Cloud-Only"
  tenant_id    = mso_tenant.demo.id
}

resource "mso_schema_template" "onprem_only" {
  schema_id    = mso_schema.demo.id
  name         = "Onprem-Only"
  display_name = "Onprem-Only"
  tenant_id    = mso_tenant.demo.id
}

# Site association
resource "mso_schema_site" "stretched_site_onprem" {
  schema_id     = mso_schema.demo.id
  site_id       = data.mso_site.onprem.id
  template_name = mso_schema.demo.template_name
}

resource "mso_schema_site" "stretched_site_aws" {
  schema_id     = mso_schema.demo.id
  site_id       = data.mso_site.aws.id
  template_name = mso_schema.demo.template_name
}

resource "mso_schema_site" "stretched_site_azure" {
  schema_id     = mso_schema.demo.id
  site_id       = data.mso_site.azure.id
  template_name = mso_schema.demo.template_name
}

resource "mso_schema_site" "onprem_only_site_onprem" {
  schema_id     = mso_schema.demo.id
  site_id       = data.mso_site.onprem.id
  template_name = mso_schema_template.onprem_only.id
}

resource "mso_schema_site" "cloud_only_site_aws" {
  schema_id     = mso_schema.demo.id
  site_id       = data.mso_site.aws.id
  template_name = mso_schema_template.cloud_only.id
}

resource "mso_schema_site" "cloud_only_site_azure" {
  schema_id     = mso_schema.demo.id
  site_id       = data.mso_site.azure.id
  template_name = mso_schema_template.cloud_only.id
}




