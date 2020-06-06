/*
output "demo_fqdn" {
  value = "${module.demo.demo_fqdn}"
}
output "replicated_console" {
  value = "http://${module.demo.demo_fqdn}:8800"
}

output "replicated_console_password" {
  value = "${random_pet.replicated-pwd.id}"
}
*/

output "pmd_fqdn" {
  value = module.pmd.pmd_fqdn
}

output "replicated_console" {
  value = "http://${module.pmd.pmd_fqdn}:8800"
}

output "replicated_console_password" {
  value = random_pet.replicated-pwd.id
}

/*
output "pes_fqdn" {
  value = "${module.pes.pes_fqdn}"
}
output "pes_replicated_console" {
  value = "http://${module.pes.pes_fqdn}:8800"
}

output "pes_pg_endpoint" {
  value = "${module.pes.pg_endpoint}"
}

output "pes_pg_name" {
  value = "${module.pes.pg_name}"
}

output "pes_pg_username" {
  value = "${module.pes.pg_username}"
}

output "pes_pg_password" {
  value = "${module.pes.pg_password}"
}

output "pes_s3_bucket_name" {
  value = "${module.pes.s3_bucket_name}"
}
*/

output "acme_key" {
  value = acme_certificate.certificate.private_key_pem
}

output "acme_cert" {
  value = acme_certificate.certificate.certificate_pem
}

