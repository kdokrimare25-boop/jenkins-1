# AWS Identity and Access Management (IAM) - Study Notes

## Table of Contents
1. [IAM Users](#iam-users)
2. [IAM Groups](#iam-groups)
3. [IAM Policies](#iam-policies)
4. [IAM Roles](#iam-roles)
5. [When to Use Roles vs Programmatic Access](#when-to-use-roles-vs-programmatic-access)
6. [Best Practices](#best-practices)

---

## IAM Users

### What is an IAM User?

An IAM user is an identity within your AWS account that represents a person or application that interacts with AWS resources. Each IAM user has:
- A unique name within the AWS account
- Credentials for authentication
- Permissions to access specific AWS resources

### Types of Access

#### Console Access
- Allows users to sign in to the AWS Management Console via a web browser
- Requires a username and password
- Can be protected with Multi-Factor Authentication (MFA)
- Interactive interface for managing AWS resources

**Use Cases:**
- Developers managing infrastructure through the AWS Console
- Administrators configuring services manually
- Operations teams monitoring dashboards
- Business analysts accessing Cost Explorer or billing information

#### Programmatic Access
- Enables access to AWS via APIs, CLI, SDKs, or other development tools
- Uses Access Key ID and Secret Access Key (long-term credentials)
- No console login capability unless separately enabled
- Credentials are used in code, scripts, or command-line tools

**Use Cases:**
- Automated scripts running on local machines
- CI/CD pipelines deploying infrastructure
- Developers using AWS CLI for resource management
- Applications running outside AWS that need to access AWS services

### Best Practices for IAM Users

- **Create individual users** - Never share IAM user credentials among multiple people
- **Enable MFA** - Add an extra layer of security for console access
- **Use strong passwords** - Enforce password policies (minimum length, complexity, rotation)
- **Avoid embedding credentials** - Don't hardcode access keys in application code
- **Remove unnecessary credentials** - Delete access keys that aren't being used
- **Grant least privilege** - Only assign permissions users actually need
- **Regular audits** - Review user permissions periodically

---

## IAM Groups

### What are IAM Groups?

IAM groups are collections of IAM users. Groups make it easier to manage permissions for multiple users at once, rather than attaching policies to individual users.

**Key Characteristics:**
- A group can contain multiple users
- A user can belong to multiple groups (up to 10)
- Groups cannot be nested (groups cannot contain other groups)
- Groups cannot be directly referenced in resource-based policies

### Why Use Groups?

**Benefits:**
- **Simplified permission management** - Assign permissions once to the group rather than to each user
- **Consistency** - Ensure all users in a role have the same permissions
- **Scalability** - Easy to onboard new team members by adding them to appropriate groups
- **Reduced errors** - Less chance of missing permissions or granting incorrect access

### How Permissions Are Assigned Through Groups

1. Create an IAM group (e.g., "Developers", "DBAdmins", "S3ReadOnly")
2. Attach IAM policies to the group
3. Add IAM users to the group
4. Users inherit all permissions from their groups

**Example:**
```
Group: Developers
├── Policy: AmazonEC2FullAccess
├── Policy: AmazonS3ReadOnlyAccess
└── Users: Alice, Bob, Charlie
```
All three users automatically get EC2 full access and S3 read-only access.

### Example Use Cases

**Development Team:**
- Group: `Dev-Team`
- Permissions: EC2, S3, RDS read/write for development environment
- Members: Junior developers, senior developers

**Database Administrators:**
- Group: `DBA-Team`
- Permissions: Full access to RDS, DynamoDB, access to backup tools
- Members: Database administrators

**Finance Team:**
- Group: `Finance-Team`
- Permissions: Billing and Cost Explorer read access, no infrastructure access
- Members: Financial analysts, controllers

**Support Team:**
- Group: `Support-Team`
- Permissions: Read-only access to CloudWatch logs, EC2 instance details
- Members: Technical support staff

---

## IAM Policies

### What is an IAM Policy?

An IAM policy is a JSON document that defines permissions. It specifies:
- **What** actions are allowed or denied
- **Which** resources those actions apply to
- **Under what conditions** the permissions apply

Policies are attached to users, groups, or roles to grant permissions.

### Policy Structure

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "203.0.113.0/24"
        }
      }
    }
  ]
}
```

**Components:**

- **Version** - Policy language version (always use "2012-10-17")
- **Statement** - Array of individual permission statements
- **Effect** - Either "Allow" or "Deny"
- **Action** - The AWS service actions that are allowed or denied (e.g., `s3:GetObject`, `ec2:StartInstances`)
- **Resource** - The specific AWS resources the actions apply to (ARN format)
- **Condition** (optional) - Circumstances under which the policy grants permission

### Types of IAM Policies

#### 1. AWS Managed Policies

**What they are:**
- Pre-built policies created and maintained by AWS
- Updated automatically by AWS when new services or features are released
- Cannot be modified by users

**Characteristics:**
- Identified by an AWS icon in the console
- Cover common use cases
- Broad permissions for job functions

**Examples:**
- `AmazonS3ReadOnlyAccess` - Read-only access to S3
- `PowerUserAccess` - Full access except IAM and Organizations
- `AdministratorAccess` - Full access to all AWS services
- `ViewOnlyAccess` - Read-only access across AWS services

**When to use:**
- Quick setup for common scenarios
- Standard job functions (admin, developer, billing)
- Prototyping and testing environments
- When you want AWS to handle policy updates

#### 2. Customer Managed Policies

**What they are:**
- Custom policies you create and manage yourself
- Can be edited, versioned, and reused across users, groups, and roles
- Stored in your AWS account

**Characteristics:**
- Full control over permissions
- Can be more granular than AWS managed policies
- Support for versioning (up to 5 versions)
- Can be attached to multiple identities

**Example:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::company-documents"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::company-documents/team-folder/*"
    }
  ]
}
```

**When to use:**
- Specific organizational requirements
- Least privilege access policies
- Compliance requirements
- Custom permission combinations not available in AWS managed policies
- When you need fine-grained control over specific resources

#### 3. Inline Policies

**What they are:**
- Policies embedded directly into a single user, group, or role
- Have a strict one-to-one relationship with the identity
- Deleted automatically when the identity is deleted

**Characteristics:**
- Not reusable
- Not visible in the policies list
- Limited to specific identity
- Harder to manage at scale

**Example scenario:**
A one-time exception where a specific user needs temporary access to a particular S3 bucket that no one else should access.

**When to use:**
- One-off, exceptional permissions
- When you want to ensure a permission is never accidentally applied to other identities
- Temporary exceptions that should be deleted with the user
- Strict one-to-one permission relationships

**When NOT to use:**
- For common permissions that might be needed by multiple identities
- For permissions you want to audit centrally
- In most production scenarios

### Policy Type Comparison

| Feature | AWS Managed | Customer Managed | Inline |
|---------|-------------|------------------|--------|
| Created by | AWS | You | You |
| Reusable | Yes | Yes | No |
| Editable | No | Yes | Yes |
| Versioning | AWS maintains | You maintain (5 versions) | No |
| Best for | Common scenarios | Custom requirements | One-off exceptions |

### Principle of Least Privilege

**Definition:** Grant only the permissions required to perform a task, nothing more.

**Implementation:**
1. Start with no permissions
2. Add permissions as needed based on job requirements
3. Review and remove unused permissions regularly
4. Use specific resources instead of wildcards when possible
5. Implement conditions to further restrict access

**Example - BAD (Too permissive):**
```json
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": "*"
}
```

**Example - GOOD (Least privilege):**
```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:PutObject"
  ],
  "Resource": "arn:aws:s3:::specific-bucket/specific-folder/*"
}
```

---

## IAM Roles

### What is an IAM Role?

An IAM role is an identity with specific permissions, but unlike users, roles are not associated with a specific person. Instead, they are **assumed** by entities that need temporary access to AWS resources.

**Key Differences from IAM Users:**
- No permanent credentials (no password or access keys)
- Provides temporary security credentials
- Can be assumed by AWS services, applications, or users
- Credentials automatically rotate

### How Roles Work

#### 1. Trust Relationship (Trust Policy)
Defines **who** can assume the role.

**Example - EC2 service can assume this role:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

#### 2. Permission Policy
Defines **what** the role can do after being assumed.

**Example - Role can read from S3:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-data-bucket",
        "arn:aws:s3:::my-data-bucket/*"
      ]
    }
  ]
}
```

#### 3. Temporary Credentials
When a role is assumed:
- AWS Security Token Service (STS) generates temporary credentials
- Credentials include: Access Key ID, Secret Access Key, Session Token
- Credentials expire after a defined period (default: 1 hour, max: 12 hours)
- New credentials must be obtained to continue access

### Common AWS Services That Use Roles

#### EC2 Instances
**Scenario:** EC2 instance needs to access S3 buckets

**How it works:**
1. Create a role with S3 permissions
2. Attach the role to the EC2 instance (via instance profile)
3. Applications on the instance automatically use the role's credentials
4. No need to store access keys on the instance

**Benefits:**
- No hardcoded credentials in the application
- Automatic credential rotation
- Easy to modify permissions without changing application code

#### Lambda Functions
**Scenario:** Lambda function needs to write logs to CloudWatch and read from DynamoDB

**How it works:**
1. Create an execution role with CloudWatch Logs and DynamoDB permissions
2. Assign the role to the Lambda function
3. Lambda automatically assumes the role when invoked

**Typical permissions:**
- CloudWatch Logs (write)
- DynamoDB (read/write)
- S3 (depending on function requirements)

#### ECS Tasks
**Scenario:** Containerized application needs AWS service access

**How it works:**
1. Create a task execution role (for ECS to pull images, send logs)
2. Create a task role (for application to access AWS services)
3. Assign roles in the task definition

**Use cases:**
- Task execution role: Pull Docker images from ECR, send logs to CloudWatch
- Task role: Application accesses S3, RDS, or other services

#### Cross-Account Access
**Scenario:** Users in Account A need to access resources in Account B

**How it works:**
1. Account B creates a role with trust relationship to Account A
2. Account B grants necessary permissions to the role
3. Users in Account A assume the role to access Account B resources

**Benefits:**
- No need to create duplicate users in multiple accounts
- Centralized user management
- Temporary access with automatic expiration

### Example Role Use Cases

**Application Role for EC2:**
```
Role Name: App-Server-Role
Trust Policy: EC2 service
Permissions: Read from specific S3 bucket, write to CloudWatch Logs
Attached to: Production web servers
```

**Lambda Execution Role:**
```
Role Name: Lambda-DynamoDB-Processor
Trust Policy: Lambda service
Permissions: Read/write DynamoDB table, write CloudWatch Logs
Attached to: Data processing Lambda function
```

**Cross-Account Access:**
```
Role Name: External-Auditor-Role
Trust Policy: External AWS account
Permissions: Read-only access to CloudTrail, Config, billing data
Used by: Third-party security auditors
```

**DevOps Deployment Role:**
```
Role Name: CI-CD-Deployment-Role
Trust Policy: CodeBuild, CodeDeploy services
Permissions: Deploy to EC2, update ECS services, access ECR
Used by: CI/CD pipeline
```

---

## When to Use Roles vs Programmatic Access

### Understanding the Options

#### Option 1: IAM User with Programmatic Access (Access Keys)
- Long-term credentials (Access Key ID + Secret Access Key)
- Must be manually rotated
- Stored in configuration files or environment variables
- Risk of exposure if not managed properly

#### Option 2: IAM Role
- Temporary credentials (automatically rotated)
- No long-term secrets to manage
- Assumed by services or identities
- More secure by design

### When to Use IAM Roles

**Use roles when:**

1. **AWS services need to access other AWS services**
   - EC2 accessing S3
   - Lambda accessing DynamoDB
   - ECS tasks accessing Secrets Manager
   - **Why:** More secure, no credential management needed

2. **Applications running on AWS compute**
   - Applications on EC2 instances
   - Lambda functions
   - ECS/EKS containers
   - **Why:** Credentials automatically provided and rotated

3. **Cross-account access is required**
   - Accessing resources in another AWS account
   - Granting third-party access to your account
   - **Why:** Simplifies multi-account management

4. **Federated users need temporary access**
   - Single Sign-On (SSO) integration
   - Active Directory users
   - Web identity federation (Google, Facebook login)
   - **Why:** Users don't need separate AWS credentials

5. **Time-limited access is needed**
   - Temporary contractor access
   - Emergency break-glass scenarios
   - **Why:** Credentials expire automatically

### When to Use Programmatic Access (Access Keys)

**Use access keys when:**

1. **Applications run outside AWS**
   - On-premises servers
   - Local development machines
   - Third-party SaaS platforms
   - **Why:** No way to assume a role without initial credentials

2. **Legacy systems that can't assume roles**
   - Older applications without AWS SDK support
   - Systems that require static credentials
   - **Why:** Technical limitations

3. **CI/CD systems outside AWS**
   - GitHub Actions
   - Jenkins (not running on AWS)
   - GitLab CI (self-hosted)
   - **Why:** These systems need credentials to authenticate
   - **Better option:** Use OIDC federation where possible to avoid long-term keys

4. **Personal development and testing**
   - AWS CLI on local machine
   - Local development with AWS SDKs
   - **Why:** Convenient for individual developers
   - **Caution:** Should still rotate regularly

### Security Benefits of Roles

1. **Automatic credential rotation**
   - Temporary credentials expire (typically 1 hour)
   - New credentials generated each time role is assumed
   - No manual rotation required

2. **No credential storage**
   - No access keys stored on disk
   - Reduced risk of credential leakage
   - Nothing to accidentally commit to Git

3. **Easier to audit**
   - CloudTrail logs show who assumed which role
   - Clearer audit trail than access key usage
   - Better visibility into permissions used

4. **Simpler to revoke**
   - Modify or delete the role
   - All active sessions eventually expire
   - No need to track down and delete access keys

5. **Principle of least privilege**
   - Easier to grant temporary, specific permissions
   - Can require MFA for sensitive roles
   - Conditions can enforce time-of-day restrictions

### Real-World Scenario Comparisons

#### Scenario 1: Web Application on EC2

**❌ Poor Approach - IAM User with Programmatic Access:**
```
1. Create IAM user "WebAppUser"
2. Generate access keys
3. Store keys in /etc/app/config.ini on EC2 instance
4. Application reads keys and uses them to access S3

