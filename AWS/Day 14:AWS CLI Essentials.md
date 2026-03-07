# Command-Line Interface: AWS CLI Essentials

**Training Notes for AWS & DevOps Beginners**

---

## Table of Contents

1. [Introduction to AWS CLI](#1-introduction-to-aws-cli)
2. [Installing AWS CLI](#2-installing-aws-cli)
3. [Configuring AWS CLI](#3-configuring-aws-cli)
4. [Using AWS CLI for S3 Management](#4-using-aws-cli-for-s3-management)
5. [Using AWS CLI for EC2 Management](#5-using-aws-cli-for-ec2-management)
6. [Practical Demo Commands](#6-practical-demo-commands)
7. [Best Practices](#7-best-practices)

---

## 1. Introduction to AWS CLI

### Definition of AWS CLI

**AWS CLI (Amazon Web Services Command-Line Interface)** is a unified tool that lets you interact with AWS services from your terminal or command prompt. Instead of clicking through the AWS Console (web interface), you run text-based commands to create, manage, and monitor your AWS resources.

### What is Command-Line Interface (CLI)

- A **CLI** is a program that accepts text commands to perform operations.
- You type commands in a terminal (Linux/Mac) or Command Prompt/PowerShell (Windows).
- Unlike a graphical user interface (GUI), there are no buttons or menus—only keyboard input and text output.
- Examples of CLI tools: `git`, `docker`, `kubectl`, and **AWS CLI**.

### Why AWS CLI is Used

- **Automation:** Script tasks and run them repeatedly without manual clicks.
- **Speed:** Execute complex operations faster than using the console.
- **CI/CD:** Integrate AWS operations into pipelines (Jenkins, GitHub Actions, etc.).
- **Remote access:** Manage AWS from servers, containers, or remote machines.
- **Reproducibility:** Same commands produce the same results every time.

### Advantages of AWS CLI Compared to AWS Console

| Aspect | AWS Console (Web UI) | AWS CLI |
|--------|----------------------|---------|
| **Speed** | Slower for repeated tasks | Fast for batch operations |
| **Automation** | Difficult to automate | Easy to script and automate |
| **Learning** | Click-based, visual | Command-based, consistent |
| **Remote use** | Needs browser, login | Works in terminals, scripts |
| **Documentation** | UI changes over time | Commands are stable and documentable |
| **CI/CD** | Not suitable | Ideal for pipelines |

### Real-World Use Cases of AWS CLI in DevOps and Cloud Operations

1. **Backup automation:** Schedule daily S3 backups using cron + AWS CLI.
2. **Infrastructure as Code:** Run AWS commands from scripts or Terraform/CloudFormation.
3. **Deployment scripts:** Deploy application files to S3, EC2, or Lambda.
4. **Monitoring:** Query CloudWatch metrics and logs from scripts.
5. **Bulk operations:** Start/stop many EC2 instances, tag resources, list all buckets.
6. **Troubleshooting:** Quickly describe instances, security groups, or RDS status.
7. **Cross-account operations:** Manage multiple AWS accounts from one machine.

---

## 2. Installing AWS CLI

### What is Required Before Installing AWS CLI

- **Operating system:** Windows, Linux, or macOS.
- **Internet access:** To download the installer.
- **Python 3.8+** (for installer v2) or use the standalone installer (no Python needed).
- **Administrator/sudo rights:** For system-wide installation (optional; user install possible).

### Installation Overview for Windows, Linux, and Mac

#### Windows

**Option 1: MSI Installer (Recommended)**

1. Download the AWS CLI MSI installer from: https://aws.amazon.com/cli/
2. Run the `.msi` file.
3. Follow the installation wizard.
4. Restart your terminal/Command Prompt after installation.

**Option 2: Using pip**

```powershell
pip install awscli
```

#### Linux

```bash
# Download and install AWS CLI v2 (64-bit Linux)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version
```

**Ubuntu/Debian using package manager:**

```bash
sudo apt update
sudo apt install awscli -y
```

#### Mac

**Using pip:**

```bash
pip3 install awscli --upgrade --user
```

**Using Homebrew:**

```bash
brew install awscli
```

**Using official installer:**

1. Download the macOS pkg from: https://aws.amazon.com/cli/
2. Run the installer.
3. Open a new terminal.

### How to Verify Installation

After installation, open a **new** terminal window and run:

```bash
aws --version
```

### Example Command to Check AWS CLI Version

```bash
aws --version
```

**Example output:**

```
aws-cli/2.13.0 Python/3.11.0 Linux/5.15.0-58-generic exe/x86_64.ubuntu.22
```

---

## 3. Configuring AWS CLI

### What is AWS CLI Configuration

AWS CLI needs **credentials** (access key and secret key) and optional settings (region, output format) to communicate with AWS. Configuration stores these values so you don't have to enter them with every command.

### IAM User Access Key and Secret Key Explanation

- **Access Key ID:** A 20-character identifier (e.g., `AKIAIOSFODNN7EXAMPLE`). Identifies your IAM user to AWS.
- **Secret Access Key:** A 40-character secret (e.g., `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`). Proves you own the access key. **Never share or commit to code.**

You create these in **IAM Console → Users → Security credentials → Create access key**.

### aws configure Command Explanation

The `aws configure` command interactively asks for your credentials and default settings and saves them in `~/.aws/credentials` and `~/.aws/config`.

### Meaning of Each Configuration Field

| Field | Purpose | Example |
|-------|---------|---------|
| **Access Key** | Identifies your IAM user to AWS | `AKIAIOSFODNN7EXAMPLE` |
| **Secret Key** | Authenticates requests; keep private | `wJalrXUtnFEMI/K7MDENG/...` |
| **Region** | Default region for API calls (e.g., us-east-1) | `us-east-1` |
| **Output format** | How results are displayed | `json`, `table`, `text`, `yaml` |

### Example Configuration Workflow

```bash
aws configure
```

**Interactive prompts:**

```
AWS Access Key ID [********************]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [********************]: wJalrXUtnFEMI/K7MDENG/...
Default region name [us-east-1]: us-east-1
Default output format [json]: json
```

**Non-interactive (scripted) configuration:**

```bash
aws configure set aws_access_key_id AKIAIOSFODNN7EXAMPLE
aws configure set aws_secret_access_key wJalrXUtnFEMI/K7MDENG/...
aws configure set default.region us-east-1
aws configure set default.output json
```

**Verify configuration:**

```bash
aws configure list
```

---

## 4. Using AWS CLI for S3 Management

### What is Amazon S3

**Amazon S3 (Simple Storage Service)** is AWS’s object storage service. You store files (objects) in **buckets**. S3 is used for backups, static websites, data lakes, and application assets.

### Creating an S3 Bucket

**Command:** `aws s3 mb s3://bucket-name`

- `mb` = make bucket
- `s3://bucket-name` = URI of the bucket (must be globally unique)

```bash
aws s3 mb s3://my-unique-bucket-name-12345
```

**With region (for non-us-east-1):**

```bash
aws s3 mb s3://my-bucket --region ap-south-1
```

### Listing S3 Buckets

**Command:** `aws s3 ls`

- `ls` = list
- Lists all buckets in your account

```bash
aws s3 ls
```

**List objects inside a bucket:**

```bash
aws s3 ls s3://my-unique-bucket-name-12345/
```

### Uploading Files to S3

**Command:** `aws s3 cp source destination`

- `cp` = copy
- Copies from local path to S3 or vice versa

```bash
# Upload single file
aws s3 cp myfile.txt s3://my-unique-bucket-name-12345/

# Upload with custom key (path in bucket)
aws s3 cp myfile.txt s3://my-unique-bucket-name-12345/folder/myfile.txt

# Upload entire directory (recursive)
aws s3 cp ./my-folder s3://my-unique-bucket-name-12345/ --recursive
```

### Downloading Files from S3

```bash
# Download single file
aws s3 cp s3://my-unique-bucket-name-12345/myfile.txt ./

# Download entire prefix/directory
aws s3 cp s3://my-unique-bucket-name-12345/ ./local-folder/ --recursive
```

### Deleting Files from S3

**Command:** `aws s3 rm s3://bucket/path`

- `rm` = remove

```bash
# Delete single object
aws s3 rm s3://my-unique-bucket-name-12345/myfile.txt

# Delete all objects under a prefix (recursive)
aws s3 rm s3://my-unique-bucket-name-12345/folder/ --recursive
```

**Delete bucket (must be empty first):**

```bash
aws s3 rb s3://my-unique-bucket-name-12345 --force
```

- `rb` = remove bucket  
- `--force` = delete all objects and then the bucket

### S3 Command Summary

| Command | Purpose |
|---------|---------|
| `aws s3 ls` | List buckets or objects |
| `aws s3 mb s3://bucket-name` | Create bucket (make bucket) |
| `aws s3 cp source dest` | Copy files to/from S3 |
| `aws s3 rm s3://bucket/path` | Delete objects |
| `aws s3 rb s3://bucket` | Remove bucket |
| `--recursive` | Operate on directories recursively |

---

## 5. Using AWS CLI for EC2 Management

### What is EC2

**Amazon EC2 (Elastic Compute Cloud)** provides virtual servers (instances) in the cloud. You can start, stop, and manage instances, and install your own software on them.

### Listing EC2 Instances

**Command:** `aws ec2 describe-instances`

- Returns all instances in the region (running, stopped, terminated).
- Output is JSON by default; use `--output table` for readability.

```bash
# Basic list
aws ec2 describe-instances

# Human-readable table format
aws ec2 describe-instances --output table

# Filter by state (running only)
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --output table

# Get only instance IDs
aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text
```

### Starting an Instance

**Command:** `aws ec2 start-instances --instance-ids id1 id2`

```bash
aws ec2 start-instances --instance-ids i-0abcd1234efgh5678
```

### Stopping an Instance

**Command:** `aws ec2 stop-instances --instance-ids id1 id2`

```bash
aws ec2 stop-instances --instance-ids i-0abcd1234efgh5678
```

### Describing Instances

**Command:** `aws ec2 describe-instances`

- Returns full details: instance ID, type, state, public/private IP, tags, etc.

```bash
# Describe all instances
aws ec2 describe-instances --output table

# Describe specific instance
aws ec2 describe-instances --instance-ids i-0abcd1234efgh5678

# Get public IP of running instance
aws ec2 describe-instances \
  --instance-ids i-0abcd1234efgh5678 \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text
```

### EC2 Command Summary

| Command | Purpose |
|---------|---------|
| `aws ec2 describe-instances` | List and describe instances |
| `aws ec2 start-instances --instance-ids id` | Start instance(s) |
| `aws ec2 stop-instances --instance-ids id` | Stop instance(s) |
| `aws ec2 terminate-instances --instance-ids id` | Permanently terminate instance(s) |

### Common Parameters

| Parameter | Purpose |
|-----------|---------|
| `--instance-ids i-xxx` | Target specific instance(s) |
| `--filters "Name=x,Values=y"` | Filter results |
| `--region us-east-1` | Override default region |
| `--output table` | Human-readable table output |
| `--query 'JSONPath'` | Extract specific fields from JSON |

---

## 6. Practical Demo Commands

A step-by-step CLI workflow to practice AWS CLI.

### Step 1: Configure AWS CLI

```bash
aws configure
# Enter: Access Key, Secret Key, Region (e.g., us-east-1), Output (json or table)
```

### Step 2: Create S3 Bucket

```bash
aws s3 mb s3://my-demo-bucket-$(date +%s)
# $(date +%s) adds a unique suffix
```

### Step 3: Upload a File

```bash
# Create a test file
echo "Hello from AWS CLI demo" > demo.txt

# Upload to S3
aws s3 cp demo.txt s3://my-demo-bucket-XXXX/
```

### Step 4: List Bucket Contents

```bash
aws s3 ls s3://my-demo-bucket-XXXX/
```

### Step 5: Launch EC2 Instance Using CLI

```bash
# Launch a t2.micro (Free Tier eligible) in default VPC
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t2.micro \
  --key-name YourKeyPairName \
  --count 1

# Note: Replace ami-0c55b159cbfafe1f0 with a current Amazon Linux 2 AMI for your region
# Replace YourKeyPairName with your actual key pair name
```

**Get latest Amazon Linux 2 AMI (us-east-1):**

```bash
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" "Name=state,Values=available" \
  --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
  --output text
```

### Step 6: Check Instance Status

```bash
# List instances
aws ec2 describe-instances --filters "Name=instance-state-name,Values=pending,running" --output table

# Get instance ID from output, then:
aws ec2 describe-instance-status --instance-ids i-xxxxxxxxx
```

### Step 7: Clean Up (Optional)

```bash
# Stop instance (replace with your instance ID)
aws ec2 stop-instances --instance-ids i-xxxxxxxxx

# Delete S3 object and bucket
aws s3 rm s3://my-demo-bucket-XXXX/demo.txt
aws s3 rb s3://my-demo-bucket-XXXX/
```

---

## 7. Best Practices

### Security Practices When Using AWS CLI

1. **Never share or commit credentials** – Access keys and secret keys must stay private.
2. **Rotate access keys regularly** – Create new keys periodically and remove old ones.
3. **Use IAM users, not root** – Create IAM users with minimal permissions.
4. **Enable MFA** – Use Multi-Factor Authentication for IAM users.
5. **Audit usage** – Use CloudTrail to track who ran which commands.

### Protecting Access Keys

- **Do not** hardcode keys in scripts or config files.
- **Do not** commit `~/.aws/credentials` to version control.
- **Do** add `~/.aws/` to `.gitignore` if you use Git.
- **Do** use environment variables or AWS Secrets Manager for automation.

```bash
# Temporary credentials via environment (script use)
export AWS_ACCESS_KEY_ID=AKIA...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1
```

### Using IAM Roles Instead of Root Access

- **EC2 instances:** Attach an IAM role to the instance. The AWS CLI on that instance automatically uses the role—no keys needed.
- **Lambda:** Assign an execution role; no keys to manage.
- **Avoid root credentials** – Root has full account access. Use IAM users/roles with scoped permissions.

### Avoiding Credential Exposure

| Don't | Do |
|-------|-----|
| Put keys in code or config files | Use IAM roles, env vars, or credential files |
| Share keys via email/chat | Use IAM users per person; rotate keys |
| Use root account for daily work | Create IAM users with least privilege |
| Commit `.aws/credentials` to Git | Add to `.gitignore` and use CI/CD secrets |

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Check version | `aws --version` |
| Configure | `aws configure` |
| List S3 buckets | `aws s3 ls` |
| Create bucket | `aws s3 mb s3://bucket-name` |
| Upload file | `aws s3 cp file.txt s3://bucket/` |
| Download file | `aws s3 cp s3://bucket/file.txt ./` |
| Delete object | `aws s3 rm s3://bucket/file.txt` |
| List EC2 instances | `aws ec2 describe-instances --output table` |
| Start instance | `aws ec2 start-instances --instance-ids i-xxx` |
| Stop instance | `aws ec2 stop-instances --instance-ids i-xxx` |

---

*End of AWS CLI Essentials training notes.*
