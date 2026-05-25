# AWS EKS Platform — Multi-Environment Terraform

Enterprise-style layout for **VPC + EKS** on AWS. Reusable **modules** live under `modules/`; each **environment** is an independent Terraform root under `environments/`.

**Currently deployed:** `environments/dev` only. `test` and `prod` are placeholders for future stacks.

---

## 1. Project overview

This project provisions:

1. **VPC** — public/private subnets, IGW, NAT, routes, **EKS subnet tags**
2. **EKS** — cluster, managed node group (private subnets), IAM, security groups, OIDC (IRSA), CloudWatch control plane logs

Designed for teams that will grow from DEV → TEST → PROD without rewriting modules.

---

## 2. Architecture

```text
Internet
    |
Internet Gateway
    |
+---+-------------------+
| Public subnets (2 AZ) |  kubernetes.io/role/elb = 1
| NAT Gateway (DEV: 1)  |
+---+-------------------+
    |
+---+-------------------+
| Private subnets       |  kubernetes.io/role/internal-elb = 1
| EKS worker nodes      |  Nodes: NO public IPs
| (Managed Node Group)|
+---+-------------------+
    |
EKS Control Plane (AWS-managed ENIs in VPC subnets)
```

**Why private subnets for nodes?** Application pods run on workers that should not sit on the public internet. Outbound image pulls and patches go through **NAT**. Inbound user traffic hits **load balancers** in public subnets, not nodes directly.

---

## 3. Folder structure

```text
terraform/
├── modules/
│   ├── vpc/          # Reusable network (no provider block)
│   └── eks/          # Reusable cluster + node group
├── environments/
│   ├── dev/          # ✅ Full stack — run Terraform here
│   ├── test/         # 📁 README only (future)
│   └── prod/         # 📁 README only (future)
├── .gitignore
└── README.md
```

| Path | Responsibility |
|------|----------------|
| `modules/*` | **How** to build VPC/EKS (reusable, no backend) |
| `environments/dev` | **What** to deploy in DEV (tfvars, backend, wiring) |
| `environments/test/prod` | Same pattern later, **isolated state** |

---

## 4. How modules work

**Modules** are functions: inputs (`variables`) → resources → outputs.

DEV `main.tf` example:

```hcl
module "vpc" { source = "../../modules/vpc" ... }
module "eks" {
  source             = "../../modules/eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ...
}
```

**Why modules improve reusability**

- Fix a bug or add VPC endpoints once in `modules/vpc`, benefit all environments.
- TEST/PROD copy `dev/` and only change `terraform.tfvars` and backend key.
- Modules stay free of `backend` blocks — each environment owns its state.

---

## 5. Environment strategy

| Environment | Status | Purpose |
|-------------|--------|---------|
| **dev** | Implemented | Learning, feature work, lowest cost |
| **test** | Placeholder | Integration / pre-prod validation |
| **prod** | Placeholder | Customer-facing, strict controls |

**Why separate environments?**

- **Blast radius** — a bad `apply` in DEV must not delete PROD networking.
- **State isolation** — separate `terraform.tfstate` per env (different S3 keys).
- **Sizing & cost** — DEV uses `t3.medium` and one NAT; PROD uses larger nodes and HA NAT.
- **Compliance** — PROD can live in another AWS account with stricter IAM.

**Tagging standards** (`local.common_tags` in DEV):

- `Environment`, `Project`, `ManagedBy` — enable cost allocation, access policies, and audits in AWS Resource Groups & Cost Explorer.

---

## 6. Remote backend and state locking

See `environments/dev/backend.tf`.

| Concept | Why it matters |
|---------|----------------|
| **S3 backend** | Shared, durable state; not lost on laptop failure |
| **DynamoDB lock** | Prevents two applies corrupting the same state |
| **Per-env `key`** | `eks-platform/dev/...` vs `.../prod/...` |

Until you uncomment the backend block, DEV uses **local state** in `environments/dev/terraform.tfstate` (acceptable for solo work).

---

## 7. Deploy DEV — Terraform workflow

