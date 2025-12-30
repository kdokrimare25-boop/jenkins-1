# Day 4: AMI (Amazon Machine Image)

## What is AMI?

**AMI (Amazon Machine Image)** is a template that contains a software configuration (operating system, application server, and applications) required to launch an EC2 instance. It's essentially a snapshot of a root volume with additional configuration information.

### Key Characteristics:

- **Template for EC2 Instances**: Pre-configured virtual machine image
- **Contains**: Operating system, application software, and configuration
- **Region-Specific**: AMIs are tied to a specific AWS region
- **Version Control**: Can create multiple versions of the same AMI
- **Reusable**: Can launch multiple instances from a single AMI
- **Customizable**: Can create custom AMIs from existing instances

### Components of an AMI:

1. **Root Volume Template**: Contains the OS and applications
2. **Launch Permissions**: Controls who can use the AMI
3. **Block Device Mapping**: Defines volumes to attach to instances
4. **Kernel and RAM Disk**: (For paravirtual AMIs)

### Use Cases:

- **Standardized Environments**: Create consistent development, staging, and production environments
- **Application Deployment**: Package applications with their dependencies
- **Disaster Recovery**: Quick recovery from system failures
- **Compliance**: Maintain compliant system configurations
- **Cost Optimization**: Pre-configured instances reduce setup time

---

## Types of AMI

### 1. **Public AMI**

- **Access**: Available to all AWS users
- **Source**: Created by AWS, community, or third-party vendors
- **Cost**: Free or paid (marketplace AMIs)
- **Use Case**: Quick start with common configurations
- **Examples**: Amazon Linux, Ubuntu, Windows Server, pre-configured applications

**Characteristics:**
- No charges for AMI itself (only for EC2 resources)
- Regularly updated by providers
- Well-documented and supported
- May include software licenses

### 2. **Private AMI**

- **Access**: Only accessible by your AWS account
- **Source**: Created by you or shared with your account
- **Cost**: Only storage costs for AMI
- **Use Case**: Custom configurations, proprietary software
- **Security**: Full control over access

**Characteristics:**
- Not visible to other AWS accounts
- Can be shared with specific accounts
- Ideal for company-specific configurations
- Requires proper access management

### 3. **Shared AMI**

- **Access**: Shared with specific AWS accounts
- **Source**: Created by other accounts and shared with you
- **Cost**: Depends on the AMI owner's pricing
- **Use Case**: Collaboration, vendor-provided images
- **Security**: Access controlled by AMI owner

**Characteristics:**
- Requires explicit permission from owner
- Can be shared across organizations
- Useful for partner/vendor relationships
- Owner can revoke access anytime

### 4. **AWS Marketplace AMI**

- **Access**: Publicly available but may require subscription
- **Source**: Third-party vendors and AWS partners
- **Cost**: May include software licensing fees
- **Use Case**: Commercial software, enterprise applications
- **Support**: Vendor-provided support

**Characteristics:**
- Pre-configured with commercial software
- May require subscription or license
- Vendor support included
- Regular updates and patches

### 5. **Community AMI**

- **Access**: Publicly available
- **Source**: AWS community members
- **Cost**: Free (but verify before use)
- **Use Case**: Open-source configurations, community projects
- **Security**: Use at your own risk

**Characteristics:**
- Created by community members
- No official support
- Should be verified before use
- May contain security vulnerabilities

### AMI Types Based on Virtualization:

#### **HVM (Hardware Virtual Machine)**
- **Full Virtualization**: Complete hardware abstraction
- **Performance**: Better performance, supports enhanced networking
- **Compatibility**: Works with all instance types
- **Boot Process**: Uses bootloader
- **Use Case**: Modern applications, high performance

#### **PV (Paravirtual)**
- **Paravirtualization**: Guest OS aware of hypervisor
- **Performance**: Good performance but limited
- **Compatibility**: Only older instance types
- **Boot Process**: Requires PV-GRUB
- **Use Case**: Legacy systems, older applications

---

## Similarity Between AMI and Snapshot

### Similarities:

