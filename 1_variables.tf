################################################################################
# ENVIRONMENT
################################################################################

# Environment Variable
variable "aws_region" {
  description = "Region for AWS"
  type        = string
  default     = "us-east-1"
}


# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}

# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "Ajay"
}

# Path to config file for the Kubernetes provider as variable
variable "kubeconfig" {
  description = "kubectl_config_path"
  type        = string
  # Load the kubeconfig from your home directory (default location for Docker Desktop Kubernetes)
  default = "~/.kube/config"
}

################################################################################
# VPC
################################################################################

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "advance_k8s_vpc_ajay"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Availability Zones
variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# VPC Public Subnets - WEB
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC Private Subnets - APP
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# VPC Database Subnets - DB
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

# VPC Create Database Subnet Group (True / False)
variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
  default     = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
  default     = true
}

# VPC Database Subnet can communicate to internet (True or False)
variable "vpc_database_nat_gateway_route" {
  description = "Database Subnet can communicate to internet"
  type        = bool
  default     = true
}

# VPC Database Subnet can receive communicate from internet (True or False)
variable "vpc_database_igw_gateway_route" {
  description = "Database Subnet can receive communicate from internet"
  type        = bool
  default     = false
}


# VPC Enable NAT Gateway (True or False) 
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

variable "vpc_public_subnets_auto_assign_ip" {
  description = "Auto assign public IP to public subnet"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
  default     = true
}

variable "vpc_create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  type        = bool
  default     = true
}

# Key for EC2s
variable "ec2_key_name" {
  description = "Key attached to EC2 like Bastion host, Jenkins server, etc..."
  type        = string
  default     = "tf-key-pair"
}

################################################################################
# EKS
################################################################################

# EKS Cluster Name
variable "eks-cluster-name" {
  description = "Cluster Name"
  type        = string
  default     = "eks-advance_k8s_vpc_ajay"
}

# EKS Cluster Version
variable "eks-cluster-version" {
  description = "Cluster Name"
  type        = string
  default     = "1.27"
}


# EKS Cluster Node grpup Name
variable "eks-managed-nodegroup-name" {
  description = "eks-managed-nodegroup-name"
  type        = string
  default     = "eks-managed-nodegroup-adv-k8s"
}

variable "eks-managed-nodegroup-label" {
  description = "eks-managed-nodegroup-label"
  type        = string
  default     = "group1"
}

# ALB Controller service account name
variable "service_account_name_alb" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "ALB Controller service account name"
}

# Node autoscaler service account name
variable "service_account_name_autoscaler" {
  type        = string
  default     = "cluster-autoscaler"
  description = "EKS Node autoscaler service account name"
}

# Kubernetes namespace to deploy ALB Controller Helm chart and cluster-autoscaler
variable "kubesystem_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy ALB Controller Helm chart and cluster-autoscaler"
}

# ALB Controller repository name
variable "alb_helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "ALB Controller repository name."
}

variable "alb_helm_chart_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "ALB Controller Helm chart name to be installed"
}

variable "alb_helm_chart_release_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Helm release name"
}

variable "alb_helm_chart_version" {
  type        = string
  default     = "1.5.3"
  description = "ALB Controller Helm chart version."
}

variable "autoscaler_helm_chart_repo" {
  type        = string
  default     = "https://kubernetes.github.io/autoscaler"
  description = "Autoscaler helm repository name."
}

variable "autoscaler_helm_chart_version" {
  type        = string
  default     = "9.30.1"
  description = "Autoscaler Helm chart version."
}

variable "autoscaler_helm_chart_app_image" {
  type        = string
  default     = "registry.k8s.io/autoscaling/cluster-autoscaler"
  description = "Autoscaler app image repo."
}

variable "autoscaler_helm_chart_app_version" {
  type        = string
  default     = "v1.27.2"
  description = "Autoscaler app version."
}


################################################################################
# DATABSE
################################################################################

# DB Security group name
variable "rds_security_group_name" {
  description = "rds_security_group_name"
  type        = string
  default     = "rds_security_group_name"
}

# Bastion host Security group name
variable "bastion_security_group_name" {
  description = "bastion_security_group_name"
  type        = string
  default     = "bastion_host_security_group_name"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
  default     = "company"
}

variable "db_username" {
  type        = string
  description = "The username for database access"
  default     = "root"
}

variable "db_port" {
  type        = string
  description = "The port for database access"
  default     = "3306"
}


################################################################################
# SECURITY GROUP
################################################################################

# Replace "your_ip_address" with your actual IP address
variable "my_ip_address" {
  description = "Your allowed IP address"
  type        = string
  default     = "202.131.135.68/32" # Replace "your_ip_address" with your actual IP address
}



################################################################################
# ROUTE 53
################################################################################

variable "domain_name" {
  description = "The domain name for which you want to create resources."
  default     = "advancek8straining.online"
}