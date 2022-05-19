
### APP and EPGs
# Template level
resource "mso_schema_template_anp" "demo_app" {
  schema_id    = data.terraform_remote_state.network.outputs.schema_id
  template     = data.terraform_remote_state.network.outputs.stretched_template_name
  name         = "demo_app"
  display_name = "demo_app"
}

resource "mso_schema_template_anp_epg" "demo_web_epg" {
  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name      = mso_schema_template_anp.demo_app.name
  name          = "frontend_epg"
  display_name  = "frontend_epg"
  bd_name       = data.terraform_remote_state.network.outputs.bd1_name
  vrf_name      = data.terraform_remote_state.network.outputs.vrf_name
}

resource "mso_schema_template_anp_epg_selector" "demo_web_sel" {
  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name      = mso_schema_template_anp.demo_app.name
  epg_name      = mso_schema_template_anp_epg.demo_web_epg.name
  name          = "frontend_selector"
  expressions {
    key      = "custom:tier"
    operator = "equals"
    value    = "frontend"
  }
}

resource "mso_schema_template_anp_epg" "demo_app_epg" {
  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name      = mso_schema_template_anp.demo_app.name
  name          = "backend_epg"
  display_name  = "backend_epg"
  bd_name       = data.terraform_remote_state.network.outputs.bd1_name
  vrf_name      = data.terraform_remote_state.network.outputs.vrf_name
}

resource "mso_schema_template_anp_epg_selector" "demo_app_sel" {
  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name      = mso_schema_template_anp.demo_app.name
  epg_name      = mso_schema_template_anp_epg.demo_app_epg.name
  name          = "backend_selector"
  expressions {
    key      = "custom:tier"
    operator = "equals"
    value    = "backend"
  }
}

# Site level
resource "mso_schema_site_anp_epg_domain" "demo_web_epg_vmm" {
  schema_id            = data.terraform_remote_state.network.outputs.schema_id
  template_name        = data.terraform_remote_state.network.outputs.stretched_template_name
  site_id              = data.mso_site.onprem.id
  anp_name             = mso_schema_template_anp.demo_app.name
  epg_name             = mso_schema_template_anp_epg.demo_web_epg.name
  domain_type          = "vmmDomain"
  dn                   = "VZ_DMZ"
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
}

resource "mso_schema_site_anp_epg_domain" "demo_app_epg_vmm" {
  schema_id            = data.terraform_remote_state.network.outputs.schema_id
  template_name        = data.terraform_remote_state.network.outputs.stretched_template_name
  site_id              = data.mso_site.onprem.id
  anp_name             = mso_schema_template_anp.demo_app.name
  epg_name             = mso_schema_template_anp_epg.demo_app_epg.name
  domain_type          = "vmmDomain"
  dn                   = "VZ_DMZ"
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
}

### L3OUT

# Template level
resource "mso_schema_template_external_epg" "internet_l3epg" {
  schema_id         = data.terraform_remote_state.network.outputs.schema_id
  template_name     = data.terraform_remote_state.network.outputs.cloud_only_template_name
  external_epg_name = "internet_l3epg"
  display_name      = "internet_l3epg"
  external_epg_type = "cloud"
  vrf_schema_id     = data.terraform_remote_state.network.outputs.schema_id
  vrf_template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  vrf_name          = data.terraform_remote_state.network.outputs.vrf_name
  anp_schema_id     = data.terraform_remote_state.network.outputs.schema_id
  anp_template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name          = mso_schema_template_anp.demo_app.name
  #site_id           = [data.mso_site.aws.id, data.mso_site.azure.id]
  selector_name = "internet_selector"
  selector_ip   = "0.0.0.0/0"
}

### CONTRACTS

# Filters

resource "mso_schema_template_filter_entry" "filter_api_3001" {
  schema_id          = data.terraform_remote_state.network.outputs.schema_id
  template_name      = data.terraform_remote_state.network.outputs.stretched_template_name
  name               = "api"
  display_name       = "api"
  entry_name         = "api_3001"
  entry_display_name = "api_3001"
  ether_type         = "ip"
  ip_protocol        = "tcp"
  destination_from   = "3001"
  destination_to     = "3001"
}

