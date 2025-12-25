# Day 3: EBS and Partitions

## What is EBS (AWS)?

**EBS (Elastic Block Store)** is a high-performance block storage service designed for use with Amazon EC2 instances. It provides persistent storage volumes that can be attached to EC2 instances, similar to physical hard drives.

### Key Characteristics:

- **Persistent Storage**: Data persists independently of the instance lifecycle
- **Block Storage**: Works at the block level, suitable for file systems and databases
- **Attachable**: Can be attached/detached from EC2 instances
- **Scalable**: Can resize volumes without downtime
- **Backup**: Supports snapshots for backup and recovery
- **Availability Zone Specific**: EBS volumes are tied to a specific Availability Zone

### Use Cases:

- Database storage
- Application data storage
- Boot volumes for EC2 instances
- File systems
- Data backup and recovery

---

## Different Types of EBS Storage Classes

### 1. **gp3 (General Purpose SSD)**

- **Type**: SSD (Solid State Drive)
- **Use Case**: General-purpose workloads
- **Performance**: Baseline 3,000 IOPS, up to 16,000 IOPS
- **Throughput**: Baseline 125 MB/s, up to 1,000 MB/s
- **Cost**: Most cost-effective SSD option
- **Best For**: Boot volumes, small to medium databases, development and test environments

### 2. **gp2 (General Purpose SSD)**

- **Type**: SSD
- **Use Case**: General-purpose workloads
- **Performance**: 3 IOPS per GB (min 100, max 16,000 IOPS)
- **Throughput**: Up to 250 MB/s
- **Cost**: Moderate
- **Best For**: Boot volumes, applications with moderate I/O requirements

### 3. **io1 (Provisioned IOPS SSD)**

- **Type**: SSD
- **Use Case**: I/O-intensive applications
- **Performance**: Up to 64,000 IOPS per volume
- **Throughput**: Up to 1,000 MB/s
- **Cost**: Higher cost
- **Best For**: Critical databases, high-performance applications

### 4. **io2 (Provisioned IOPS SSD)**

- **Type**: SSD
- **Use Case**: I/O-intensive applications with higher durability
- **Performance**: Up to 64,000 IOPS per volume
- **Throughput**: Up to 1,000 MB/s
- **Durability**: 99.999% durability
- **Cost**: Higher cost
- **Best For**: Mission-critical databases, enterprise applications

### 5. **st1 (Throughput Optimized HDD)**

- **Type**: HDD (Hard Disk Drive)
- **Use Case**: Throughput-intensive workloads
- **Performance**: 500 IOPS baseline, up to 500 IOPS burst
- **Throughput**: Up to 500 MB/s
- **Cost**: Lower cost than SSD
- **Best For**: Big data, data warehouses, log processing

### 6. **sc1 (Cold HDD)**

- **Type**: HDD
- **Use Case**: Infrequently accessed data
- **Performance**: 250 IOPS baseline, up to 250 IOPS burst
- **Throughput**: Up to 250 MB/s
- **Cost**: Lowest cost
- **Best For**: Cold data storage, backup archives

---

## Differentiation Table for EBS

| Feature | gp3 | gp2 | io1 | io2 | st1 | sc1 |
|---------|-----|-----|-----|-----|-----|-----|
| **Type** | SSD | SSD | SSD | SSD | HDD | HDD |
| **Max Volume Size** | 16 TiB | 16 TiB | 16 TiB | 16 TiB | 16 TiB | 16 TiB |
| **Max IOPS** | 16,000 | 16,000 | 64,000 | 64,000 | 500 | 250 |
| **Max Throughput** | 1,000 MB/s | 250 MB/s | 1,000 MB/s | 1,000 MB/s | 500 MB/s | 250 MB/s |
| **Baseline IOPS** | 3,000 | 3 per GB | Provisioned | Provisioned | 500 | 250 |
| **Boot Volume** | Yes | Yes | Yes | Yes | No | No |
| **Cost** | Low | Low-Medium | High | High | Low | Very Low |
| **Use Case** | General purpose | General purpose | High IOPS | Mission-critical | Throughput | Cold storage |
| **Durability** | 99.8-99.9% | 99.8-99.9% | 99.8-99.9% | 99.999% | 99.8-99.9% | 99.8-99.9% |

