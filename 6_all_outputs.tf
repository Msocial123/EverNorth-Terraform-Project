################################################################################
# VPC
################################################################################

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#output_database_subnets
# VPC Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# Database Subnet
output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# Internet Gateway Id
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}


# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}


################################################################################
# RDS
################################################################################

output "rds_endpoint" {
  value = module.rds_instance.db_instance_endpoint
}

output "rds_database_name" {
  value = module.rds_instance.db_instance_name
}

output "rds_instance_username" {
  value     = module.rds_instance.db_instance_username
  sensitive = true
}

output "secrets_manager" {
  value = module.secrets_manager
}

output "aws_secretsmanager_secrets" {
  value     = data.aws_secretsmanager_secret_version.secret_credentials.secret_string
  sensitive = true
}

# output "rds_password" {
#   value = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_password"]
#   sensitive = true
# }





################################################################################
# EKS
################################################################################

output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}


output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}


output "oidc_provider_https_url" {
  value = module.eks.cluster_oidc_issuer_url
}


output "eks_cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "eks_cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
}

output "eks_cluster_iam_role_unique_id" {
  value = module.eks.cluster_iam_role_unique_id
}

output "bastion_host_to_cluster_security_group_arn" {
  value = aws_security_group.bastion_host_to_cluster.arn
}

output "eks_cluster_security_group_arn" {
  value = module.eks.cluster_security_group_arn
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "eks_node_security_group_arn" {
  value = module.eks.node_security_group_arn
}

output "AmazonEKSLoadBalancerControllerRole_ARN" {
  value = aws_iam_role.AmazonEKSLoadBalancerControllerRole.arn
}

output "cluster_autoscaler_role_arn" {
  value = aws_iam_role.AmazonEKSClusterAutoScalerrRole.arn
}

output "service_account_autoscaler_autoscaler" {
  value = kubernetes_service_account.service-account-cluster-autoscaler.metadata
}

output "autoscaler_service_account_name" {
  value = [for sa in kubernetes_service_account.service-account-cluster-autoscaler.metadata : sa["name"]]
}

output "cluster_autoscaler_helm_metadata" {
  value = helm_release.cluster-autoscaler.metadata
}

################################################################################
# ROUTE 53 HOSTED ZONE
################################################################################

output "HostedZoneObject" {
  value = module.zones.route53_zone_zone_id
}

output "HostedZoneName" {
  value = keys(module.zones.route53_zone_zone_id)[0]
}

output "HostedZoneValue" {
  value = values(module.zones.route53_zone_zone_id)[0]
}

output "HostedZoneId" {
  value = module.zones.route53_zone_zone_id[var.domain_name]
}

################################################################################
# ACM
################################################################################

output "acm_arn" {
  value = module.acm.acm_certificate_arn
}

output "acm_certificate_validation_status" {
  value = module.acm.acm_certificate_status
}

output "acm_certificate_validation_domain" {
  value = module.acm.validation_domains
}