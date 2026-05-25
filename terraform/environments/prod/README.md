# PROD Environment (placeholder)

This folder is reserved for **production** workloads.

## Status

**Not implemented yet.** Deploy only from **DEV** until this stack is reviewed and approved.

## When you implement PROD

1. Copy the `../dev/` layout into this directory.
2. **Separate AWS account** (recommended) or at minimum separate VPC CIDR and state file.
3. State backend key example: `eks-platform/prod/terraform.tfstate`.
4. Production-oriented choices:
   - **NAT Gateway per AZ** (`single_nat_gateway = false`)
   - Larger instances and higher `min_size` / `max_size`
   - **Private-only API** or highly restricted public API CIDRs
   - **Pinned** `kubernetes_version` with documented upgrade runbooks
   - Longer CloudWatch log retention (adjust in EKS module)
   - VPC endpoints for ECR/S3 to reduce NAT dependency
5. Require **manual approval** for `terraform apply` in CI (GitHub Environments, etc.).

## DEV vs PROD design differences

| Area | DEV | PROD |
|------|-----|------|
| NAT | Often single | Per-AZ |
| Nodes | `t3.medium`, 1–3 | Larger types, higher minimum |
| API access | May allow `0.0.0.0/0` | VPN/CI CIDRs only |
| State | Local or shared bucket | Remote S3 + lock, strict IAM |
| Changes | Fast iteration | Change windows, backups |

## Naming convention

`<project>-prod-<resource>` — example cluster: `cdec-prod-eks`
