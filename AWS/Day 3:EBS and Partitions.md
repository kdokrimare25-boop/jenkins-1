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

## Extended and Logical Partitions

### Understanding Extended and Logical Partitions

When you need more than 4 partitions on a disk, you use:
- **Extended Partition**: Acts as a container (counts as one primary partition)
- **Logical Partitions**: Created inside the extended partition (unlimited number)

**Limitation**: Maximum 4 primary partitions per disk. To create more partitions:
1. Create 3 primary partitions
2. Create 1 extended partition
3. Create multiple logical partitions inside the extended partition

### Creating Extended and Logical Partitions: Step-by-Step

**Prerequisites:**
- Attach a 100 GiB EBS volume to your EC2 instance
- SSH into the instance

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

### Step 2: Create Extended Partition

```bash
# Start fdisk for the volume
sudo fdisk /dev/xvdf
```

**Inside fdisk, create extended partition:**

```
Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): e
Partition number (1-4, default 1): 1
First sector (2048-209715199, default 2048): [Press Enter]
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-209715199, default 209715199): [Press Enter]
Command (m for help): w
The partition table has been altered.
```

### Step 3: Create Logical Partitions

After creating extended partition, create logical partitions inside it:

```bash
# Start fdisk again
sudo fdisk /dev/xvdf
```

**Inside fdisk, create logical partitions:**

```
Command (m for help): n
Partition type:
   p   primary (0 primary, 1 extended, 3 free)
   l   logical (numbered from 5)
Select (default p): l
Adding logical partition 5
First sector (4096-209715199, default 4096): [Press Enter]
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4096-209715199, default 209715199): +20G
Command (m for help): n
Partition type:
   p   primary (0 primary, 1 extended, 3 free)
   l   logical (numbered from 5)
Select (default p): l
Adding logical partition 6
First sector (41947136-209715199, default 41947136): [Press Enter]
Last sector, +/-sectors or +/-size{K,M,G,T,P} (41947136-209715199, default 209715199): +30G
Command (m for help): w
The partition table has been altered.
```

**Note:** Logical partitions are numbered starting from 5 (xvdf5, xvdf6, etc.)

### Step 4: Update Partition Table

```bash
# Reload partition table
sudo partprobe /dev/xvdf

# Verify partitions
lsblk
```

**Expected Output:**
```
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk /
xvdf    202:80   0 100G  0 disk
├─xvdf1 202:81   0 100G  0 part    # Extended partition
├─xvdf5 202:85   0  20G  0 part    # Logical partition 1
└─xvdf6 202:86   0  30G  0 part    # Logical partition 2
```

### Step 5: Create File Systems on Logical Partitions

```bash
# Format logical partition 5 with ext4
sudo mkfs.ext4 /dev/xvdf5

# Format logical partition 6 with xfs
sudo mkfs.xfs /dev/xvdf6
```

### Step 6: Mount Logical Partitions

```bash
# Create mount points
sudo mkdir /mnt/logical1
sudo mkdir /mnt/logical2

# Mount logical partitions
sudo mount /dev/xvdf5 /mnt/logical1
sudo mount /dev/xvdf6 /mnt/logical2

# Verify mounts
df -hT
lsblk
```

---

## Permanent Mount

### What is Permanent Mount?

A **permanent mount** ensures that partitions are automatically mounted at system boot. This is configured in `/etc/fstab` (file systems table).

### Why Permanent Mount?

- **Automatic mounting**: Partitions mount automatically on boot
- **No manual intervention**: No need to manually mount after reboot
- **Consistent access**: Mount points are always available

### Step 1: Get Partition Information

Before adding to `/etc/fstab`, get the UUID or device path:

```bash
# Get UUID of partition
sudo blkid /dev/xvdf1

# Output example:
# /dev/xvdf1: UUID="a1b2c3d4-e5f6-7890-abcd-ef1234567890" TYPE="ext4"
```

**Or get device path:**
```bash
# List block devices with UUIDs
lsblk -f
```

### Step 2: Create Mount Point (if not exists)

```bash
# Create mount point directory
sudo mkdir -p /mnt/mydata
```

### Step 3: Edit /etc/fstab

```bash
# Backup fstab first
sudo cp /etc/fstab /etc/fstab.backup

# Edit fstab
sudo vim /etc/fstab
```

### Step 4: Add Entry to /etc/fstab

Add a line with the following format:

**Using UUID (Recommended):**
```
UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890  /mnt/mydata  ext4  defaults  0  0
```

**Using Device Path:**
```
/dev/xvdf1  /mnt/mydata  ext4  defaults  0  0
```