| Aspect | AMI | Snapshot |
|--------|-----|----------|
| **Storage** | Stored in S3 (managed by AWS) | Stored in S3 (managed by AWS) |
| **Incremental** | Only stores changed blocks | Only stores changed blocks |
| **Point-in-Time** | Captures state at creation time | Captures state at creation time |
| **Regional** | Region-specific | Region-specific |
| **Copyable** | Can be copied to other regions | Can be copied to other regions |
| **Encryption** | Supports encryption | Supports encryption |
| **Cost** | Pay for storage | Pay for storage |
| **Lifecycle** | Can be managed with lifecycle policies | Can be managed with lifecycle policies |

### Key Differences:

| Aspect | AMI | Snapshot |
|--------|-----|----------|
| **Purpose** | Template to launch instances | Backup of volume data |
| **Contains** | OS, applications, configuration | Only data from volume |
| **Launch** | Can launch new instances | Cannot launch instances directly |
| **Metadata** | Includes launch permissions, block device mapping | No launch metadata |
| **Size** | Typically larger (includes OS) | Only data size |
| **Use Case** | Instance creation, standardization | Backup, recovery, volume migration |

### Relationship:

- **AMI Creation**: When you create an AMI, AWS automatically creates snapshots of the attached EBS volumes
- **Snapshot Dependency**: AMIs depend on snapshots for volume data
- **Snapshot Independence**: Snapshots can exist without AMIs
- **AMI Components**: An AMI = Snapshot(s) + Metadata + Launch Configuration

---

## AMI Benefits

### 1. **Rapid Instance Deployment**

- **Quick Launch**: Launch pre-configured instances in minutes
- **Consistency**: Same configuration every time
- **Automation**: Enables automated scaling and deployment
- **Time Savings**: No need to install and configure software manually

### 2. **Standardization**

- **Consistent Environments**: Same configuration across dev, staging, production
- **Compliance**: Maintain compliant system configurations
- **Best Practices**: Enforce security and configuration standards
- **Documentation**: AMI serves as documentation of system configuration

### 3. **Disaster Recovery**

- **Quick Recovery**: Launch new instances from AMI in case of failure
- **Backup Strategy**: Regular AMI creation for backup
- **Point-in-Time Recovery**: Revert to known good state
- **Business Continuity**: Minimize downtime

### 4. **Cost Optimization**

- **Reduced Setup Time**: Faster deployment means lower labor costs
- **Automated Scaling**: Auto Scaling groups can use AMIs
- **Resource Efficiency**: Pre-configured instances reduce waste
- **License Management**: Bundle licenses with AMI

### 5. **Security**

- **Hardened Images**: Pre-configured with security best practices
- **Patch Management**: Apply patches before creating AMI
- **Access Control**: Control who can use your AMIs
- **Compliance**: Maintain security compliance standards

### 6. **Scalability**

- **Auto Scaling**: Auto Scaling groups use AMIs for new instances
- **Load Balancing**: Launch identical instances behind load balancer
- **Multi-Region**: Deploy same configuration across regions
- **Elasticity**: Scale up/down quickly

### 7. **Development and Testing**

- **Environment Cloning**: Clone production to test environment
- **Version Control**: Maintain different AMI versions
- **Testing**: Test configurations before production
- **Rollback**: Quick rollback to previous AMI version

### 8. **Compliance and Governance**

- **Audit Trail**: Track AMI creation and usage
- **Policy Enforcement**: Enforce organizational policies
- **Regulatory Compliance**: Meet regulatory requirements
- **Change Management**: Control system changes

---

## How to Recover Key Pair with AMI

### Problem Scenario:

You've lost access to your EC2 instance key pair, but you have an AMI of the instance. You need to recover access.

### Solution: Create New Instance from AMI with New Key Pair

#### Step 1: Create AMI from Existing Instance (If Not Already Created)

1. Go to **EC2 Dashboard** → Select your instance
2. Click **"Actions"** → **"Image and templates"** → **"Create Image"**
3. Configure AMI:
   - **Name**: Enter descriptive name (e.g., "recovery-ami-2024")
   - **Description**: Optional description
   - **No reboot**: Uncheck if you want to ensure consistency
