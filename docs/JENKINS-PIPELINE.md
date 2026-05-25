# Jenkins Pipeline — Terraform DEV (EKS)

Beginner-friendly guide for the **Declarative** `Jenkinsfile` at the repository root.

| Item | Value |
|------|--------|
| **Repository** | `git@github.com:atulyw/cdec-b49.git` |
| **Branch** | `terraform-v2` |
| **Terraform path** | `terraform/environments/dev` |
| **Suggested job name** | `terraform-eks-dev-deploy` |

No Jenkins **parameters** — values are in the `environment` block inside the Jenkinsfile.

---

## 1. What each stage does

| # | Stage | What happens |
|---|--------|----------------|
| 1 | **Checkout Code** | Clone `cdec-b49` @ `terraform-v2` onto the agent |
| 2 | **Terraform Version** | Print `terraform version` and `aws --version` |
| 3 | **Terraform Init** | `terraform init` in DEV folder |
| 4 | **Terraform Format Check** | `terraform fmt -check -recursive` under `terraform/` |
| 5 | **Terraform Validate** | `terraform validate` in DEV folder |
| 6 | **Terraform Plan** | `terraform plan -out=tfplan` — preview AWS changes |
| 7 | **Manual Approval** | Human must click **Apply** in Jenkins UI |
| 8 | **Terraform Apply** | `terraform apply -auto-approve tfplan` |

---

## 2. How Jenkins checks out the GitHub repository

The pipeline uses **Git SCM** with an explicit URL and branch (not only the job’s SCM settings):

```groovy
checkout([
  $class: 'GitSCM',
  branches: [[name: '*/terraform-v2']],
  userRemoteConfigs: [[
    url: 'git@github.com:atulyw/cdec-b49.git',
    credentialsId: 'github-ssh-cdec-b49'
  ]]
])
```

Flow:

```text
Jenkins controller/agent
    → uses stored SSH private key (credential)
    → git clone git@github.com:atulyw/cdec-b49.git
    → checks out branch terraform-v2
    → workspace contains terraform/environments/dev/ ...
```

---

## 3. Why SSH access is needed

The remote URL is **`git@github.com:...`** (SSH), not `https://github.com/...`.

- Git speaks to GitHub on port **22** using an **SSH key**.
- Jenkins stores the private key as a **credential** (`github-ssh-cdec-b49`).
- The matching **public** key must be added to GitHub (deploy key or user SSH keys).

Without SSH setup you will see: `Permission denied (publickey)` or host verification errors.

---

## 4. Why `terraform plan` is important

- Lists resources to **add, change, or destroy** before anything runs.
- Catches wrong region, CIDR, or accidental deletes.
- Saves **`tfplan`** so **apply** executes the **same** plan you reviewed.

---

## 5. Why manual approval before apply

- Stops fully automatic changes to AWS after plan.
- Gives a human time to read the plan log in Jenkins.
- Even **DEV** can cost money or break networking — approval is a simple safety gate.

Implemented with Jenkins **`input`** step (build pauses until **Apply** is clicked).

---

## 6. Why `terraform fmt` matters

- One consistent style for modules and environments.
- `-check` fails CI if someone commits unformatted `.tf` files.
- Fix locally: `terraform fmt -recursive` from the `terraform/` folder.

---

## 7. How Jenkins executes Terraform

Jenkins runs **shell steps** on an **agent** (VM, EC2, or Kubernetes pod):

```text
checkout → cd terraform/environments/dev → terraform init/plan/apply
```

The agent must have:

- `terraform` on `PATH`
- Valid **AWS credentials** (env vars, `~/.aws/credentials`, or IAM instance profile)

Jenkins does not replace Terraform — it orchestrates the same commands you would run manually.

---

## 8. Why DEV should stay simple initially

- One branch, one environment, **no parameters** → easier debugging.
- Learn **plan → approve → apply** before adding test/prod.
- Matches current repo layout: only `environments/dev` is fully implemented.

---

## Suggested Jenkins job setup

