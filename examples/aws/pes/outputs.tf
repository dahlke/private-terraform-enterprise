output "pes_fqdn" {
  value = "${aws_route53_record.pes.fqdn}"
}

output "pg_address" {
  value = "${aws_db_instance.pes.address}"
}

output "pg_endpoint" {
  value = "${aws_db_instance.pes.endpoint}"
}

output "pg_name" {
  value = "${aws_db_instance.pes.name}"
}

output "pg_username" {
  value = "${aws_db_instance.pes.username}"
}

output "pg_password" {
  value = "${var.database_pwd}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.pes.id}"
}