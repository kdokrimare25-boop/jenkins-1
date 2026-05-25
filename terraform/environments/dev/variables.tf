# variables.tf — DEV environment inputs (declared once, values in terraform.tfvars)

variable "aws_region" {
  description = "AWS region for DEV."
  type        = string
}

variable "environment" {
  description = "Environment name — must be 'dev' for this stack."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project identifier used in naming and tags."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name (unique per region/account)."
  type        = string
}

# --- VPC ---

variable "vpc_cidr" {
  description = "DEV VPC CIDR — use a non-overlapping range per environment (test/prod get their own later)."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (one per AZ)."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (one per AZ)."
  type        = list(string)
}

variable "availability_zones" {
  description = "AZ names for ap-south-1 (or your region)."
  type        = list(string)

  validation {
    condition = (
      length(var.availability_zones) == length(var.public_subnet_cidrs) &&
      length(var.availability_zones) == length(var.private_subnet_cidrs)
    )
    error_message = "availability_zones and subnet CIDR lists must have the same length."
  }
}

variable "single_nat_gateway" {
  description = "DEV cost optimization: one NAT Gateway is acceptable."
  type        = bool
  default     = true
}

# --- EKS ---

variable "kubernetes_version" {
  description = "Kubernetes version; null = latest stable in region."
  type        = string
  default     = null
}

variable "node_instance_types" {
  description = "Worker instance types (DEV: smaller sizes)."
  type        = list(string)
}

variable "desired_size" {
  description = "Desired worker count."
  type        = number
}

variable "min_size" {
  description = "Minimum workers (autoscaling floor)."
  type        = number
}

variable "max_size" {
  description = "Maximum workers (autoscaling ceiling)."
  type        = number
}

variable "disk_size" {
  description = "Node root volume size (GiB)."
  type        = number
  default     = 50
}

variable "cluster_endpoint_public_access" {
  description = "Public Kubernetes API (restrict CIDRs in higher environments)."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Private Kubernetes API endpoint inside VPC."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDRs allowed to reach public API — tighten for test/prod."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