Problems:
- Keys stored in plaintext on server
- Keys don't rotate automatically
- If instance is compromised, keys are exposed
- Need to update config file to rotate keys
- Hard to track which instance uses which keys
```

**✅ Best Approach - IAM Role:**
```
1. Create IAM role "WebApp-S3-Access-Role"
2. Attach S3 permissions to role
3. Attach role to EC2 instance
4. Application uses AWS SDK which automatically retrieves credentials

Benefits:
- No credentials stored on instance
- Credentials rotate automatically every hour
- Easy to modify permissions by updating role
- Clear audit trail in CloudTrail
- If instance is compromised, credentials expire quickly
```

#### Scenario 2: Lambda Function Processing S3 Events

**❌ Poor Approach - Hardcoded Access Keys:**
```python
import boto3

# Don't do this!
s3 = boto3.client(
    's3',
    aws_access_key_id='AKIAIOSFODNN7EXAMPLE',
    aws_secret_access_key='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
)

Problems:
- Credentials in source code
- May be committed to version control
- Shared across all environments
- Difficult to rotate
```

**✅ Best Approach - Execution Role:**
```python
import boto3

# Lambda automatically uses execution role credentials
s3 = boto3.client('s3')

Benefits:
- No credentials in code
- Different roles for dev/staging/prod
- Permissions managed via IAM console
- Automatic credential rotation
```

#### Scenario 3: CI/CD Pipeline Deployment

**❌ Acceptable but Riskier - Access Keys:**
```
GitHub Actions (not hosted on AWS)
- Store AWS access keys in GitHub Secrets
- Pipeline uses keys to deploy to AWS
- Must rotate keys manually every 90 days

