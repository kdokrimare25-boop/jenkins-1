# TEST Environment (placeholder)

This folder is reserved for the **test** (pre-production) environment.

## Status

**Not implemented yet.** Only **DEV** is wired to `modules/vpc` and `modules/eks` today.

## When you implement TEST

1. Copy files from `../dev/`:
   - `provider.tf`
   - `backend.tf`
   - `main.tf`
   - `variables.tf`
   - `outputs.tf`
   - `terraform.tfvars` (adjust values)
2. Use a **separate state key**, e.g. `eks-platform/test/terraform.tfstate`.
3. Use a **non-overlapping VPC CIDR** (e.g. `10.20.0.0/16`).
4. Sizing between DEV and PROD:
   - Instance types: `t3.large` or `m6i.large`
   - Nodes: desired 3, min 2, max 6
   - Consider **NAT per AZ** for higher availability
5. Restrict `cluster_endpoint_public_access_cidrs` to CI/VPN CIDRs.
6. Pin `kubernetes_version` instead of `null`.

## Naming convention

`<project>-test-<resource>` — example cluster: `cdec-test-eks`