resource "mso_schema_template_filter_entry" "filter_api_icmp" {
  schema_id          = data.terraform_remote_state.network.outputs.schema_id
  template_name      = data.terraform_remote_state.network.outputs.stretched_template_name
  name               = "api"
  display_name       = "api"
  entry_name         = "icmp"
  entry_display_name = "icmp"
  ether_type         = "ip"
  ip_protocol        = "icmp"
}

resource "mso_schema_template_filter_entry" "filter_web_http" {
  schema_id          = data.terraform_remote_state.network.outputs.schema_id
  template_name      = data.terraform_remote_state.network.outputs.stretched_template_name
  name               = "web"
  display_name       = "web"
  entry_name         = "http"
  entry_display_name = "http"
  ether_type         = "ip"
  ip_protocol        = "tcp"
  destination_from   = "http"
  destination_to     = "http"
}

resource "mso_schema_template_filter_entry" "filter_web_https" {
  schema_id          = data.terraform_remote_state.network.outputs.schema_id
  template_name      = data.terraform_remote_state.network.outputs.stretched_template_name
  name               = "web"
  display_name       = "web"
  entry_name         = "https"
  entry_display_name = "https"
  ether_type         = "ip"
  ip_protocol        = "tcp"
  destination_from   = "https"
  destination_to     = "https"
}

resource "mso_schema_template_filter_entry" "filter_web_icmp" {
  schema_id          = data.terraform_remote_state.network.outputs.schema_id
  template_name      = data.terraform_remote_state.network.outputs.stretched_template_name
  name               = "web"
  display_name       = "web"
  entry_name         = "icmp"
  entry_display_name = "icmp"
  ether_type         = "ip"
  ip_protocol        = "icmp"
}

# Contracts
resource "mso_schema_template_contract" "permit_api" {
  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  contract_name = "permit_api"
  display_name  = "permit_api"
  filter_type   = "bothWay"
  scope         = "context"
  filter_relationship {
    filter_schema_id     = data.terraform_remote_state.network.outputs.schema_id
    filter_template_name = data.terraform_remote_state.network.outputs.stretched_template_name
    filter_name          = "api"
  }
  directives = ["none"]
}

resource "mso_schema_template_contract" "permit_web" {
  schema_id     = data.terraform_remote_state.network.outputs.schema_id
  template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  contract_name = "permit_web"
  display_name  = "permit_web"
  filter_type   = "bothWay"
  scope         = "context"
  filter_relationship {
    filter_schema_id     = data.terraform_remote_state.network.outputs.schema_id
    filter_template_name = data.terraform_remote_state.network.outputs.stretched_template_name
    filter_name          = "web"
  }
  directives = ["none"]
}

# Consumers and providers
resource "mso_schema_template_anp_epg_contract" "app_provider_api" {
  schema_id         = data.terraform_remote_state.network.outputs.schema_id
  template_name     = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name          = mso_schema_template_anp.demo_app.name
  epg_name          = mso_schema_template_anp_epg.demo_app_epg.name
  contract_name     = mso_schema_template_contract.permit_api.contract_name
  relationship_type = "provider"
}

resource "mso_schema_template_anp_epg_contract" "web_consumer_api" {
  schema_id         = data.terraform_remote_state.network.outputs.schema_id
  template_name     = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name          = mso_schema_template_anp.demo_app.name
  epg_name          = mso_schema_template_anp_epg.demo_web_epg.name
  contract_name     = mso_schema_template_contract.permit_api.contract_name
  relationship_type = "consumer"
}

resource "mso_schema_template_anp_epg_contract" "web_provider_web" {
  schema_id         = data.terraform_remote_state.network.outputs.schema_id
  template_name     = data.terraform_remote_state.network.outputs.stretched_template_name
  anp_name          = mso_schema_template_anp.demo_app.name
  epg_name          = mso_schema_template_anp_epg.demo_web_epg.name
  contract_name     = mso_schema_template_contract.permit_web.contract_name
  relationship_type = "provider"
}

resource "mso_schema_template_external_epg_contract" "inet_consumer_web" {
  schema_id              = data.terraform_remote_state.network.outputs.schema_id
  template_name          = data.terraform_remote_state.network.outputs.cloud_only_template_name
  external_epg_name      = mso_schema_template_external_epg.internet_l3epg.external_epg_name
  contract_name          = mso_schema_template_contract.permit_web.contract_name
  contract_template_name = data.terraform_remote_state.network.outputs.stretched_template_name
  relationship_type      = "consumer"
}