Risks:
- Long-lived credentials
- Shared across all workflows
- Manual rotation required
- If GitHub is compromised, keys may be exposed
```

**✅ Better Approach - OIDC with Role Assumption:**
```
GitHub Actions using OIDC Federation
- GitHub authenticates to AWS via OIDC
- Assumes deployment role temporarily
- No long-term credentials stored

Benefits:
- No access keys to manage
- Temporary credentials only
- Fine-grained role per repository
- Automatic expiration
```

#### Scenario 4: On-Premises Application

**✅ Necessary - IAM User with Access Keys:**
```
Application running in own data center
- Create dedicated IAM user "OnPrem-DataSync-User"
- Generate access keys
- Store keys in secure credential manager (HashiCorp Vault, AWS Secrets Manager)
- Application syncs data to S3

Why this is acceptable:
- Application can't assume role (not running on AWS)
- Keys stored securely, not in code
- Regular rotation scheduled
- Limited permissions (only S3 access)
- Better than no access at all

Best practices:
- Use a credential management system
- Rotate keys every 90 days
- Monitor key usage with CloudTrail
- Consider AWS Storage Gateway or DataSync as managed alternatives
```

### Decision Tree

```
Does your application run on AWS (EC2, Lambda, ECS)?
├─ YES → Use IAM Role
└─ NO → Is it a third-party service with OIDC/SAML support?
    ├─ YES → Use IAM Role with federation
    └─ NO → Use IAM User with Access Keys
        └─ IMPORTANT: Store keys securely, rotate regularly, audit usage
