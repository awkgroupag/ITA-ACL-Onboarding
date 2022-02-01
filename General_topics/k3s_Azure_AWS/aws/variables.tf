# input variables for module AWS
#
# from Main
variable "env" {}
variable "email" {}
variable "project" {}
variable "username" {}

# from main configuration
variable "cidr_azure_vnet" {}

variable "cidr_aws_vpc" {}
variable "cidr_aws_subnet" {}

# From other modules
variable "pip-azure-vpn-gw" {}