1. **New Item** → name: `terraform-eks-dev-deploy`
2. Type: **Pipeline**
3. **Pipeline script from SCM** (optional if Jenkinsfile is only loaded from repo after checkout — many teams use **Pipeline script** pointing to SCM with Jenkinsfile path `Jenkinsfile` on branch `terraform-v2`)

**Important:** If the job *also* defines SCM, the explicit `checkout` in stage 1 still clones the repo defined in the Jenkinsfile `environment` block. Keep credential ID in sync.

Alternatively: **Pipeline script** pasted from repo — first stage checkout still pulls `terraform-v2`.

Recommended: **Multibranch Pipeline** or single Pipeline job with SCM branch `terraform-v2`, script path `Jenkinsfile`.

---

## Recommended Jenkins plugins

| Plugin | Purpose |
|--------|---------|
| **Pipeline** | Declarative Jenkinsfile |
| **Git** | GitSCM checkout |
| **SSH Credentials** | Store GitHub private key |
| **Credentials Binding** | (Optional) AWS keys |
| **AnsiColor** | `ansiColor('xterm')` |
| **Timestamper** | Works with `timestamps()` |
| **Workspace Cleanup** | `cleanWs()` in `post { always }` |

---

## Recommended Jenkins credentials setup

### GitHub SSH (required)

1. Jenkins → **Manage Jenkins** → **Credentials** → add credential  
2. Kind: **SSH Username with private key**  
3. ID: `github-ssh-cdec-b49` (must match `GIT_CREDENTIALS_ID` in Jenkinsfile)  
4. Username: `git`  
5. Private key: paste key or use Jenkins-generated key  
6. GitHub → repo **Settings** → **Deploy keys** (read-only is enough for checkout) → add public key  

Test on the agent:

```bash
ssh -T git@github.com
git ls-remote git@github.com:atulyw/cdec-b49.git
```

### AWS (required for plan/apply)

Use one of:

- IAM **instance profile** on the Jenkins agent EC2
- Environment variables `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` on the agent
- Jenkins **AWS Credentials** plugin (bind into `withCredentials` in a future pipeline version)

Minimum IAM: permissions for VPC, EC2, EKS, IAM (roles), CloudWatch Logs.

---

## Folder structure for CI/CD

```text
cdec-b49/
├── Jenkinsfile                    # This pipeline
├── docs/JENKINS-PIPELINE.md
└── terraform/
    ├── modules/
    │   ├── vpc/
    │   └── eks/
    └── environments/
        ├── dev/                   # ← pipeline target
        ├── test/                  # future job
        └── prod/                  # future job
```

---

## Future improvements

| Improvement | Benefit |
|-------------|---------|
| **Parameters** | `ACTION=plan|apply`, choose env |
| **Separate jobs** | Plan on every PR; apply only manual job |
| **test / prod** | New folders + jobs + stricter approval |
| **Remote backend check** | Fail init if S3/DynamoDB unreachable |
| **Slack notifications** | Alert on failure or approval needed |
| **Destroy pipeline** | Separate job with extra approval for `terraform destroy` |
| **tfsec / Checkov** | Security scan before plan |

Example destroy job (future, not in current Jenkinsfile):

```bash
cd terraform/environments/dev
terraform plan -destroy -out=tfplan-destroy
# manual approval
terraform apply -auto-approve tfplan-destroy
```

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `Permission denied (publickey)` | Fix SSH credential ID and GitHub deploy key |
| `Couldn't find credentialsId` | Create `github-ssh-cdec-b49` in Jenkins |
| `terraform: not found` | Install Terraform on agent |
| `Error acquiring state lock` | Another apply running, or stale DynamoDB lock |
| `cleanWs` not found | Install Workspace Cleanup plugin |
| fmt failed | Run `terraform fmt -recursive` locally and push |

---

## After successful apply

```bash
aws eks update-kubeconfig --region ap-south-1 --name cdec-dev-eks
kubectl get nodes
kubectl get pods -A
```

Optional nginx test:

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl get svc nginx
```