```

---

## Best Practices

### 1. Avoid Using the Root User

**What is the root user?**
- The email and password used to create the AWS account
- Has unrestricted access to all resources in the account
- Cannot have its permissions restricted

**Why avoid it?**
- Compromised root credentials = complete account takeover
- No way to limit what root can do
- Difficult to audit and track root usage
- No way to grant partial access

**What to do instead:**
1. Secure the root user with a strong password
2. Enable MFA on the root account
3. Create individual IAM users for day-to-day tasks
4. Only use root user for specific tasks that require it (billing, account closure, etc.)
5. Don't create access keys for the root user

**Root user use cases (rare):**
- Changing account settings
- Closing the AWS account
- Restoring IAM user permissions if locked out
- Signing up for GovCloud
- Changing AWS support plan

### 2. Enable Multi-Factor Authentication (MFA)

**What is MFA?**
- An additional authentication factor beyond password
- Requires something you know (password) + something you have (MFA device)

**Where to enable MFA:**
- Root user (mandatory)
- IAM users with console access (highly recommended)
- IAM users with privileged permissions (mandatory)
- Enforce via IAM policies for sensitive operations

**MFA options:**
- Virtual MFA device (Google Authenticator, Authy, Microsoft Authenticator)
- Hardware MFA device (YubiKey, Gemalto token)
- SMS text messages (least secure, not recommended)

**Example policy requiring MFA:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
```