---

## Practical Steps: Create and Attach EBS to EC2 Instance

### Step 1: Create EBS Volume

1. Go to **EC2 Dashboard** → **Volumes** (under Elastic Block Store)
2. Click **"Create Volume"**
3. Configure the volume:
   - **Volume Type**: Select (e.g., gp3, gp2)
   - **Size**: Enter size in GiB (e.g., 100 GiB)
   - **Availability Zone**: Select the same AZ as your EC2 instance
   - **Encryption**: Optional (enable if needed)
   - **Snapshot ID**: Optional (if creating from snapshot)
4. Click **"Create Volume"**
5. Note the **Volume ID**

### Step 2: Attach EBS Volume to EC2 Instance

1. Select the created volume
2. Click **"Actions"** → **"Attach Volume"**
3. Configure attachment:
   - **Instance**: Select your EC2 instance
   - **Device Name**: Leave default (e.g., `/dev/xvdf`) or specify custom
4. Click **"Attach"**

### Step 3: Verify Attachment

SSH into your EC2 instance and verify:

```bash
# List block devices
lsblk

# Check file system
df -hT
```

---

## Partitions

### What is a Partition?

A **partition** is a logical division of a storage device (like an EBS volume). It allows you to organize and manage storage space on a disk.

### Types of Partitions:

- **Primary Partition**: Can contain a file system and be bootable (max 4 primary partitions)
- **Extended Partition**: Container for logical partitions
- **Logical Partition**: Created within an extended partition

---

## Creating Partitions: Step-by-Step Guide

### Prerequisites:

1. Attach a 100 GiB EBS volume to your EC2 instance
2. SSH into the instance

### Step 1: Check Available Storage

```bash
# List all block devices
lsblk

# Check disk usage and mount points
df -hT
```

**Output Example:**
```
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk /
xvdf    202:80   0 100G  0 disk
```

### Step 2: Create Primary Partition

Use `fdisk` to create a partition:

```bash
# Start fdisk for the new volume
sudo fdisk /dev/xvdf
```

**Inside fdisk, follow these commands:**

```
n          # Create new partition
p          # Primary partition
1          # Partition number (1-4)
           # Press Enter for first sector (default)
           # For last sector: Press Enter (full disk) or specify size like +1G, +50G, +1GiB
w          # Write changes and exit
```

**Complete fdisk session example:**

**Option 1: Use full disk (100 GiB)**
```
Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-209715199, default 2048): [Press Enter]
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-209715199, default 209715199): [Press Enter]
Command (m for help): w
The partition table has been altered.
```

**Option 2: Specify partition size (e.g., 1 GiB)**
```
Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-209715199, default 2048): [Press Enter]
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-209715199, default 209715199): +1G
Command (m for help): w
The partition table has been altered.
```

**Note:** You can specify size using:
- `+1G` or `+1GiB` for 1 GiB
- `+50G` for 50 GiB
- `+500M` for 500 MiB
- Or press Enter to use the remaining space

### Step 3: Update Partition Table

After creating partition, update the kernel partition table:

```bash
# Reload partition table without reboot
sudo partprobe /dev/xvdf

# Verify partition was created
lsblk
```

**Expected Output:**
```
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk /
xvdf    202:80   0 100G  0 disk
└─xvdf1 202:81   0 100G  0 part
```

### Step 4: Create File System (mkfs)

Format the partition with a file system. Choose one based on your needs:

#### Option A: ext4 (Most Common)

