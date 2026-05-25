# outputs.tf — DEV stack outputs for operators and CI

# VPC
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "DEV VPC ID."
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnets for workloads."
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnets for LBs and NAT."
}

# EKS
output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name."
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Kubernetes API URL."
}

output "cluster_arn" {
  value       = module.eks.cluster_arn
  description = "EKS cluster ARN."
}

output "cluster_security_group_id" {
  value       = module.eks.cluster_security_group_id
  description = "Cluster security group."
}

output "node_group_arn" {
  value       = module.eks.node_group_arn
  description = "Managed node group ARN."
}

output "oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "OIDC ARN for IRSA roles."
}

output "eks_cluster_version" {
  value       = module.eks.eks_cluster_version
  description = "Running Kubernetes version."
}

output "configure_kubectl" {
  description = "Command to configure kubectl for this cluster."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
