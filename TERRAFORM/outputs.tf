output "cluster_name" {
  description = "Full EKS cluster name (base + suffix)"
  value       = module.retail_app_eks.cluster_name
}

output "cluster_name_base" {
  description = "Base cluster name without suffix"
  value       = var.cluster_name
}

output "cluster_name_suffix" {
  description = "Random suffix appended to cluster name"
  value       = random_string.suffix.result
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = module.retail_app_eks.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster"
  value       = module.retail_app_eks.cluster_version
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the EKS cluster (used for IRSA)"
  value       = module.retail_app_eks.cluster_oidc_issuer_url
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.retail_app_eks.cluster_security_group_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}