4. Click **"Create Image"**
5. Wait for AMI status to become **"available"**

#### Step 2: Launch New Instance from AMI

1. Go to **EC2 Dashboard** → **AMIs**
2. Select your AMI (filter by "Owned by me")
3. Click **"Launch Instance from AMI"**
4. Configure instance:
   - **Name**: Enter instance name
   - **Key pair**: **Select or create a NEW key pair** (this is the recovery key)
   - **Network settings**: Configure as needed
   - **Storage**: Adjust if needed
5. Click **"Launch Instance"**

#### Step 3: Access New Instance with New Key Pair

```bash
# SSH into new instance with new key pair
ssh -i new-key.pem ec2-user@<new-instance-ip>

# Or for Ubuntu
ssh -i new-key.pem ubuntu@<new-instance-ip>
```

#### Step 4: (Optional) Add New Key to Original Instance

If you still have access to the original instance through console or other means:

1. SSH into the new instance
2. Copy the new public key
3. Add it to the original instance's `~/.ssh/authorized_keys`

### Alternative Method: Modify Existing Instance

#### Step 1: Stop the Instance

1. Select instance → **Actions** → **Instance State** → **Stop**

#### Step 2: Detach Root Volume

1. Go to **Volumes** → Select root volume
2. **Actions** → **Detach Volume**

#### Step 3: Launch Temporary Instance

1. Launch a new instance with a new key pair
2. Attach the detached root volume as a secondary volume

#### Step 4: Mount and Modify

```bash
# SSH into temporary instance
ssh -i new-key.pem ec2-user@<temp-instance-ip>

# List volumes
lsblk

# Mount the attached volume
sudo mkdir /mnt/recovery
sudo mount /dev/xvdf1 /mnt/recovery  # Adjust device name

# Add new public key
sudo mkdir -p /mnt/recovery/home/ec2-user/.ssh
echo "new-public-key-here" | sudo tee /mnt/recovery/home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /mnt/recovery/home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /mnt/recovery/home/ec2-user/.ssh/authorized_keys

# Unmount
sudo umount /mnt/recovery
```

#### Step 5: Reattach and Start

1. Detach volume from temporary instance
2. Attach back to original instance as root volume
3. Start the original instance
4. Access with new key pair

---

## How AMI Can Be Transferred to Another Region

### Method 1: Copy AMI to Another Region

#### Step 1: Locate Your AMI

1. Go to **EC2 Dashboard** → **AMIs**
2. Select the AMI you want to copy
3. Note the **AMI ID**

#### Step 2: Copy AMI

1. Select the AMI
2. Click **"Actions"** → **"Copy AMI"**
3. Configure copy:
   - **Destination Region**: Select target region (e.g., us-west-2)
   - **Name**: Enter name for copied AMI
   - **Description**: Optional description
   - **Encryption**: Choose encryption option
4. Click **"Copy AMI"**

#### Step 3: Monitor Copy Progress

1. **Switch to destination region**
2. Go to **AMIs** → **Pending AMIs**
3. Wait for status to change to **"available"**

#### Step 4: Launch Instance in New Region

1. In destination region, select the copied AMI
2. Click **"Launch Instance from AMI"**
3. Configure and launch instance

### Method 2: Using AWS CLI

```bash
# Copy AMI to another region
aws ec2 copy-image \
    --source-region us-east-1 \
    --source-image-id ami-12345678 \
    --region us-west-2 \
    --name "my-copied-ami" \
    --description "AMI copied to us-west-2"

# Monitor copy status
aws ec2 describe-images \
    --region us-west-2 \
    --image-ids ami-87654321
```

### Important Notes:

- **Copy Time**: Depends on AMI size and network speed
- **Costs**: You pay for AMI storage in both regions
- **Snapshots**: Underlying snapshots are automatically copied
- **Encryption**: Can encrypt during copy
- **Permissions**: Launch permissions are not copied (must be set separately)

