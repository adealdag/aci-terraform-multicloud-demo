output "schema_id" {
  value = mso_schema.demo.id
}

output "stretched_template_name" {
  value = mso_schema.demo.template_name
}

output "onprem_only_template_name" {
  value = mso_schema_template.onprem_only.id
}

output "cloud_only_template_name" {
  value = mso_schema_template.cloud_only.id
}

output "vrf_name" {
  value = mso_schema_template_vrf.main.name
}

output "bd1_name" {
  value = mso_schema_template_bd.bd1.name
}

output "bd2_name" {
  value = mso_schema_template_bd.bd2.name
}

