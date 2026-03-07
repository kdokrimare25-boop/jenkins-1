# Amazon EFS (Elastic File System)

**Training Notes for AWS & DevOps Beginners**

---

## Table of Contents

1. [Introduction to File Storage in AWS](#1-introduction-to-file-storage-in-aws)
2. [Introduction to Amazon EFS](#2-introduction-to-amazon-efs)
3. [EFS Architecture](#3-efs-architecture)
4. [Use Cases of Amazon EFS](#4-use-cases-of-amazon-efs)
5. [Steps to Create Amazon EFS](#5-steps-to-create-amazon-efs)
6. [Mounting EFS on EC2 Instance](#6-mounting-efs-on-ec2-instance)
7. [Permanent Mount of EFS on EC2 Instance](#7-permanent-mount-of-efs-on-ec2-instance)
8. [Verifying the Mount](#8-verifying-the-mount)
9. [Best Practices](#9-best-practices)

---

## 1. Introduction to File Storage in AWS

### What is File Storage

**File storage** organizes data in a hierarchical structure of files and folders (directories). You access files using a path like `/home/user/documents/report.pdf`. Multiple users or applications can access the same files over a network using protocols such as NFS (Network File System) or SMB (Server Message Block).

### Types of Storage in AWS

| Type | Service | Description | Use Case |
|------|---------|-------------|----------|
| **Block storage** | EBS | Data stored in fixed-size blocks; attached to a single EC2 instance | Boot volumes, databases, single-instance storage |
| **Object storage** | S3 | Data stored as objects (key + data + metadata); accessed via API | Backups, static websites, data lakes |
| **File storage** | EFS | Shared file system; multiple instances access via NFS | Shared storage, web content, home directories |

#### Block Storage (EBS)

- **Attached to one EC2 instance** at a time.
- Data organized in blocks; no built-in sharing.
- Good for: databases, OS, applications needing low-latency disk.

#### Object Storage (S3)

- **Accessed via HTTP/API** (not as a traditional filesystem).
- Unlimited scale; pay per GB stored.
- Good for: backups, archives, static assets, big data.

#### File Storage (EFS)

- **Shared network file system** (NFS).
- Multiple EC2 instances mount and access the same files.
- Good for: shared content, home directories, multi-instance apps.

### Where File Storage is Used in Real-World Applications

| Scenario | Why File Storage |
|----------|------------------|
| **Web server farm** | Multiple web servers share the same HTML, images, and uploads |
| **Development teams** | Shared codebase, configs, and build artifacts |
| **Media processing** | Multiple workers read/write the same video or image files |
| **Home directories** | Users log in to different servers but see the same home folder |
| **Container persistent storage** | Containers share data across pod restarts |
| **Machine learning** | Training jobs read datasets from a shared location |

---

## 2. Introduction to Amazon EFS

### Definition of Amazon Elastic File System (EFS)

**Amazon EFS** is a fully managed, scalable network file system for Linux. It uses the NFS protocol so multiple EC2 instances can mount and access the same files at the same time. Storage grows and shrinks automatically as you add or remove files.

### What Type of Storage EFS is

- **File storage** – Hierarchical files and directories.
- **Network file system** – Accessed over the network via NFS.
- **Shared storage** – Many instances can mount it concurrently.
- **Elastic** – Capacity scales with usage; no pre-provisioning.

### Key Features of EFS

#### Fully Managed

- No servers to manage; AWS handles provisioning, patching, and backups.
- Create a file system and mount it; no storage or NFS server setup.

#### Scalable Storage

- **Grows automatically** as you add files.
- **Shrinks** when you delete files (with a delay due to lifecycle).
- No need to pre-allocate capacity.

#### Shared File System

- **Concurrent access** – Many EC2 instances can mount and use it at once.
- **Consistency** – Changes from one instance are visible to others.
- **Standard NFS** – Works with standard Linux NFS clients.

#### High Availability

- Data stored across **multiple Availability Zones** in a region.
- Designed for 99.99% availability.
- No single point of failure for the file system.

### Benefits of Using EFS

| Benefit | Description |
|---------|-------------|
| **Shared storage** | One file system for many instances |
| **Elastic** | Pay for what you use; no capacity planning |
| **Managed** | No NFS server management |
| **Durable** | Redundant across AZs |
| **Compatible** | Standard NFS; works with Linux apps |
| **Performance modes** | Throughput or latency optimized |

---

## 3. EFS Architecture

### Components Involved

#### EFS File System

- The main EFS resource; a logical container for your files and directories.
- Has a unique ID (e.g., `fs-0123456789abcdef0`).
- Created in a region; data is replicated across AZs in that region.

#### Mount Targets

- A **mount target** is a network interface (ENI) in a subnet that lets EC2 instances connect to EFS.
- **One mount target per subnet** (typically one per AZ).
- EC2 instances in that subnet use the mount target’s IP to mount the file system.
- Mount targets are required for EC2 to access EFS.

#### Security Groups

- **EFS mount target:** Security group must allow **NFS (port 2049)** from the EC2 instances.
- **EC2 instances:** Security group must allow **outbound** to the EFS mount target (port 2049).
- Both sides must allow traffic for the mount to work.

#### EC2 Instances

- Linux EC2 instances that mount the EFS file system.
- Must be in a VPC where EFS mount targets exist.
- Use the `mount` command with the EFS endpoint.

### How EC2 Instances Connect to EFS Using NFS Protocol

```
┌─────────────────────────────────────────────────────────────────┐
│                          VPC                                     │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Availability Zone A                                       │  │
│  │  ┌─────────────┐         ┌─────────────────────┐         │  │
│  │  │  EC2 #1     │ ──NFS──►│  Mount Target (AZ-A) │         │  │
│  │  │  (Web Server)│ 2049  │  (ENI in subnet)     │         │  │
│  │  └─────────────┘         └──────────┬──────────┘         │  │
│  │                                      │                     │  │
│  └──────────────────────────────────────┼─────────────────────┘  │
│                                         │                        │
│  ┌──────────────────────────────────────┼─────────────────────┐  │
│  │  Availability Zone B                  │                     │  │
│  │  ┌─────────────┐         ┌──────────▼──────────┐         │  │
│  │  │  EC2 #2     │ ──NFS──►│  Mount Target (AZ-B) │         │  │
│  │  │  (Web Server)│ 2049  │  (ENI in subnet)     │         │  │
│  │  └─────────────┘         └──────────┬──────────┘         │  │
│  │                                      │                     │  │
│  └──────────────────────────────────────┼─────────────────────┘  │
│                                         │                        │
│                              ┌──────────▼──────────┐             │
│                              │   EFS File System   │             │
│                              │   (Multi-AZ)        │             │
│                              └─────────────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

**Flow:**
1. EC2 instance sends NFS requests to the mount target in its subnet.
2. Mount target forwards requests to the EFS file system.
3. EFS serves the file data; all instances see the same files.

---

## 4. Use Cases of Amazon EFS

### Shared Storage for Multiple EC2 Instances

- **Scenario:** Multiple EC2 instances (e.g., web servers) need shared data.
- **Use EFS:** All instances mount the same EFS; they read/write files in the same place.
- **Example:** Shared config files, uploads, or application data.

### Web Server Content Sharing

- **Scenario:** Multiple web servers behind a load balancer serve the same site.
- **Use EFS:** All servers mount EFS for HTML, CSS, images, and user uploads.
- **Example:** WordPress with shared `wp-content`; uploads visible on all servers.

### Container Storage

- **Scenario:** ECS or EKS tasks need shared or persistent storage.
- **Use EFS:** Mount EFS as a volume in tasks; data persists across task restarts.
- **Example:** Shared model files for ML inference; shared app data.

### Big Data Workloads

- **Scenario:** Analytics jobs (Spark, Hadoop) need shared input/output.
- **Use EFS:** Store datasets and results on EFS; multiple workers access them.
- **Example:** Shared training data; intermediate results.

### Machine Learning Workloads

- **Scenario:** ML training needs large datasets; multiple workers may read the same data.
- **Use EFS:** Store datasets on EFS; training jobs mount and read.
- **Example:** Image datasets, model checkpoints, shared across instances.

---

## 5. Steps to Create Amazon EFS

### Step 1: Go to AWS Console → EFS

1. Sign in to **AWS Console**.
2. Search for **EFS** or go to **Services** → **Storage** → **Elastic File System**.
3. Click **Create file system**.

### Step 2: Create File System

1. **File system name:** e.g., `my-efs-shared-storage`.
2. **Storage class:** 
   - **Standard** – Frequently accessed data.
   - **Infrequent Access (IA)** – Lifecycle policy can move old data to lower-cost storage.
3. **Encryption:** Enable at-rest encryption (recommended).
4. **Performance mode:**
   - **General Purpose** – Most workloads.
   - **Max I/O** – Higher throughput, slightly higher latency (for large, parallel workloads).

### Step 3: Select VPC

1. **Virtual private cloud (VPC):** Choose the VPC where your EC2 instances run.
2. **Availability and durability:** 
   - **Regional** – Data in multiple AZs (recommended).
   - **One Zone** – Single AZ (lower cost, less durability).

### Step 4: Configure Mount Targets

1. For each **Availability Zone** where you have subnets:
   - **Subnet:** Select a private subnet (recommended).
   - **IP address:** Auto-assigned or specify.
2. Create a mount target in **at least one subnet** (ideally one per AZ for HA).
3. **Security group:** Select or create a security group for the mount target (see Step 5).

### Step 5: Configure Security Groups

1. **Mount target security group** must allow:
   - **Inbound:** NFS (port 2049) from the EC2 instances’ security group.
   - **Outbound:** Usually allow all (or at least to EC2).
2. **EC2 security group** must allow:
   - **Outbound:** NFS (port 2049) to the EFS mount target security group.

**Example inbound rule for EFS mount target:**
```
Type: NFS
Port: 2049
Source: sg-xxxxxxxx (EC2 security group)
```

### Step 6: Create File System

1. Review settings.
2. Click **Create**.
3. Note the **File system ID** (e.g., `fs-0123456789abcdef0`) and **Mount targets** (one per subnet).

---

## 6. Mounting EFS on EC2 Instance

### Getting the EFS Endpoint from AWS Console

Before mounting, you need the **EFS file system ID** or **DNS name** from the AWS Console:

1. Go to **AWS Console** → **EFS** → **File systems**.
2. Click your file system name (e.g., `my-efs-shared-storage`).
3. Note the **File system ID** (e.g., `fs-0123456789abcdef0`).
4. In the **Network** section, you will see **Mount targets** with:
   - **DNS name** – e.g., `fs-0123456789abcdef0.efs.us-east-1.amazonaws.com`
   - **Subnet** – Subnet where the mount target lives
   - **IP address** – Mount target IP (optional for advanced use)

**Two ways to specify the endpoint when mounting:**

| Method | Format | Example |
|--------|--------|---------|
| **File system ID** | `fs-xxxxx:/` | `fs-0123456789abcdef0:/` |
| **DNS name** | `fs-xxxxx.efs.region.amazonaws.com:/` | `fs-0123456789abcdef0.efs.us-east-1.amazonaws.com:/` |

Both work the same way. The DNS name resolves to the mount target in the same Availability Zone as your EC2 instance for lower latency.

**Using AWS CLI to get the endpoint:**
```bash
# List file systems and get the File System ID
aws efs describe-file-systems --query 'FileSystems[*].[FileSystemId,Name]' --output table

# Get mount target details for a file system
aws efs describe-mount-targets --file-system-id fs-0123456789abcdef0
```

### Prerequisites

- EC2 instance in the same VPC as the EFS mount targets.
- Security groups configured (EC2 → EFS on port 2049).
- Linux AMI (Amazon Linux 2, Ubuntu, etc.).
- EFS file system ID or DNS name from the console.

### Step 1: Launch EC2 Instance

1. Launch an EC2 instance in a subnet that has an EFS mount target.
2. Attach a security group that allows outbound NFS (port 2049) to the EFS mount target.
3. Connect via SSH.

### Step 2: Install NFS Utilities

**Amazon Linux 2 / RHEL / CentOS:**
```bash
sudo yum install -y amazon-efs-utils
```

**Ubuntu / Debian:**
```bash
sudo apt-get update
sudo apt-get install -y amazon-efs-utils
```

**What this does:** Installs the EFS client tools, including the helper for mounting and the recommended mount options.

### Step 3: Create Mount Directory

```bash
sudo mkdir /mnt/efs
```

**What this does:** Creates a directory that will be the mount point for the EFS file system.

### Step 4: Mount EFS File System Using the Endpoint

Use the **File system ID** or **DNS name** you copied from the EFS console:

**Option A – Using File system ID:**
```bash
sudo mount -t efs fs-0123456789abcdef0:/ /mnt/efs
```

**Option B – Using EFS DNS endpoint (from Console → Network → Mount target):**
```bash
sudo mount -t efs fs-0123456789abcdef0.efs.us-east-1.amazonaws.com:/ /mnt/efs
```

> **Replace** `fs-0123456789abcdef0` with your file system ID and `us-east-1` with your region.

**What each part does:**

| Part | Meaning |
|------|---------|
| `mount` | Linux command to attach a file system |
| `-t efs` | File system type is EFS |
| `fs-0123456789abcdef0` or `fs-xxx.efs.region.amazonaws.com` | EFS endpoint (ID or DNS from console) |
| `:/` | Root of the EFS file system |
| `/mnt/efs` | Local directory (mount point) |

**With TLS encryption (recommended):**
```bash
# Using file system ID
sudo mount -t efs -o tls fs-0123456789abcdef0:/ /mnt/efs

# Using DNS endpoint
sudo mount -t efs -o tls fs-0123456789abcdef0.efs.us-east-1.amazonaws.com:/ /mnt/efs
```

**Verify:**
```bash
df -h
ls /mnt/efs
```

---

## 7. Permanent Mount of EFS on EC2 Instance

### Why Permanent Mount?

- A manual `mount` is lost after reboot.
- Adding EFS to `/etc/fstab` makes the mount automatic on boot.

### What is the /etc/fstab File

- **fstab** = file systems table.
- Lists file systems to mount at boot.
- Each line describes one file system and its mount options.

### How fstab Works

1. At boot, Linux reads `/etc/fstab`.
2. For each entry, it runs `mount` with the given options.
3. File systems are mounted before services start.

### Entry for EFS Mount

**Add this line to `/etc/fstab`:**

```
fs-0123456789abcdef0:/ /mnt/efs efs defaults,_netdev 0 0
```

**Or with TLS (recommended):**

```
fs-0123456789abcdef0:/ /mnt/efs efs defaults,tls,_netdev 0 0
```

### Parameters in the fstab Entry

| Field | Value | Meaning |
|-------|-------|---------|
| **Device** | `fs-0123456789abcdef0:/` | EFS file system (ID + root path) |
| **Mount point** | `/mnt/efs` | Local directory |
| **Type** | `efs` | File system type |
| **Options** | `defaults,tls,_netdev` | Mount options |
| **Dump** | `0` | Not used for dump (legacy) |
| **Fsck** | `0` | No fsck (EFS is managed) |

**Options explained:**

| Option | Meaning |
|--------|---------|
| `defaults` | Standard options (rw, etc.) |
| `tls` | Use TLS for encryption in transit |
| `_netdev` | Mount after network is up (important for NFS/EFS) |

**Apply without reboot:**
```bash
sudo mount -a
```

---

## 8. Verifying the Mount

### Check Mount with df -h

```bash
df -h
```

**Example output:**
```
Filesystem           Size  Used Avail Use% Mounted on
...
fs-0123456789abcdef0  8.0E     0  8.0E   0% /mnt/efs
```

- **Size:** EFS shows as very large (elastic).
- **Mounted on:** Confirms `/mnt/efs` is the mount point.

### Check Mount with mount

```bash
mount | grep efs
```

**Example output:**
```
fs-0123456789abcdef0:/ on /mnt/efs type efs (rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,...)
```

### Test File Sharing Between Multiple EC2 Instances

**On EC2 Instance 1:**
```bash
# Create a test file
echo "Hello from Instance 1" | sudo tee /mnt/efs/test.txt

# Verify
cat /mnt/efs/test.txt
```

**On EC2 Instance 2:**
```bash
# Read the same file (should see content from Instance 1)
cat /mnt/efs/test.txt

# Add content from Instance 2
echo "Hello from Instance 2" | sudo tee -a /mnt/efs/test.txt
```

**On EC2 Instance 1 again:**
```bash
# Verify both lines are visible
cat /mnt/efs/test.txt
```

**Expected:** Both instances see the same file and each other’s changes, confirming shared storage.

---

## 9. Best Practices

### Use Correct Security Group Configuration

- EFS mount target: **Inbound NFS (2049)** from EC2 security group only.
- EC2: **Outbound** to EFS on port 2049.
- Avoid opening NFS to `0.0.0.0/0`; restrict to known instance security groups.

### Use EFS for Shared Workloads

- Prefer EFS when **multiple instances** need the same data.
- For single-instance, high-IOPS workloads, EBS may be more cost-effective.

### Monitor Storage Usage

- Use **CloudWatch** metrics: `StorageBytes`, `DataReadBytes`, `DataWriteBytes`.
- Set alarms for unexpected growth or high I/O.
- Use **EFS metrics** to understand throughput and IOPS.

### Use IAM Roles Where Applicable

- EC2 instances can use **IAM roles** for EFS access (when using IAM auth).
- Avoid storing long-term credentials on instances.
- Use **EFS Access Points** for application-specific permissions and paths.

### Use Lifecycle Management for Cost Optimization

- Enable **Lifecycle management** to move older files to **EFS Infrequent Access (IA)**.
- Reduces cost for rarely accessed data.
- Configure in EFS console → File system → Lifecycle management.

### Additional Tips

- **Use mount targets in private subnets** for production.
- **Enable encryption** at rest and use `tls` for encryption in transit.
- **Use Access Points** for consistent directory structure and permissions per application.
- **Test failover** by mounting from instances in different AZs.

---

## Quick Reference

### EFS Concepts

| Term | Meaning |
|------|---------|
| **File system** | EFS resource; logical container for files |
| **Mount target** | ENI in a subnet for NFS access |
| **Mount point** | Local directory (e.g., `/mnt/efs`) where EFS is mounted |
| **NFS** | Network File System; protocol used for EFS |

### Getting EFS Endpoint

| Source | What to Use |
|--------|-------------|
| **Console** | EFS → File systems → Your FS → File system ID or Network → Mount target DNS |
| **CLI** | `aws efs describe-file-systems` for ID; `aws efs describe-mount-targets` for details |

### Common Commands

| Command | Purpose |
|---------|---------|
| `sudo yum install -y amazon-efs-utils` | Install EFS client (Amazon Linux) |
| `sudo mkdir /mnt/efs` | Create mount point |
| `sudo mount -t efs -o tls fs-xxx:/ /mnt/efs` | Mount EFS (use ID or DNS from console) |
| `df -h` | Verify mount and space |
| `mount \| grep efs` | Check EFS mount |

### fstab Entry Format

```
fs-xxxxxxxx:/ /mnt/efs efs defaults,tls,_netdev 0 0
```

Or using DNS endpoint: `fs-xxxxxxxx.efs.region.amazonaws.com:/`

---

*End of Amazon EFS training notes.*
