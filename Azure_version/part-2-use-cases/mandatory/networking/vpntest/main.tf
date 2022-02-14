terraform {
  
}

module "azure" {
  source = "./azure"

  # from main
  env = "${var.env}"
  email = "${var.email}"
  project = "${var.project}"
  username = "${var.username}"

  cidr_azure_vnet = "${var.cidr_azure_vnet}"
  cidr_azure_subnet = "${var.cidr_azure_subnet}"
  cidr_azure_gateway_subnet = "${var.cidr_azure_gateway_subnet}"

  cidr_aws_vpc = "${var.cidr_aws_vpc}"

  # from module AWS
  pip-aws-vpn-gw-tunnel1 = "${module.aws.pip-aws-vpn-gw-tunnel1}"
  vpn-conn-tunnel1-psk = "${module.aws.vpn-conn-tunnel1-psk}"
  pip-aws-vpn-gw-tunnel2 = "${module.aws.pip-aws-vpn-gw-tunnel2}"
  vpn-conn-tunnel2-psk = "${module.aws.vpn-conn-tunnel2-psk}"
}

module "aws" {
  source = "./aws"

  # from main
  env = "${var.env}"
  email = "${var.email}"
  project = "${var.project}"
  username = "${var.username}"

  cidr_azure_vnet = "${var.cidr_azure_vnet}"

  cidr_aws_vpc = "${var.cidr_aws_vpc}"
  cidr_aws_subnet = "${var.cidr_aws_subnet}"

  # from module Azure
  pip-azure-vpn-gw = "${module.azure.pip-azure-vpn-gw}"
}