### Cross-Region AMI Sharing:

1. **Share AMI**: Modify AMI permissions to share with another account
2. **Copy in Target Account**: The other account can copy the shared AMI
3. **Launch**: Launch instances from copied AMI in target region

---

## Recovering Issues Server Using EBS Root Volume Migration

### Scenario:

Your EC2 instance has issues (corrupted files, misconfiguration, etc.), but you want to fix it without losing data. You can move the root volume to another instance, fix it, and move it back.

### Step-by-Step Recovery Process:

#### Step 1: Stop the Problematic Instance

1. Go to **EC2 Dashboard** → Select problematic instance
2. **Actions** → **Instance State** → **Stop**
3. Wait for instance to fully stop

**Important**: Ensure instance is stopped, not terminated

#### Step 2: Detach Root Volume

1. Go to **Volumes** (under Elastic Block Store)
2. Find the root volume attached to the problematic instance
3. Select the volume
4. **Actions** → **Detach Volume**
5. Wait for volume status to be **"available"**

**Note**: Root volume device name is typically `/dev/xvda` or `/dev/sda1`

#### Step 3: Launch Temporary Recovery Instance

1. Launch a new EC2 instance (same or different instance type)
2. Use a working AMI (same OS family recommended)
3. Ensure it's in the same Availability Zone as the detached volume
4. Use a key pair you have access to
5. Note the instance ID and private IP

#### Step 4: Attach Problematic Volume to Recovery Instance

1. Select the detached root volume
2. **Actions** → **Attach Volume**
3. Configure:
   - **Instance**: Select recovery instance
   - **Device**: Use a different device name (e.g., `/dev/xvdf`)
4. Click **"Attach"**

#### Step 5: SSH into Recovery Instance

```bash
ssh -i recovery-key.pem ec2-user@<recovery-instance-ip>
```

#### Step 6: Mount the Problematic Volume

```bash
# List block devices
lsblk

# Output example:
# xvda    202:0    0   8G  0 disk /
# xvdf    202:80   0  20G  0 disk    # This is the problematic volume
#   └─xvdf1 202:81   0  20G  0 part

# Create mount point
sudo mkdir /mnt/recovery

# Mount the problematic root volume
sudo mount /dev/xvdf1 /mnt/recovery

# Verify mount
df -hT
lsblk
```

#### Step 7: Fix Issues on the Volume

Now you can access and fix the problematic volume:

```bash
# Check file system
sudo fsck -y /dev/xvdf1

# Access the mounted volume
cd /mnt/recovery

# Fix configuration files
sudo vim /mnt/recovery/etc/fstab
sudo vim /mnt/recovery/etc/ssh/sshd_config

# Repair broken packages (for Linux)
sudo chroot /mnt/recovery
apt update  # or yum update
apt install --fix-broken  # or yum check
exit

# Check logs
sudo cat /mnt/recovery/var/log/syslog
sudo journalctl -D /mnt/recovery/var/log/journal

# Fix permissions
sudo chown -R user:user /mnt/recovery/home/user
sudo chmod 600 /mnt/recovery/home/user/.ssh/authorized_keys
```

#### Step 8: Unmount and Detach Volume

```bash
# Exit from recovery directory
cd ~

# Unmount the volume
sudo umount /mnt/recovery

# Verify unmount
df -hT
```

1. Go to **Volumes** → Select the volume
2. **Actions** → **Detach Volume**
3. Wait for status to be **"available"**

#### Step 9: Reattach Volume to Original Instance

1. Select the fixed volume
2. **Actions** → **Attach Volume**
3. Configure:
   - **Instance**: Select original problematic instance
   - **Device**: Use the **original root device name** (e.g., `/dev/xvda`)
4. Click **"Attach"**

#### Step 10: Start Original Instance

1. Go to **EC2 Dashboard** → Select original instance
2. **Actions** → **Instance State** → **Start**
3. Wait for instance to be running

#### Step 11: Verify Fix