### 3. Rotate Access Keys Regularly

**Why rotate?**
- Limits the damage if keys are compromised
- Reduces the window of exposure
- Compliance requirement for many standards

**Rotation schedule:**
- Minimum: Every 90 days
- Recommended: Every 30-60 days
- High security environments: Every 7-30 days

**Rotation process:**
1. Create a second access key (each user can have 2 keys)
2. Update applications to use the new key
3. Test thoroughly
4. Deactivate the old key (don't delete yet)
5. Monitor for errors over 24-48 hours
6. Delete the old key

**Monitoring key age:**
- Use IAM credential report to check key age
- Set up CloudWatch alarms for keys older than threshold
- Use AWS Config rules to flag non-compliant keys

**Automate rotation:**
- Use AWS Secrets Manager for automatic rotation
- Build CI/CD pipeline to rotate keys
- Implement scripts to rotate keys in credential stores

### 4. Implement Role-Based Access Control (RBAC)

**What is RBAC?**
- Assign permissions based on job function, not individual users
- Use groups and roles to manage permissions at scale

**Implementation strategy:**

**Step 1: Define roles/job functions**
```
Examples:
- Administrator
- Developer
- Database Administrator
- Read-Only Auditor
- Billing Manager
- Security Auditor
```

**Step 2: Create groups for each role**
```
Group: Developers
├── Users: Alice, Bob, Charlie
└── Policies:
    ├── EC2 Developer Access
    ├── S3 Development Buckets
    └── CloudWatch Logs Read

Group: DBAs
├── Users: David, Emma
└── Policies:
    ├── RDS Full Access
    ├── DynamoDB Full Access
    └── Backup Read Access
```

**Step 3: Assign users to groups, not individual policies**
- New developer joins → add to "Developers" group
- Developer promoted to DBA → move to "DBAs" group
- Employee leaves → remove from all groups or delete user

**Step 4: Use roles for services**
```
Role: Production-WebServer-Role
├── Trusted entity: EC2 service
└── Permissions:
    ├── Read from configuration S3 bucket
    ├── Write to application logs S3 bucket
    └── Send metrics to CloudWatch
```

**Benefits:**
- Consistent permissions across users with same job function
- Easy to onboard/offboard users
- Clear separation of duties
- Simpler to audit and maintain
- Scales with organization growth

### Additional Best Practices

**5. Use AWS Organizations for Multi-Account Strategy**
- Separate accounts for dev, staging, production
- Centralized billing and management
- Service Control Policies (SCPs) for account-level guardrails

**6. Monitor and Audit IAM Activity**
- Enable CloudTrail for all regions
- Review IAM credential reports regularly
- Use AWS Access Analyzer to identify overly permissive policies
- Set up alerts for unusual IAM activity

**7. Apply the Principle of Least Privilege**
- Start with minimum permissions
- Add permissions as needed
- Remove unused permissions
- Use IAM Access Advisor to see which permissions are actually used

**8. Use Policy Conditions for Additional Security**
- Require specific IP addresses
- Enforce time-of-day restrictions
- Require encrypted connections (SSL/TLS)
- Require specific MFA

**9. Document IAM Policies and Roles**
- Use descriptive names
- Add tags for organization
- Maintain documentation of what each policy/role is for
- Track policy changes in version control

**10. Regular Security Reviews**
- Quarterly access reviews
- Remove inactive users and unused access keys
- Review and update policies
- Validate MFA compliance
- Check for overly permissive policies

---

## Quick Reference Summary

### When to Use What

| Scenario | Use |
|----------|-----|
| Person needs AWS Console access | IAM User with password |
| Person needs CLI/API access from local machine | IAM User with access keys |
| EC2 instance needs to access S3 | IAM Role attached to instance |
| Lambda function needs permissions | IAM Role (execution role) |
| Multiple users with same job function | IAM Group with policies |
| Application on AWS needs AWS service access | IAM Role |
| Application outside AWS needs access | IAM User with access keys (or federated role) |
| Cross-account access | IAM Role with cross-account trust |
| Third-party needs temporary access | IAM Role with external ID |

### Policy Types Quick Guide

| Type | Created By | Reusable | Best For |
|------|-----------|----------|----------|
| AWS Managed | AWS | Yes | Common scenarios, quick setup |
| Customer Managed | You | Yes | Custom requirements, least privilege |
| Inline | You | No | One-off exceptions only |

### Security Checklist

- [ ] Root user has MFA enabled
- [ ] Root user has no access keys
- [ ] All IAM users have individual accounts
- [ ] Console users have MFA enabled
- [ ] Access keys rotated within 90 days
- [ ] No access keys for EC2/Lambda (use roles instead)
- [ ] Users assigned to groups, not individual policies
- [ ] Policies follow least privilege principle
- [ ] CloudTrail enabled for IAM audit
- [ ] Regular access reviews scheduled
- [ ] Unused users and access keys removed

---

## Common Interview Questions

**Q: What's the difference between an IAM user and an IAM role?**
- User has permanent credentials; role has temporary credentials
- Users represent people/applications; roles are assumed by entities
- Roles can be assumed by services, users, or other accounts

**Q: Why use roles instead of access keys for EC2 instances?**
- Automatic credential rotation
- No credential storage on instance
- Better security (credentials expire quickly if compromised)
- Easier to manage permissions

**Q: What's the principle of least privilege?**
- Grant only the minimum permissions necessary to perform a task
- Reduces blast radius if credentials are compromised
- Implement by starting with no permissions and adding as needed

**Q: When would you use an inline policy?**
- Rarely; only for strict one-to-one permission relationships
- When you want to ensure a permission is never accidentally applied elsewhere
- For one-off exceptions that should be deleted with the identity

**Q: How do you secure the AWS root account?**
- Strong password
- Enable MFA
- Don't create access keys
- Don't use for day-to-day tasks
- Only use for specific account management tasks

---

*End of IAM Study Notes*