### Step 5: Test fstab Configuration

```bash
# Test fstab syntax (very important!)
sudo mount -av

# If no errors, configuration is correct
# If errors occur, fix them before rebooting
```

### Step 6: Verify Mount

```bash
# Check if mounted
df -hT | grep mydata

# Or
mount | grep mydata
```

### Step 7: Reboot to Test (Optional)

```bash
# Reboot the system
sudo reboot

# After reboot, verify mount
df -hT
```

---

## /etc/fstab Fields

The `/etc/fstab` file contains 6 fields separated by spaces or tabs:

### Field Format:
```
<device>  <mount_point>  <file_system_type>  <options>  <dump>  <pass>
```

### Field 1: Device (UUID or Device Path)

**UUID (Recommended):**
```
UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

**Device Path:**
```
/dev/xvdf1
```

**Why UUID is preferred:** Device names can change, but UUIDs remain constant.

### Field 2: Mount Point

The directory where the partition will be mounted:
```
/mnt/mydata
/home/data
/var/www
```

### Field 3: File System Type

The type of file system:
- `ext4` - Extended file system 4
- `xfs` - XFS file system
- `ext3` - Extended file system 3
- `swap` - Swap partition
- `auto` - Auto-detect

### Field 4: Mount Options

Common options:
- `defaults` - Uses default options (rw, suid, dev, exec, auto, nouser, async)
- `rw` - Read-write
- `ro` - Read-only
- `noexec` - Don't allow execution of binaries
- `nosuid` - Don't allow setuid/setgid
- `nodev` - Don't interpret device files
- `noatime` - Don't update access times (improves performance)
- `user` - Allow users to mount
- `nofail` - Don't fail if device doesn't exist

**Multiple options separated by commas:**
```
defaults,noatime
```

### Field 5: Dump

Backup utility flag:
- `0` - Don't backup (most common)
- `1` - Backup this filesystem

### Field 6: Pass (fsck order)

File system check order:
- `0` - Don't check
- `1` - Check first (usually root filesystem)
- `2` - Check after root (most other filesystems)

### Complete /etc/fstab Examples:

**Example 1: ext4 partition**
```
UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890  /mnt/mydata  ext4  defaults,noatime  0  2
```

**Example 2: xfs partition**
```
/dev/xvdf1  /mnt/data  xfs  defaults  0  2
```

**Example 3: Multiple partitions**
```
UUID=xxx-xxx-xxx  /mnt/logical1  ext4  defaults  0  2
UUID=yyy-yyy-yyy  /mnt/logical2  xfs  defaults,noatime  0  2
```


### Important Notes:

1. **Always test with `mount -a`** before rebooting
2. **Use UUID instead of device path** for reliability
3. **Keep a backup** of `/etc/fstab` before editing
4. **Incorrect fstab** can prevent system from booting

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

---

## AWS Snapshots

### What is a Snapshot?

An **EBS Snapshot** is a point-in-time backup of an EBS volume. It captures the exact state of the volume at the moment the snapshot is taken, including all data, file systems, and configurations.

### Key Characteristics:

- **Point-in-Time Backup**: Captures volume state at specific moment
- **Incremental**: Only stores changed blocks since last snapshot
- **Regional**: Stored in S3 (behind the scenes) in the same region
- **Independent**: Exists independently of the source volume
- **Encrypted**: Can be encrypted for security
- **Cost-Effective**: Only pay for changed data (incremental)

### Use Cases:

- **Backup and Recovery**: Regular backups of important data
- **Disaster Recovery**: Restore volumes in case of failure
- **Volume Migration**: Move volumes between AZs or regions
- **Volume Cloning**: Create new volumes from snapshots
- **Compliance**: Meet regulatory backup requirements

---

## How Snapshots Work

### Snapshot Process:

1. **Snapshot Request**: You initiate a snapshot creation
2. **Data Capture**: AWS captures all data blocks on the volume
3. **Storage**: Data is stored in S3 (managed by AWS)
4. **Incremental Storage**: Only changed blocks are stored
5. **Snapshot Available**: Snapshot becomes available for use

### Incremental Nature:

- **First Snapshot**: Stores all data blocks
- **Subsequent Snapshots**: Only stores blocks that changed
- **Storage Efficiency**: Reduces storage costs
- **Fast Creation**: Subsequent snapshots are faster

### Snapshot States:

- **pending**: Snapshot is being created
- **completed**: Snapshot is ready to use
- **error**: Snapshot creation failed

### Important Notes:

- **Volume Performance**: Snapshots don't significantly impact volume performance
- **Volume Status**: Volume can be in-use during snapshot
- **Consistency**: For databases, consider quiescing before snapshot
- **Completion Time**: Depends on volume size and data changes

---

## Practical Steps: Create Snapshot

### Method 1: Create Snapshot from EC2 Console

#### Step 1: Navigate to Volumes

1. Go to **EC2 Dashboard**
2. Click **"Volumes"** (under Elastic Block Store)
3. Select the volume you want to snapshot

#### Step 2: Create Snapshot

1. Select the volume
2. Click **"Actions"** → **"Create Snapshot"**
3. Configure snapshot:
   - **Name**: Enter descriptive name (e.g., "web-server-backup-2024")
   - **Description**: Optional description
   - **Tags**: Add tags if needed
4. Click **"Create Snapshot"**

#### Step 3: Monitor Snapshot Progress

1. Go to **EC2 Dashboard** → **Snapshots**
2. Find your snapshot
3. Check **Status** column:
   - **pending**: Still creating
   - **completed**: Ready to use

### Method 2: Create Snapshot from Snapshots Page

1. Go to **EC2 Dashboard** → **Snapshots**
2. Click **"Create Snapshot"**
3. Select **"Volume"** as source type
4. Select the volume from dropdown
5. Enter name and description
6. Click **"Create Snapshot"**

### Step 4: Verify Snapshot

1. Go to **Snapshots** page
2. Find your snapshot
3. Verify:
   - **Status**: completed
   - **Size**: Should match or be less than volume size
   - **Start Time**: When snapshot was created

---

## Moving EBS Volume Between AZs and Regions Using Snapshots

### Scenario 1: Move Volume to Another Availability Zone (Same Region)

#### Step 1: Create Snapshot

1. Go to **Volumes** → Select source volume
2. **Actions** → **Create Snapshot**
3. Name it (e.g., "volume-migration-snapshot")
4. Wait for status to be **completed**

#### Step 2: Create Volume from Snapshot in New AZ

1. Go to **Snapshots** → Select your snapshot
2. Click **"Actions"** → **"Create Volume from Snapshot"**
3. Configure new volume:
   - **Volume Type**: Select (e.g., gp3)
   - **Size**: Same or larger than original
   - **Availability Zone**: Select **different AZ** (e.g., us-east-1b instead of us-east-1a)
   - **Encryption**: Optional
4. Click **"Create Volume"**

#### Step 3: Attach New Volume to Instance

1. Select the new volume
2. **Actions** → **Attach Volume**
3. Select instance in the new AZ
4. Specify device name
5. Click **"Attach"**

#### Step 4: Verify and Use

1. SSH into the instance
2. Verify volume:
   ```bash
   lsblk
   df -hT
   ```
3. Mount if needed (if not auto-mounted)

### Scenario 2: Move Volume to Another Region

#### Step 1: Create Snapshot in Source Region

1. In source region (e.g., us-east-1):
   - Go to **Volumes** → Select volume
   - **Actions** → **Create Snapshot**
   - Name it (e.g., "cross-region-migration")
   - Wait for **completed** status

#### Step 2: Copy Snapshot to Destination Region

1. Go to **Snapshots** → Select your snapshot
2. Click **"Actions"** → **"Copy Snapshot"**
3. Configure copy:
   - **Destination Region**: Select target region (e.g., us-west-2)
   - **Description**: Optional
   - **Encryption**: Optional
4. Click **"Copy Snapshot"**

#### Step 3: Monitor Copy Progress

1. **Switch to destination region** (us-west-2)
2. Go to **Snapshots** → **Private Snapshots**
3. Find your copied snapshot
4. Wait for status to be **completed**

#### Step 4: Create Volume from Snapshot in Destination Region

1. In destination region, select the copied snapshot
2. **Actions** → **Create Volume from Snapshot**
3. Configure:
   - **Volume Type**: Select
   - **Size**: Same or larger
   - **Availability Zone**: Select AZ in destination region
4. Click **"Create Volume"**

#### Step 5: Attach to Instance in Destination Region

1. Select the new volume
2. **Actions** → **Attach Volume**
3. Select instance in destination region
4. Attach and verify

### Complete Example: Cross-Region Migration

**Source:** us-east-1 (Virginia)
**Destination:** us-west-2 (Oregon)

```bash
# Step 1: Create snapshot in us-east-1
# (Done via console)

