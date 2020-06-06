provider "aws" {
  region = var.aws_region
}

data "aws_route53_zone" "hashidemos" {
  name = "hashidemos.io."
}

#------------------------------------------------------------------------------
# instance user data
#------------------------------------------------------------------------------

resource "random_pet" "replicated-pwd" {
  length = 2
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.tpl")

  vars = {
    hostname       = "${var.namespace}.hashidemos.io"
    replicated_pwd = random_pet.replicated-pwd.id
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#------------------------------------------------------------------------------
# network
#------------------------------------------------------------------------------

module "network" {
  source    = "./network/"
  namespace = var.namespace
}

#------------------------------------------------------------------------------
# demo/poc ptfe
#------------------------------------------------------------------------------

/*
module "demo" {
  source                 = "./demo/"
  namespace              = "${var.namespace}"
  aws_instance_ami       = "${data.aws_ami.ubuntu.id}"
  aws_instance_type      = "${var.aws_instance_type}"
  subnet_id              = "${module.network.subnet_ids[0]}"
  vpc_security_group_ids = "${module.network.security_group_id}"
  user_data              = "${data.template_file.user_data.rendered}"
  ssh_key_name           = "${var.ssh_key_name}"
  hashidemos_zone_id     = "${data.aws_route53_zone.hashidemos.zone_id}"
  owner                  = "${var.owner}"
  ttl                    = "${var.ttl}"
}
*/

#------------------------------------------------------------------------------
# production mounted disk ptfe
#------------------------------------------------------------------------------

module "pmd" {
  source                 = "./pmd/"
  namespace              = var.namespace
  aws_instance_ami       = data.aws_ami.ubuntu.id
  aws_instance_type      = var.aws_instance_type
  subnet_id              = module.network.subnet_ids[0]
  vpc_security_group_ids = module.network.security_group_id
  user_data              = data.template_file.user_data.rendered
  ssh_key_name           = var.ssh_key_name
  hashidemos_zone_id     = data.aws_route53_zone.hashidemos.zone_id
  owner                  = var.owner
  ttl                    = var.ttl
}

#------------------------------------------------------------------------------
# production external-services ptfe
#------------------------------------------------------------------------------

/*
module "pes" {
  source                 = "./pes/"
  namespace              = "${var.namespace}"
  aws_instance_ami       = "${data.aws_ami.ubuntu.id}"
  aws_instance_type      = "${var.aws_instance_type}"
  subnet_ids             = "${module.network.subnet_ids}"
  vpc_security_group_ids = "${module.network.security_group_id}"
  // user_data              = ""
  user_data            = "${data.template_file.user_data.rendered}"
  ssh_key_name         = "${var.ssh_key_name}"
  hashidemos_zone_id   = "${data.aws_route53_zone.hashidemos.zone_id}"
  database_pwd         = "${random_pet.replicated-pwd.id}"
  db_subnet_group_name = "${module.network.db_subnet_group_id}"
  owner                = "${var.owner}"
  ttl                  = "${var.ttl}"
}
*/

/* Cert */
provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# TODO: fix this
resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "neil@hashicorp.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "hashidemos.io"
  subject_alternative_names = ["${var.namespace}-pmd.hashidemos.io", "${var.namespace}-pmd7.hashidemos.io"]

  dns_challenge {
    provider = "route53"
  }
}

