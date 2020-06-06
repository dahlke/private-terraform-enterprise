terraform output -json | jq -r .acme_key.value > acme.key
terraform output -json | jq -r .acme_cert.value > acme.cert