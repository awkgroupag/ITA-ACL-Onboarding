# Configure the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Environment = "${var.env}"
      Owner = "${var.email}"
      Project = "${var.project}"
    }
  }
}


#-----------------------------------------------------------------------
# create vpc
resource "aws_vpc" "vn2" {
  cidr_block = "${var.cidr_aws_vpc}"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-aws-vnet"
  }
}

# create internet GW for public access to VM (for testing)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vn2.id

  tags = {
    Name = "${var.project}-igw"
  }
}

#-----------------------------------------------------------------------
# configure allowed protocols in default security group
resource "aws_default_security_group" "vpntest-sg" {
  vpc_id      = aws_vpc.vn2.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vn2.cidr_block,"${var.cidr_azure_vnet}", "0.0.0.0/0"]
  }

  ingress {
    description      = "ICMP from VPC"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = [aws_vpc.vn2.cidr_block,"${var.cidr_azure_vnet}", "0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project}-sg"
  }
}


#-----------------------------------------------------------------------
# create subnet
resource "aws_subnet" "sub1" {
  availability_zone = "eu-central-1a"

  vpc_id     = aws_vpc.vn2.id
  cidr_block = "${var.cidr_aws_subnet}"
  
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project}-subnet"
  }
}

#-----------------------------------------------------------------------
# create Customer Gateway .. needs to have valid IP address of Azure VPN gateway
resource "aws_customer_gateway" "azure-cgw" {
  bgp_asn    = 65034
  ip_address = "${var.pip-azure-vpn-gw}"
  type       = "ipsec.1"
  
  tags = {
    Name = "${var.project}-azure-cgw"
  }
}

#-----------------------------------------------------------------------
# create Virtual Private Gateway, attach to VPC
resource "aws_vpn_gateway" "vpn-gw" {
  vpc_id = aws_vpc.vn2.id

  tags = {
    Name = "${var.project}-vpn-gw"
  }
}

#-----------------------------------------------------------------------
# create site-to-site VPN connection
# target GW type VPG, routing static
# export public IP address and PSK
resource "aws_vpn_connection" "vpn-conn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn-gw.id
  customer_gateway_id = aws_customer_gateway.azure-cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
  local_ipv4_network_cidr = "${var.cidr_azure_vnet}"
  remote_ipv4_network_cidr = "${var.cidr_aws_vpc}"
  

  tags = {
    Name = "${var.project}-vpn-conn"
  }
}
output "pip-aws-vpn-gw-tunnel1" {
  value = "${aws_vpn_connection.vpn-conn.tunnel1_address}"
}
output "vpn-conn-tunnel1-psk" {
  value = "${aws_vpn_connection.vpn-conn.tunnel1_preshared_key}"
}
output "pip-aws-vpn-gw-tunnel2" {
  value = "${aws_vpn_connection.vpn-conn.tunnel2_address}"
}
output "vpn-conn-tunnel2-psk" {
  value = "${aws_vpn_connection.vpn-conn.tunnel2_preshared_key}"
}

# add static route to VPN connection
resource "aws_vpn_connection_route" "azure" {
  destination_cidr_block = "${var.cidr_azure_vnet}"
  vpn_connection_id      = aws_vpn_connection.vpn-conn.id
}

# configure routing, see https://docs.aws.amazon.com/vpn/latest/s2svpn/SetUpVPNConnections.html
resource "aws_default_route_table" "vpntest-route-table" {
  default_route_table_id = aws_vpc.vn2.default_route_table_id

  route {
    cidr_block = "${var.cidr_azure_vnet}"
    gateway_id = aws_vpn_gateway.vpn-gw.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-route-table"
  }
}

#-----------------------------------------------------------------------
# create VM in local subnet
resource "aws_key_pair" "id-aws-key" {
  key_name   = "id_aws-key"
  public_key = file("~/.ssh/id_aws.pub")

  tags = {
    Name = "${var.project}-id-aws-key"
  }
}

resource "aws_network_interface" "vm2-nic" {
  subnet_id   = aws_subnet.sub1.id
  private_ips = ["10.2.1.10"]
  
  tags = {
    Name = "${var.project}-aws-vm2-nic"
  }
}

resource "aws_instance" "vm3" {
  availability_zone = "eu-central-1a"
  ami               = "ami-0d527b8c289b4af7f" # Ubuntu 20.04 LTS
  instance_type     = "t2.small" # 1 vCPU, 2 GB RAM
  #instance_type     = "t2.micro" # 1 vCPU, 1 GB RAM
  key_name = aws_key_pair.id-aws-key.key_name

  network_interface {
    network_interface_id = aws_network_interface.vm2-nic.id
    device_index         = 0
  }

  tags = {
    Name = "${var.project}-aws-vm3"

  }
}

resource "aws_eip" "eip-vm3" {
  vpc = true
  instance                  = aws_instance.vm3.id
  associate_with_private_ip = "10.2.1.10"
  depends_on                = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project}-eip-vm3"
  }
}