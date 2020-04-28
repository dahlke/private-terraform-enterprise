terraform-0.11.14 output -json | jq -r .acme_key.value > acme.key
terraform-0.11.14 output -json | jq -r .acme_cert.value > acme.cert