# cdec-b49 — AWS EKS Terraform Platform

Infrastructure-as-code for **Amazon EKS** using a multi-environment Terraform layout.

## Quick start (DEV only)

**Manual Terraform:**

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
aws eks update-kubeconfig --region ap-south-1 --name cdec-dev-eks
kubectl get nodes
```

**Jenkins (CI/CD):** root `Jenkinsfile` clones `git@github.com:atulyw/cdec-b49.git` branch `terraform-v2`. See [docs/JENKINS-PIPELINE.md](docs/JENKINS-PIPELINE.md). Job name: `terraform-eks-dev-deploy`. Credential ID: `github-ssh-cdec-b49`.

## Documentation

Full architecture, backend setup, naming, security, and troubleshooting:

**[terraform/README.md](terraform/README.md)**

## Layout

```text
terraform/
├── modules/          # vpc, eks (reusable)
└── environments/
    ├── dev/          # ✅ implemented
    ├── test/         # placeholder
    └── prod/         # placeholder
```

## Note on legacy files

If you see Terraform files at the **repository root** (`main.tf`, `modules/` at top level), use **`terraform/`** instead — that is the supported structure going forward.