# Step 2: Copy snapshot to us-west-2
# (Done via console - Actions → Copy Snapshot)

# Step 3: In us-west-2, create volume from snapshot
# (Done via console)

# Step 4: Attach to instance in us-west-2
# (Done via console)

# Step 5: Verify on instance
ssh -i key.pem ec2-user@<us-west-2-instance-ip>
lsblk
df -hT
```

### Important Notes:

- **Copy Time**: Depends on snapshot size and network speed
- **Costs**: You pay for snapshot storage and data transfer
- **Encryption**: Can encrypt during copy
- **Tags**: Copy tags separately if needed

---

## Lifecycle Rules in Snapshots

### What are Lifecycle Rules?

**Lifecycle rules** automatically manage snapshot retention and deletion based on age, count, or other criteria. This helps automate backup management and reduce costs.

### Benefits:

- **Automated Management**: No manual deletion needed
- **Cost Optimization**: Automatically delete old snapshots
- **Compliance**: Maintain required retention periods
- **Backup Rotation**: Keep recent backups, delete old ones

### Creating Lifecycle Rules Using Data Lifecycle Manager (DLM)

#### Step 1: Access Data Lifecycle Manager

1. Go to **EC2 Dashboard**
2. Click **"Lifecycle Manager"** (under Elastic Block Store)
3. Click **"Create lifecycle policy"**

#### Step 2: Configure Policy

**Policy Details:**
- **Policy type**: EBS Snapshot Management
- **Description**: Enter description
- **Target resource tags**: Select volumes to manage
  - Example: `Environment=Production`

**Policy Schedule:**
- **Name**: Daily backups
- **Frequency**: Daily, Weekly, or Custom
- **Time**: Select time (UTC)
- **Retention**: 
  - **Count**: Keep last N snapshots (e.g., 7)
  - **Age**: Keep snapshots for N days (e.g., 30)

**Example Configuration:**
```
Policy Type: EBS Snapshot Management
Target Tags: Environment=Production
Schedule: Daily at 2:00 AM UTC
Retention: Keep last 7 snapshots
```

#### Step 3: Add Tags

- Add tags to created snapshots (optional)
- Example: `BackupType=Automated`

#### Step 4: Review and Create

1. Review policy configuration
2. Click **"Create policy"**

### Lifecycle Rule Examples:

**Example 1: Daily Backups, Keep 7 Days**
```
Frequency: Daily
Time: 2:00 AM UTC
Retention: 7 days
```

**Example 2: Weekly Backups, Keep 4 Weeks**
```
Frequency: Weekly (Sunday)
Time: 3:00 AM UTC
Retention: 4 weeks (28 days)
```

**Example 3: Keep Last 10 Snapshots**
```
Frequency: Daily
Retention: Count = 10
```

### Manual Lifecycle Management (Alternative)

If not using DLM, you can manually manage:

1. **Tag Snapshots**: Use tags to identify backup sets
2. **Script Automation**: Use AWS CLI scripts
3. **CloudWatch Events**: Schedule snapshot creation/deletion
4. **Lambda Functions**: Automate lifecycle management

### Best Practices:

1. **Tag Resources**: Use consistent tagging strategy
2. **Test Policies**: Test lifecycle rules before production
3. **Monitor Costs**: Regularly review snapshot storage costs
4. **Retention Strategy**: Balance retention needs with costs
5. **Cross-Region Copies**: Consider copying critical snapshots

---

## Summary

### EBS (Elastic Block Store):
- Persistent block storage for EC2 instances
- Multiple storage classes: gp3, gp2, io1, io2, st1, sc1
- Can be created, attached, and detached from instances
- Supports snapshots for backup

### Partitions:
- Logical divisions of storage devices
- **Primary Partitions**: Up to 4 per disk
- **Extended Partition**: Container for logical partitions
- **Logical Partitions**: Unlimited, numbered from 5
- Created using `fdisk` command
- Updated with `partprobe` command
- Formatted with `mkfs` (ext4, xfs, ext3, etc.)
- Mounted temporarily or permanently via `/etc/fstab`

### Mounting:
- **Temporary Mount**: Lost after reboot (`mount` command)
- **Permanent Mount**: Persists after reboot (`/etc/fstab`)
- `/etc/fstab` has 6 fields: device, mount point, file system, options, dump, pass

### Snapshots:
- Point-in-time backups of EBS volumes
- Incremental storage (only changed blocks)
- Can move volumes between AZs and regions
- Lifecycle rules automate snapshot management
- Essential for backup, recovery, and migration

Understanding EBS, partitions, mounting, and snapshots is essential for managing storage in AWS EC2 instances effectively.

