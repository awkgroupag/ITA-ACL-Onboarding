# Main variables for setup of VPN connection between Azure and AWS

# main values
variable env {
    default = "dev"
}
variable email {}

variable project {
    default = "vpntest"
}
variable username {}

# values for Azure
variable cidr_azure_vnet {
    default = "10.1.0.0/16"
}
variable cidr_azure_subnet {
    default = "10.1.1.0/24"
}
variable cidr_azure_gateway_subnet {
    default = "10.1.0.0/27"
}


# values for AWS
variable cidr_aws_vpc {
    default = "10.2.0.0/16"
}
variable cidr_aws_subnet {
    default = "10.2.1.0/24"
}