```bash
cd terraform/environments/dev

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Destroy lab:

```bash
terraform destroy
```

**Prerequisites:** AWS CLI credentials with permissions for EC2, EKS, IAM, VPC, CloudWatch Logs.

---

## 8. Suggested naming convention

| Resource | Pattern | DEV example |
|----------|---------|-------------|
| Cluster | `<project>-<env>-eks` | `cdec-dev-eks` |
| VPC | `<project>-<env>-vpc` (tag Name) | `cdec-dev-vpc` |
| Node group | `<cluster>-workers` | `cdec-dev-eks-workers` |
| State key | `eks-platform/<env>/terraform.tfstate` | `.../dev/...` |

Use **lowercase** and hyphens for EKS cluster names.

---

## 9. Cost optimization (DEV)

- `single_nat_gateway = true` — one NAT instead of per-AZ.
- `t3.medium` nodes, `max_size = 3` — cap burst spend.
- `disk_size = 50` — avoid oversized EBS.
- Destroy stack when not in use: `terraform destroy`.
- After cluster exists, consider **VPC endpoints** for ECR/S3 to cut NAT data processing.

---

## 10. Security best practices

- Keep workers in **private subnets** (this project does).
- Tighten `cluster_endpoint_public_access_cidrs` before TEST/PROD.
- Use **IRSA** (`oidc_provider_arn` output) instead of static AWS keys in pods.
- Enable **IMDSv2** on nodes (launch template in EKS module).
- Encrypt node volumes (gp3 encrypted in module).
- Least privilege: add IAM policies per app via IRSA, not broad node policies.

---

## 11. After cluster creation (bonus)

### Install kubectl

macOS: `brew install kubectl`  
Or: https://kubernetes.io/docs/tasks/tools/

### Update kubeconfig

```bash
aws eks update-kubeconfig --region ap-south-1 --name cdec-dev-eks
# Or:
terraform output -raw configure_kubectl
```

### Verify cluster

```bash
kubectl get nodes
kubectl get pods -A
kubectl cluster-info
```

### Deploy nginx test app

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl get svc nginx -w
```

Clean up:

```bash
kubectl delete svc nginx
kubectl delete deployment nginx
```

---

## 12. Common troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `Subnet not tagged` for LB | Missing ELB tags | VPC module tags; cluster name must match |
| Nodes `NotReady` | NAT/SG/IAM | Check NAT routes; node IAM policies |
| `Error acquiring state lock` | Stale lock | `terraform force-unlock <id>` after confirming no running apply |
| Wrong region/AZ | tfvars mismatch | Use AZs valid for `aws_region` |
| Auth to API fails | IAM/kubeconfig | `update-kubeconfig`; EKS access entry / IAM identity |

---

## 13. Future improvements

- Implement **test** and **prod** under `environments/`
- Uncomment **S3 + DynamoDB** backend per environment
- Add **VPC endpoints** module
- Add **EKS access entries** and RBAC for CI/CD
- Install **AWS Load Balancer Controller** (IRSA)
- **Helm** or GitOps (Argo CD) in a separate repo
- **Checkov/tfsec** in CI pipeline

---

## 14. Module reference (quick)

### VPC module (`modules/vpc`)

Inputs: `vpc_cidr`, subnet CIDRs, `availability_zones`, `cluster_name`, `environment`, `project_name`, `single_nat_gateway`  
Outputs: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, NAT/IGW IDs

### EKS module (`modules/eks`)

Inputs: `vpc_id`, subnet IDs, scaling, `node_instance_types`, endpoint flags  
Outputs: `cluster_endpoint`, `oidc_provider_arn`, `cluster_security_group_id`, etc.

---

## Questions a junior engineer should be able to answer

1. **Where do I run Terraform?** → `terraform/environments/dev`
2. **Where is state stored?** → Local by default; S3 after enabling `backend.tf`
3. **Why are test/prod empty?** → Intentional; copy dev when ready with new CIDRs and state keys
4. **Can I use modules from test without duplicating code?** → Yes — same `../../modules/*` paths
