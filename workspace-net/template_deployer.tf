locals {
  templates_deploy = false
}

#
# Deploy templates
#
resource "mso_schema_template_deploy" "stretched_onprem_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_template_bd_subnet.bd1net,
    mso_schema_template_bd_subnet.bd2net,
    mso_schema_site_vrf_region.main_aws_eu_central,
    mso_schema_site_vrf_region.main_azure_eu_central,
    mso_schema_site.stretched_site_aws,
    mso_schema_site.stretched_site_azure,
    mso_schema_site.stretched_site_onprem
  ]

  schema_id     = mso_schema.demo.id
  template_name = mso_schema.demo.template_name
  site_id       = data.mso_site.onprem.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "stretched_aws_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_template_deploy.stretched_onprem_deployer
  ]

  schema_id     = mso_schema.demo.id
  template_name = mso_schema.demo.template_name
  site_id       = data.mso_site.aws.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "stretched_azure_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_template_deploy.stretched_onprem_deployer
  ]

  schema_id     = mso_schema.demo.id
  template_name = mso_schema.demo.template_name
  site_id       = data.mso_site.azure.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "onprem_only_onprem_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_site.onprem_only_site_onprem
  ]

  schema_id     = mso_schema.demo.id
  template_name = mso_schema_template.onprem_only.id
  site_id       = data.mso_site.onprem.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "cloud_only_aws_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_site.cloud_only_site_aws
  ]

  schema_id     = mso_schema.demo.id
  template_name = mso_schema_template.cloud_only.id
  site_id       = data.mso_site.aws.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "cloud_only_azure_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_site.cloud_only_site_azure
  ]

  schema_id     = mso_schema.demo.id
  template_name = mso_schema_template.cloud_only.id
  site_id       = data.mso_site.azure.id
  undeploy      = !local.templates_deploy
}