```bash
# Create ext4 file system
sudo mkfs.ext4 /dev/xvdf1
```

#### Option B: xfs (High Performance)

```bash
# Create xfs file system
sudo mkfs.xfs /dev/xvdf1
```

#### Option C: ext3 (Older, Compatible)

```bash
# Create ext3 file system
sudo mkfs.ext3 /dev/xvdf1
```

#### Option D: ext2 (Basic)

```bash
# Create ext2 file system
sudo mkfs.ext2 /dev/xvdf1
```

**Common File System Comparison:**

| File System | Max File Size | Max Volume Size | Journaling | Best For |
|-------------|---------------|-----------------|------------|----------|
| **ext4** | 16 TiB | 1 EiB | Yes | General purpose, most common |
| **xfs** | 8 EiB | 16 EiB | Yes | Large files, high performance |
| **ext3** | 2 TiB | 32 TiB | Yes | Older systems, compatibility |
| **ext2** | 2 TiB | 32 TiB | No | Simple use cases |

### Step 5: Temporary Mount

Mount the partition temporarily (mount is lost after reboot):

```bash
# Create mount point directory
sudo mkdir /mnt/mydata

# Mount the partition
sudo mount /dev/xvdf1 /mnt/mydata

# Verify mount
df -hT

# Check mount point
lsblk
```

**Verify Mount:**
```bash
# Should show the mounted partition
df -hT | grep xvdf1

# Output example:
/dev/xvdf1  ext4   98G   61M   93G   1% /mnt/mydata
```

### Step 6: Test the Mount

```bash
# Create a test file
sudo touch /mnt/mydata/test.txt
echo "Hello from EBS" | sudo tee /mnt/mydata/test.txt

# Verify file creation
ls -la /mnt/mydata/
cat /mnt/mydata/test.txt
```

### Step 7: Unmount (Optional)

To unmount the partition:

```bash
# Unmount the partition
sudo umount /mnt/mydata

# Verify unmount
df -hT
```

---

## Complete Example: Full Workflow

```bash
# 1. Check available storage
lsblk
df -hT

# 2. Create partition
sudo fdisk /dev/xvdf
# Inside fdisk: n → p → 1 → Enter → Enter → w

# 3. Update partition table
sudo partprobe /dev/xvdf

# 4. Verify partition
lsblk

# 5. Create file system (ext4)
sudo mkfs.ext4 /dev/xvdf1

# 6. Create mount point
sudo mkdir /mnt/mydata

# 7. Mount partition
sudo mount /dev/xvdf1 /mnt/mydata

# 8. Verify mount
df -hT
lsblk

# 9. Test write
sudo touch /mnt/mydata/test.txt
ls -la /mnt/mydata/
```

---

## Important Commands Reference

### Storage Management:

```bash
# List block devices
lsblk

# Display disk space usage
df -hT

# Create partition
sudo fdisk /dev/xvdf

# Update partition table
sudo partprobe /dev/xvdf

# Create file system
sudo mkfs.ext4 /dev/xvdf1    # ext4
sudo mkfs.xfs /dev/xvdf1     # xfs
sudo mkfs.ext3 /dev/xvdf1    # ext3

# Mount partition
sudo mount /dev/xvdf1 /mnt/mydata

# Unmount partition
sudo umount /mnt/mydata

# Check file system
sudo fsck /dev/xvdf1
```

---

## Summary

### EBS (Elastic Block Store):
- Persistent block storage for EC2 instances
- Multiple storage classes: gp3, gp2, io1, io2, st1, sc1
- Can be created, attached, and detached from instances
- Supports snapshots for backup

### Partitions:
- Logical divisions of storage devices
- Created using `fdisk` command
- Updated with `partprobe` command
- Formatted with `mkfs` (ext4, xfs, ext3, etc.)
- Mounted temporarily or permanently for use

Understanding EBS and partitions is essential for managing storage in AWS EC2 instances effectively.

