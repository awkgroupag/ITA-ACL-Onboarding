# input variables for module Azure
#
# from Main
variable "env" {}
variable "email" {}
variable "project" {}
variable "username" {}

# from main configuration
variable "cidr_azure_vnet" {}
variable "cidr_azure_subnet" {}
variable "cidr_azure_gateway_subnet" {}

variable "cidr_aws_vpc" {}

# From other modules
variable "pip-aws-vpn-gw-tunnel1" {}
variable "vpn-conn-tunnel1-psk" {}
variable "pip-aws-vpn-gw-tunnel2" {}
variable "vpn-conn-tunnel2-psk" {}