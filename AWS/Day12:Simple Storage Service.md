# Amazon S3 (Simple Storage Service) - Complete Study Guide

*Comprehensive notes for DevOps Engineers, Cloud Practitioners, and AWS Interview Preparation*

---

## Table of Contents
1. [Introduction](#introduction)
2. [Core Concepts](#core-concepts)
3. [S3 Architecture](#s3-architecture)
4. [Storage Classes](#storage-classes)
5. [Data Management](#data-management)
6. [Security](#security)
7. [Access & Networking](#access--networking)
8. [Data Consistency](#data-consistency)
9. [Performance Optimization](#performance-optimization)
10. [Monitoring & Logging](#monitoring--logging)
11. [Cost Optimization](#cost-optimization)
12. [Real-World Scenarios](#real-world-scenarios)
13. [Interview Q&A](#interview-qa)

---

## Introduction

### What Problem Does S3 Solve?

**Before S3 (Traditional Storage):**
- Fixed capacity planning
- Expensive hardware costs
- Manual maintenance
- Limited availability
- Data loss risks
- Slow global access

**After S3:**
- Unlimited, auto-scaling storage
- Pay-per-use model
- Fully managed by AWS
- 99.999999999% durability
- 99.99% availability
- Global HTTP access

### Why Object Storage?

S3 stores data as **objects** (not blocks or files):

**Object Components:**
1. **Data**: The actual content
2. **Metadata**: Information about the object
3. **Key**: Unique identifier (like a file path)

**Key Differences:**

| Aspect | File System | S3 Object Storage |
|--------|------------|-------------------|
| Structure | Hierarchical folders | Flat namespace |
| Access | POSIX (open/read/write) | HTTP API (GET/PUT) |
| Modification | Partial updates | Full object replacement |
| Use Case | Databases, OS | Backups, archives, static content |

### Primary Use Cases

1. **Backup & Archive** - Database backups, disaster recovery
2. **Static Websites** - HTML/CSS/JS hosting
3. **Data Lakes** - Analytics and big data storage
4. **Application Storage** - User uploads, media files
5. **Content Distribution** - Images, videos via CloudFront
6. **Log Storage** - Centralized logging
7. **Disaster Recovery** - Cross-region replication

---

## Core Concepts

### 1. Buckets

**What is a Bucket?**
- Top-level container for objects
- Globally unique name (across all AWS accounts)
- Created in a specific AWS region
- Limit: 100 buckets per account (soft limit)

**Naming Rules:**
```
✓ Valid: my-company-bucket, data-2024, app-logs-mumbai
✗ Invalid: MyBucket (uppercase), my..bucket (consecutive dots), 192.168.1.1 (IP format)

Requirements:
- 3-63 characters
- Lowercase only
- No underscores
- Start/end with letter or number
```

### 2. Objects

**Components:**
```
Object = Key + Data + Metadata + Version ID (if versioning enabled)

Size limits:
- Minimum: 0 bytes
- Maximum: 5 TB
- Single PUT: 5 GB max (use multipart for larger)
```

### 3. Keys

The unique identifier for an object:
```
Key: "documents/2024/report.pdf"

Note: S3 has NO folders!
The "/" is just part of the key name
Console simulates folder structure for UX
```

### 4. Metadata

**System Metadata** (AWS-controlled):
- Content-Type
- Content-Length
- Last-Modified
- ETag

**User Metadata** (custom):
- Must start with "x-amz-meta-"
- Example: x-amz-meta-department=engineering
- Max 2 KB total

**Tags** (different from metadata):
- Up to 10 tags per object
- Used for cost tracking and IAM policies

### 5. Regions

- Each bucket exists in ONE region
- Data stays in that region (unless replication enabled)
- Choose based on:
  - Latency (proximity to users)
  - Compliance (data residency)
  - Cost (pricing varies by region)

### 6. Global Namespace

Bucket names must be unique **worldwide**:
```
Why? S3 URLs use bucket name:
https://my-bucket.s3.amazonaws.com

If two accounts had same name → conflict!
```

---

## S3 Architecture

### Data Storage Model

**Upload Process:**
```
1. Client → S3 API endpoint
2. Data split into chunks
3. Each chunk replicated 3+ times
4. Stored across multiple AZs
5. Confirmation returned
```

### Durability vs Availability

**Durability (99.999999999% - 11 9's):**
- Probability data WON'T be lost
- Store 10M objects → lose 1 every 10,000 years
- Achieved through: Multi-AZ replication, integrity checks, auto-repair

**Availability (99.99%):**
- Probability you CAN ACCESS data
- ~52 minutes downtime per year possible
- Temporary service unavailability

**Key Point:**
- High durability → Data won't be lost
- Lower availability → Temporarily inaccessible (but not lost)

### Request Flow

**Upload (PUT):**
```
App → DNS lookup → TLS connection → Authentication → 
Data ingestion → Replication (3 AZs) → Confirmation
```

**Download (GET):**
```
App → Authentication → Metadata lookup → 
Fetch from nearest replica → Stream to client
```

---

## Storage Classes

### Overview Table

| Class | Durability | Availability | AZs | Min Duration | Retrieval | Cost/GB |
|-------|-----------|--------------|-----|--------------|-----------|---------|
| Standard | 11 9's | 99.99% | ≥3 | None | Instant | $0.023 |
| Intelligent-Tiering | 11 9's | 99.9% | ≥3 | None | Instant | Auto |
| Standard-IA | 11 9's | 99.9% | ≥3 | 30 days | Instant | $0.0125 |
| One Zone-IA | 11 9's* | 99.5% | 1 | 30 days | Instant | $0.01 |
| Glacier Instant | 11 9's | 99.9% | ≥3 | 90 days | Milliseconds | $0.004 |
| Glacier Flexible | 11 9's | 99.99% | ≥3 | 90 days | Minutes-hours | $0.0036 |
| Glacier Deep Archive | 11 9's | 99.99% | ≥3 | 180 days | 12 hours | $0.00099 |

*One Zone-IA: 11 9's only if AZ survives

### When to Use Each Class

**S3 Standard:**
- Frequently accessed data
- Website content
- Active datasets
- No minimum duration

**S3 Intelligent-Tiering:**
- Unknown/changing access patterns
- Automatic cost optimization
- No retrieval fees
- Small monitoring fee

**S3 Standard-IA:**
- Infrequent access (monthly)
- Backups, DR files
- Quick retrieval needed
- 30-day minimum

**S3 One Zone-IA:**
- Reproducible data only
- Lower cost than Standard-IA
- Can regenerate if lost
- Single AZ risk

**Glacier Instant Retrieval:**
- Archive with instant access
- Medical records
- Rarely accessed but must be immediate
- 90-day minimum

**Glacier Flexible Retrieval:**
- Long-term archives
- Retrieval in hours acceptable
- Compliance data
- 90-day minimum

**Glacier Deep Archive:**
- Lowest cost
- 10+ year retention
- 12-hour retrieval OK
- 180-day minimum
- Tape replacement

### Lifecycle Transition Example

```json
{
  "Rules": [{
    "Id": "OptimizeCosts",
    "Status": "Enabled",
    "Transitions": [
      {"Days": 30, "StorageClass": "STANDARD_IA"},
      {"Days": 90, "StorageClass": "GLACIER_IR"},
      {"Days": 365, "StorageClass": "GLACIER"},
      {"Days": 2555, "StorageClass": "DEEP_ARCHIVE"}
    ],
    "Expiration": {"Days": 3650}
  }]
}
```

---

## Data Management

### 1. Versioning

**What it does:**
- Keeps multiple versions of objects
- Each version has unique ID
- Protects against accidental deletion

**States:**
- Unversioned (default)
- Enabled (cannot go back to unversioned)
- Suspended (can re-enable)

**Example:**
```
Day 1: Upload file.txt → Version v1
Day 2: Update file.txt → Version v2 (v1 preserved)
Day 3: Delete file.txt → Delete marker (v1, v2 still exist)

Recovery: Remove delete marker or download specific version
```

**With Lifecycle:**
```json
{
  "NoncurrentVersionTransitions": [
    {"NoncurrentDays": 30, "StorageClass": "STANDARD_IA"},
    {"NoncurrentDays": 90, "StorageClass": "GLACIER"}
  ],
  "NoncurrentVersionExpiration": {"NoncurrentDays": 365}
}
```

### 2. Lifecycle Rules

**Transition Actions:**
- Move objects between storage classes
- Based on age or tags

**Expiration Actions:**
- Delete objects after specified time
- Delete old versions
- Abort incomplete multipart uploads

**Real Example (Logs):**
```
Day 0: Upload to Standard
Day 30: Move to Standard-IA
Day 90: Move to Glacier
Day 365: Delete

Cost savings: ~70%
```

### 3. Replication

**Types:**
- **SRR (Same-Region)**: Same region replication
- **CRR (Cross-Region)**: Different region replication

**Requirements:**
- Versioning enabled on both buckets
- Proper IAM permissions

**Use Cases:**
- SRR: Log aggregation, compliance
- CRR: Disaster recovery, global access, compliance

**What's Replicated:**
✓ New objects after rule enabled
✓ Metadata and tags
✓ Object ACLs

✗ Objects before replication enabled
✗ Delete markers (unless configured)
✗ Glacier objects

### 4. Object Lock

**WORM Model** (Write Once Read Many):
- Prevents deletion/overwrite for fixed time or indefinitely
- Can only enable during bucket creation

**Modes:**
1. **Governance**: Admin can override
2. **Compliance**: Nobody can override (even root)

**Legal Hold:**
- Indefinite lock
- No expiration date
- Applied/removed by authorized users

**Use Cases:**
- Regulatory compliance (SEC, FINRA)
- Legal preservation
- Ransomware protection

### 5. S3 Storage Lens

**Organization-wide visibility:**
- Storage usage metrics
- Cost optimization insights
- Activity trends
- Recommendations

**Metrics:**
- Storage by class
- Object counts
- Request metrics
- Cost trends

**Free vs Advanced:**
- Free: 14 days, 28 metrics, account level
- Advanced: 15 months, 35+ metrics, prefix level

---

## Security

### Security Layers

```
1. Block Public Access (default ON)
2. IAM Policies (who can access)
3. Bucket Policies (resource-based)
4. Encryption (at rest and in transit)
5. VPC Endpoints (network isolation)
6. Access Logging (audit trail)
```

### 1. Bucket Policies

**When to use:**
- Cross-account access
- Public access (if needed)
- AWS service access
- Conditional access (IP, time, encryption)

**Example (Public Read):**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::my-website/*"
  }]
}
```

**Example (Enforce Encryption):**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Principal": "*",
    "Action": "s3:PutObject",
    "Resource": "arn:aws:s3:::secure-bucket/*",
    "Condition": {
      "StringNotEquals": {
        "s3:x-amz-server-side-encryption": "AES256"
      }
    }
  }]
}
```

### 2. IAM Policies

**When to use:**
- Control for IAM users/roles in your account
- Centralized user management

**Example:**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ],
    "Resource": [
      "arn:aws:s3:::dev-bucket",
      "arn:aws:s3:::dev-bucket/*"
    ]
  }]
}
```

### 3. ACLs (Deprecated)

**Status:** AWS recommends NOT using ACLs

**Why:**
- Less flexible than bucket policies
- Harder to manage
- Legacy feature

**Alternative:** Use bucket policies and IAM policies

### 4. Block Public Access

**Four Settings:**
1. BlockPublicAcls
2. IgnorePublicAcls
3. BlockPublicPolicy
4. RestrictPublicBuckets

**Effect:**
- Overrides bucket policies
- Safety net against accidental public exposure
- Enabled by default on new accounts

### 5. Encryption

**At Rest:**
- **SSE-S3**: S3-managed keys (default, free)
- **SSE-KMS**: KMS-managed keys (audit, rotation)
- **SSE-C**: Customer-provided keys

**In Transit:**
- HTTPS/TLS always recommended
- Can enforce via bucket policy

**Enforcing HTTPS:**
```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:*",
  "Resource": "arn:aws:s3:::secure-bucket/*",
  "Condition": {
    "Bool": {"aws:SecureTransport": "false"}
  }
}
```

---

## Access & Networking

### 1. VPC Endpoint

**What:** Private connection from VPC to S3

**Types:**
- **Gateway Endpoint** (FREE, recommended)
- **Interface Endpoint** (paid, for specific cases)

**Benefits:**
- Traffic stays on AWS network
- No NAT Gateway costs
- Better security
- Lower latency

**Savings Example:**
```
Without endpoint: EC2 → NAT Gateway → S3
Cost: $32/month + $45/GB = $77/month for 1 TB

With endpoint: EC2 → VPC Endpoint → S3
Cost: $0
```

### 2. Presigned URLs

**What:** Temporary URLs with embedded authentication

**Use Cases:**
- User uploads without AWS credentials
- Temporary downloads
- Share private files
- Pay-per-download

**Generating:**
```bash
aws s3 presign s3://bucket/file.pdf --expires-in 3600
```

**Security:**
- Inherit creator's permissions
- Time-limited (max 7 days)
- Revoked if creator's credentials revoked

### 3. Static Website Hosting

**Steps:**
1. Upload HTML/CSS/JS files
2. Enable static website hosting
3. Make bucket public (bucket policy)
4. Access via S3 website endpoint

**Endpoint Format:**
```
http://bucket-name.s3-website-region.amazonaws.com
```

**For HTTPS:** Use CloudFront

---

## Data Consistency

### Current Model (Since Dec 2020)

**Strong Read-After-Write Consistency**

All operations are now strongly consistent:
- PUT new object → immediately visible
- Overwrite object → immediately see new version
- DELETE object → immediately not accessible
- LIST bucket → immediately accurate

**Before 2020:**
- Eventual consistency for overwrites
- Required complex retry logic
- Unpredictable behavior

**Now:**
- Simple application code
- No wait/retry needed
- Trust all operations immediately

---

## Performance Optimization

### 1. Multipart Upload

**When:**
- Files > 100 MB (recommended)
- Files > 5 GB (required)

**Benefits:**
- Parallel uploads
- Resume on failure
- Upload before knowing final size

**AWS CLI:**
```bash
# Handles multipart automatically
aws s3 cp large-file.zip s3://bucket/
```

**Best Practice:**
```
Cleanup incomplete uploads after 7 days:
{
  "AbortIncompleteMultipartUpload": {
    "DaysAfterInitiation": 7
  }
}
```

### 2. Transfer Acceleration

**What:** Route uploads through CloudFront edge locations

**Benefits:**
- Faster uploads over long distances
- Uses AWS backbone network
- Only charged if faster

**Enable:**
```bash
aws s3api put-bucket-accelerate-configuration   --bucket my-bucket   --accelerate-configuration Status=Enabled
```

**When to Use:**
- Global user uploads
- Large files
- Long distances
- Critical upload speed

### 3. Performance Limits

**Current (2018+):**
- 3,500 PUT/POST/DELETE per second per prefix
- 5,500 GET/HEAD per second per prefix
- Automatic scaling

**No need for random prefixes!**
Use logical organization instead.

---

## Monitoring & Logging

### 1. CloudWatch Metrics

**Storage Metrics** (Free, Daily):
- BucketSizeBytes
- NumberOfObjects

**Request Metrics** (Paid, 1-minute):
- AllRequests, GetRequests, PutRequests
- 4xxErrors, 5xxErrors
- BytesDownloaded, BytesUploaded
- FirstByteLatency

### 2. Server Access Logs

**What:** Detailed request logs

**Log Contains:**
- Request time, IP, user
- Operation, status code
- Object key, bytes sent
- User agent, referrer

**Use Cases:**
- Security auditing
- Usage analysis
- Troubleshooting
- Compliance

### 3. CloudTrail (Object-Level)

**What:** API call logging

**Events:**
- GetObject, PutObject, DeleteObject
- Management events (CreateBucket, etc.)

**Benefits:**
- Real-time monitoring
- EventBridge integration
- Security analysis

### 4. S3 Storage Lens

**Organization-wide insights:**
- Storage usage trends
- Cost optimization recommendations
- Activity metrics
- Anomaly detection

---

## Cost Optimization

### 1. Right Storage Class

**Decision Tree:**
```
How often accessed?
├─ Daily/Weekly → Standard
├─ Monthly → Standard-IA
├─ Rarely, instant needed → Glacier Instant
├─ Rarely, hours OK → Glacier Flexible
└─ Almost never → Deep Archive

Can regenerate if lost?
├─ No → Multi-AZ (Standard, Standard-IA, Glacier)
└─ Yes → One Zone-IA

Access pattern known?
├─ Yes → Choose specific class
└─ No → Intelligent-Tiering
```

### 2. Lifecycle Policies

**Cost Savings Example:**
```
100 GB logs, kept 1 year:

Without lifecycle:
100 GB × $0.023 × 12 = $27.60/year

With lifecycle (30 days Standard, rest IA):
(100 × $0.023 × 1) + (100 × $0.0125 × 11) = $15.95/year

Savings: 42%
```

### 3. Common Mistakes

**Mistake 1:** Not deleting old versions
- Impact: 10× storage cost if 10 versions
- Fix: NoncurrentVersionExpiration lifecycle rule

**Mistake 2:** Incomplete multipart uploads
- Impact: Hidden storage costs
- Fix: AbortIncompleteMultipartUpload rule

**Mistake 3:** Wrong storage class
- Impact: Paying for unused speed/availability
- Fix: Use Storage Lens to identify

**Mistake 4:** Data transfer costs
- Impact: Expensive cross-region transfers
- Fix: Use VPC Endpoint, CloudFront, same-region when possible

### 4. Cost Optimization Checklist

```
✓ Enable S3 Storage Lens
✓ Review storage class distribution monthly
✓ Implement lifecycle rules for all data
✓ Clean up incomplete uploads
✓ Delete old versions per policy
✓ Use Intelligent-Tiering for unknown patterns
✓ Use VPC Endpoint for private access
✓ Use CloudFront for public content
✓ Monitor with Cost Explorer
✓ Set billing alerts
```

---

## Real-World Scenarios

### 1. Static Website

```
Architecture:
S3 bucket (website files) → CloudFront → Route 53 → Users

Steps:
1. Create bucket: www.example.com
2. Upload files (index.html, etc.)
3. Enable static website hosting
4. Add bucket policy (public read)
5. Create CloudFront distribution
6. Configure Route 53 DNS
7. Enable HTTPS (ACM certificate)

Cost (1 GB site, 10K visitors/month):
- S3 storage: $0.02
- S3 requests: $0.04
- CloudFront: $0.85
Total: ~$1/month
```

### 2. Centralized Logging

```
Architecture:
EC2/Lambda/ALB → S3 (organized by source/date) → Athena (queries)

Structure:
logs/
├── ec2/{instance-id}/{year}/{month}/{day}/
├── lambda/{function}/{year}/{month}/{day}/
└── alb/{year}/{month}/{day}/

Lifecycle:
- 0-30 days: Standard (active analysis)
- 30-90 days: Standard-IA (occasional queries)
- 90-365 days: Glacier (compliance)
- >365 days: Delete

Cost savings: 70-80%
```

### 3. Backup Strategy

```
Tiering:
- Recent (0-30 days): Standard → quick recovery
- Medium (30-90 days): Standard-IA → occasional restore
- Long-term (90-365 days): Glacier → compliance
- Archive (1-7 years): Deep Archive → regulatory

Features:
- Versioning: Enabled
- Object Lock: Compliance mode (critical data)
- Replication: Cross-region (DR)
- Lifecycle: Automated transitions

Automation:
- Scheduled backups (Lambda + EventBridge)
- Automatic S3 upload
- SNS notifications
- Monthly validation
```

### 4. Data Lake

```
Zones:
1. Landing (Raw): S3 Standard
2. Processing (Cleaned): Intelligent-Tiering
3. Curated (Analytics-ready): Standard → IA

Tools:
- AWS Glue: ETL and catalog
- Athena: SQL queries
- EMR: Big data processing
- QuickSight: Visualization

Optimization:
- Partitioning by date
- Parquet/ORC compression
- S3 Select for filtering
- Lifecycle policies per zone
```

---

## Interview Q&A

### Beginner

**Q: Why is S3 not a file system?**
```
A: S3 is object storage, not file storage:
- Flat namespace (no real folders)
- HTTP API (not POSIX file operations)
- Full object operations (can't modify parts)
- Optimized for large, sequential access
- Higher latency than file systems

Use cases:
- Use S3: Backups, archives, static content
- Use EFS: Shared file system, content management
- Use EBS: OS disks, databases
```

**Q: Difference between EBS, EFS, and S3?**
```
A:
EBS (Block Storage):
- Single EC2 instance
- Low latency, high IOPS
- Single AZ
- Use: OS disks, databases

EFS (File Storage):
- Multiple EC2 instances
- NFS protocol
- Multi-AZ
- Use: Shared files, content management

S3 (Object Storage):
- HTTP access
- Unlimited scale
- Regional (global namespace)
- Use: Backups, static sites, data lakes
```

**Q: How does S3 achieve 11 9's durability?**
```
A: Through multiple mechanisms:

1. Redundancy: 3+ copies across multiple AZs
2. Integrity checks: Continuous checksums
3. Auto-repair: Replace corrupted data automatically
4. Geographic distribution: Survive facility loss
5. Erasure coding: Efficient redundancy

Result: Store 10M objects, lose 1 every 10,000 years
```

### Intermediate

**Q: When to use Glacier vs Deep Archive?**
```
A:
Glacier Flexible:
- Access 1-2 times/year
- 3-5 hour retrieval OK
- Compliance, annual backups
- Cost: $0.0036/GB/month

Deep Archive:
- Access rarely (years)
- 12-hour retrieval OK
- 7-10+ year retention
- Cost: $0.00099/GB/month

Choose based on:
- Access frequency
- Acceptable retrieval time
- Storage duration
- Cost sensitivity
```

**Q: How to secure sensitive data in S3?**
```
A: Multi-layer approach:

1. Access Control:
   - Block Public Access (ON)
   - IAM policies (least privilege)
   - Bucket policies (resource-based)

2. Encryption:
   - At rest: SSE-KMS (audit + rotation)
   - In transit: HTTPS enforced

3. Network:
   - VPC Endpoint (private access)
   - IP restrictions

4. Monitoring:
   - CloudTrail (API logs)
   - Server access logs
   - CloudWatch alarms

5. Protection:
   - Versioning (accidental deletion)
   - Object Lock (immutability)
   - MFA Delete

6. Compliance:
   - Macie (sensitive data detection)
   - Config rules (compliance)
```

### Advanced

**Q: Design cost-effective architecture for 1PB video platform**
```
A:
Strategy:

1. Tiering by Age:
   - New (0-30 days): Standard → 50 TB
   - Recent (30-180 days): Intelligent-Tiering → 200 TB
   - Catalog (180-730 days): Glacier Instant → 250 TB
   - Archive (>2 years): Glacier Flexible → 500 TB

2. By Resolution:
   - 4K: Glacier Instant (niche)
   - 1080p: Standard/Intelligent-Tiering (popular)
   - 720p: Standard
   - 480p/360p: One Zone-IA (can regenerate)

3. Delivery:
   - CloudFront (reduce S3 requests by 80%)
   - Origin: S3 Standard
   - Cache hot content globally

4. Lifecycle:
   Day 0 → Standard
   Day 30 → Intelligent-Tiering
   Day 180 → Glacier Instant
   Day 730 → Glacier Flexible

5. Optimizations:
   - Compression (H.265)
   - Deduplication
   - Cleanup incomplete uploads
   - CloudFront for egress

Cost:
- All Standard: $23,000/month
- Optimized: $7,000/month
- Savings: 70% ($192,000/year)
```

---

## Quick Reference

### Common CLI Commands

```bash
# Create bucket
aws s3 mb s3://my-bucket

# Upload file
aws s3 cp file.txt s3://my-bucket/

# Upload directory
aws s3 cp ./dir s3://my-bucket/dir --recursive

# Download
aws s3 cp s3://my-bucket/file.txt ./

# List
aws s3 ls s3://my-bucket/

# Sync
aws s3 sync ./local s3://my-bucket/remote

# Delete object
aws s3 rm s3://my-bucket/file.txt

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket my-bucket \
  --versioning-configuration Status=Enabled

# Generate presigned URL
aws s3 presign s3://my-bucket/file.txt --expires-in 3600
```

### Best Practices Summary

**Security:**
```
✓ Block Public Access enabled
✓ IAM roles over access keys
✓ Encrypt sensitive data (SSE-KMS)
✓ Enable versioning
✓ Use VPC Endpoints
✓ CloudTrail logging
✓ Regular access audits
```

**Cost:**
```
✓ Right storage class
✓ Lifecycle rules
✓ Intelligent-Tiering
✓ Cleanup old versions
✓ Delete incomplete uploads
✓ Use S3 Storage Lens
✓ CloudFront for delivery
```

**Performance:**
```
✓ Multipart upload (>100 MB)
✓ Transfer Acceleration (global)
✓ CloudFront (caching)
✓ VPC Endpoint (high throughput)
✓ Byte-range requests
✓ Retry with exponential backoff
```

**Reliability:**
```
✓ Versioning (critical data)
✓ Cross-region replication (DR)
✓ Object Lock (compliance)
✓ Test restores regularly
✓ Monitor with CloudWatch
✓ Lifecycle automation
```

---

*End of AWS S3 Complete Guide*