```bash
# SSH into original instance
ssh -i original-key.pem ec2-user@<original-instance-ip>

# Verify services are working
sudo systemctl status nginx
sudo systemctl status apache2

# Check application
curl http://localhost
```

#### Step 12: Clean Up (Optional)

1. **Terminate Recovery Instance**: If no longer needed
2. **Delete Recovery Instance**: To avoid charges

### Common Recovery Scenarios:

#### Scenario 1: Corrupted File System

```bash
# Mount volume on recovery instance
sudo mount /dev/xvdf1 /mnt/recovery

# Run file system check
sudo fsck -y /dev/xvdf1

# If errors found, repair
sudo fsck -y -f /dev/xvdf1

# Unmount and reattach
```

#### Scenario 2: Misconfigured Services

```bash
# Mount volume
sudo mount /dev/xvdf1 /mnt/recovery

# Fix service configuration
sudo vim /mnt/recovery/etc/nginx/nginx.conf
sudo vim /mnt/recovery/etc/apache2/apache2.conf

# Fix systemd services
sudo vim /mnt/recovery/etc/systemd/system/myservice.service
```

#### Scenario 3: Lost SSH Access

```bash
# Mount volume
sudo mount /dev/xvdf1 /mnt/recovery

# Add new SSH key
echo "new-public-key" | sudo tee -a /mnt/recovery/home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /mnt/recovery/home/ec2-user/.ssh/authorized_keys

# Fix SSH configuration
sudo vim /mnt/recovery/etc/ssh/sshd_config
```

#### Scenario 4: Broken Package Manager

```bash
# Mount volume
sudo mount /dev/xvdf1 /mnt/recovery

# Chroot into the volume
sudo chroot /mnt/recovery

# Fix package database
apt-get clean
apt-get update --fix-missing
dpkg --configure -a
apt-get install -f

exit
```

### Important Considerations:

1. **Availability Zone**: Recovery instance must be in same AZ as volume
2. **Volume Size**: Ensure recovery instance has enough space
3. **File System**: Use appropriate file system tools
4. **Backup**: Create snapshot before making changes
5. **Testing**: Test fixes before reattaching to production instance

---

## AMI Lifecycle Management

### Creating AMIs:

#### From Running Instance:

1. **EC2 Dashboard** → Select instance
2. **Actions** → **Image and templates** → **Create Image**
3. Configure:
   - Name and description
   - No reboot (optional)
   - Instance volumes
4. Create AMI

#### From Stopped Instance:

- Same process, but ensures data consistency
- Recommended for production AMIs

### AMI States:

- **pending**: AMI creation in progress
- **available**: AMI ready to use
- **invalid**: AMI creation failed
- **deregistered**: AMI has been deregistered (snapshots may still exist)

### Best Practices:

1. **Regular Updates**: Create new AMIs after updates
2. **Versioning**: Use naming conventions for versions
3. **Testing**: Test AMIs before production use
4. **Documentation**: Document AMI contents and purpose
5. **Cleanup**: Remove old/unused AMIs to save costs
6. **Encryption**: Encrypt AMIs for sensitive data
7. **Permissions**: Control who can use your AMIs

---

## Summary

### AMI (Amazon Machine Image):
- Template for launching EC2 instances
- Contains OS, applications, and configuration
- Region-specific but can be copied
- Types: Public, Private, Shared, Marketplace, Community
- Virtualization: HVM (preferred) or PV (legacy)

### Key Concepts:
- **Similar to Snapshots**: Both use incremental storage in S3
- **Different Purpose**: AMI for launching instances, Snapshot for backup
- **Relationship**: AMIs depend on snapshots for volume data

### Benefits:
- Rapid deployment, standardization, disaster recovery
- Cost optimization, security, scalability
- Development/testing, compliance

### Practical Applications:
- **Key Pair Recovery**: Launch new instance from AMI with new key
- **Cross-Region Migration**: Copy AMI to another region
- **Server Recovery**: Move root volume to recovery instance, fix, and move back

Understanding AMIs is essential for efficient EC2 instance management, disaster recovery, and maintaining consistent infrastructure across environments.

