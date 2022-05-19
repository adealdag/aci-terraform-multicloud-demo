locals {
  templates_deploy = true
}

#
# Deploy templates
#
resource "mso_schema_template_deploy" "stretched_onprem_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_site_anp_epg_domain.demo_app_epg_vmm,
    mso_schema_site_anp_epg_domain.demo_web_epg_vmm,
    mso_schema_template_anp_epg_contract.app_provider_api,
    mso_schema_template_anp_epg_contract.web_consumer_api,
    mso_schema_template_anp_epg_contract.web_provider_web,
    mso_schema_template_external_epg_contract.inet_consumer_web,
    mso_schema_template_anp_epg_selector.demo_app_sel,
    mso_schema_template_anp_epg_selector.demo_web_sel
  ]

  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  site_id       = data.mso_site.onprem.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "stretched_aws_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_template_deploy.stretched_onprem_deployer
  ]

  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  site_id       = data.mso_site.aws.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "stretched_azure_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_template_deploy.stretched_onprem_deployer
  ]

  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  site_id       = data.mso_site.azure.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "onprem_only_onprem_deployer" {
  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.onprem_only_template_name
  site_id       = data.mso_site.onprem.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "cloud_only_aws_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_template_deploy.stretched_aws_deployer
  ]

  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.cloud_only_template_name
  site_id       = data.mso_site.aws.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "cloud_only_azure_deployer" {
  # depends_on required so that template is deployed only after all elements have been created
  depends_on = [
    mso_schema_template_deploy.stretched_azure_deployer
  ]

  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.cloud_only_template_name
  site_id       = data.mso_site.azure.id
  undeploy      = !local.templates_deploy
}
