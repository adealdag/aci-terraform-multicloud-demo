### VRF
# Template level
resource "mso_schema_template_vrf" "main" {
  template     = mso_schema.demo.template_name
  schema_id    = mso_schema.demo.id
  name         = "main_vrf"
  display_name = "main_vrf"
}

# Site Level - AWS
resource "mso_schema_site_vrf" "main_aws" {
  template_name = mso_schema.demo.template_name
  site_id       = data.mso_site.aws.id
  schema_id     = mso_schema.demo.id
  vrf_name      = mso_schema_template_vrf.main.name
}

resource "mso_schema_site_vrf_region" "main_aws_eu_central" {
  schema_id          = mso_schema.demo.id
  template_name      = mso_schema.demo.template_name
  site_id            = data.mso_site.aws.id
  vrf_name           = mso_schema_site_vrf.main_aws.vrf_name
  region_name        = "eu-central-1"
  vpn_gateway        = false
  hub_network_enable = true
  hub_network = {
    name        = "ams-tgw"
    tenant_name = "infra"
  }
  cidr {
    cidr_ip = "172.28.8.0/22"
    primary = true
    subnet {
      ip    = "172.28.8.0/25"
      zone  = "eu-central-1a"
      usage = "gateway"
    }
    subnet {
      ip    = "172.28.8.128/25"
      zone  = "eu-central-1b"
      usage = "gateway"
    }
    subnet {
      ip   = "172.28.9.0/24"
      zone = "eu-central-1a"
    }
    subnet {
      ip   = "172.28.10.0/24"
      zone = "eu-central-1b"
    }
  }
}

# Site Level - Azure
resource "mso_schema_site_vrf" "main_azure" {
  template_name = mso_schema.demo.template_name
  site_id       = data.mso_site.azure.id
  schema_id     = mso_schema.demo.id
  vrf_name      = mso_schema_template_vrf.main.name
}

resource "mso_schema_site_vrf_region" "main_azure_eu_central" {
  schema_id          = mso_schema.demo.id
  template_name      = mso_schema.demo.template_name
  site_id            = data.mso_site.azure.id
  vrf_name           = mso_schema_site_vrf.main_azure.vrf_name
  region_name        = "westeurope"
  vpn_gateway        = false
  hub_network_enable = true
  hub_network = {
    name        = "Default"
    tenant_name = "infra"
  }
  cidr {
    cidr_ip = "172.29.8.0/22"
    primary = true
    subnet {
      ip = "172.29.8.0/24"
    }
    subnet {
      ip = "172.29.9.0/24"
    }
  }
}

### BD
# Template level
resource "mso_schema_template_bd" "bd1" {
  schema_id              = mso_schema.demo.id
  template_name          = mso_schema.demo.template_name
  name                   = "192.168.1.0_24_bd"
  display_name           = "192.168.1.0_24_bd"
  vrf_name               = mso_schema_template_vrf.main.name
  layer2_unknown_unicast = "proxy"
  layer2_stretch         = true
  intersite_bum_traffic  = true
  optimize_wan_bandwidth = true
  unicast_routing        = true
}

resource "mso_schema_template_bd_subnet" "bd1net" {
  schema_id          = mso_schema.demo.id
  template_name      = mso_schema.demo.template_name
  bd_name            = mso_schema_template_bd.bd1.name
  ip                 = "192.168.1.1/24"
  scope              = "public"
  no_default_gateway = false
  shared             = false
}

resource "mso_schema_template_bd" "bd2" {
  schema_id              = mso_schema.demo.id
  template_name          = mso_schema.demo.template_name
  name                   = "192.168.2.0_24_bd"
  display_name           = "192.168.2.0_24_bd"
  vrf_name               = mso_schema_template_vrf.main.name
  layer2_unknown_unicast = "proxy"
  layer2_stretch         = true
  intersite_bum_traffic  = true
  optimize_wan_bandwidth = true
  unicast_routing        = true
}

resource "mso_schema_template_bd_subnet" "bd2net" {
  schema_id          = mso_schema.demo.id
  template_name      = mso_schema.demo.template_name
  bd_name            = mso_schema_template_bd.bd2.name
  ip                 = "192.168.2.1/24"
  scope              = "public"
  no_default_gateway = false
  shared             = false
}
