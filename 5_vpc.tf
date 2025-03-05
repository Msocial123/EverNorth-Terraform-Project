#https://developer.hashicorp.com/terraform/language/resources/syntax
#https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.56.0
#https://terraformguru.com/terraform-real-world-on-aws-ec2/06-AWS-VPC/06-02-AWS-VPC-using-Terraform/
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  create_vpc = var.create_vpc
  name       = var.vpc_name #"${local.name}-${var.vpc_name}"
  cidr       = var.vpc_cidr_block

  # No. of AZ and subnets
  azs              = var.vpc_availability_zones
  public_subnets   = var.vpc_public_subnets #ALB & Bastion
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets

  # Ensure public subnets have auto-assigned public IP addresses
  map_public_ip_on_launch = true

  # Database Subnets
  create_database_subnet_group           = var.vpc_create_database_subnet_group
  create_database_subnet_route_table     = var.vpc_create_database_subnet_route_table
  create_database_nat_gateway_route      = var.vpc_database_nat_gateway_route
  create_database_internet_gateway_route = var.vpc_database_igw_gateway_route #IGW_route and NAT_route for DB cannot be true simultaneously]

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  # IGW for public subnet in vpc
  enable_vpn_gateway = var.vpc_create_igw

  # Tag VPC and all resurce under vpc
  tags     = local.common_tags
  vpc_tags = local.common_tags

  manage_default_network_acl = false

  # Additional Tags to Subnets needed by Ingress controller 
  public_subnet_tags = {
    Type                                            = "Public Subnets"
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "owned"
  }

  # Additional Tags to Subnets needed by Ingress controller 
  private_subnet_tags = {
    Type                                            = "Private Subnets"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "owned"
  }

}