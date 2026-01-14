# Day 6: AWS VPC Limitations

## Introduction to VPC Limitations

Understanding VPC limitations is crucial for:
- **Architecture Planning**: Design scalable and efficient networks
- **Cost Optimization**: Avoid unexpected costs from limitations
- **Troubleshooting**: Identify issues caused by limits
- **Interview Preparation**: Common AWS interview topics

**Note**: Most limits are soft limits and can be increased by contacting AWS Support.

---

## VPC Limits

### 1. Maximum VPCs Per Region

**What**:
- **Soft Limit**: Maximum 5 VPCs per region (default)
- **Hard Limit**: Can be increased up to 100+ VPCs per region by request
- Each VPC is region-specific

**Why**:
- Resource management
- Network complexity management
- Cost control
- Prevents accidental resource proliferation

**Soft Limit Details**:
- Default limit: 5 VPCs per region
- Applies to all AWS accounts by default
- Can be increased by contacting AWS Support

**Hard Limit Details**:
- Maximum achievable: 100+ VPCs per region (varies by account)
- Requires AWS Support approval
- Based on account history and use case
- May require business justification

**How to Request Increase**:
1. Contact AWS Support
2. Provide business justification
3. Specify required number of VPCs
4. Wait for approval (usually 24-48 hours)

**Important Notes**:
- VPCs are region-specific
- Each region has separate limits
- VPCs cannot span multiple regions
- Consider VPC design before requesting increases

### VPC Limits Summary Table

| Limitation | Soft Limit | Hard Limit | Can Increase |
|------------|------------|------------|-------------|
| **VPCs per Region** | 5 | 100+ | Yes (via AWS Support) |

---

## Subnets Limitations

### 1. Subnet Size Limitations

**What**: 
- Minimum subnet size: /28 (16 IP addresses)
- Maximum subnet size: /16 (65,536 IP addresses)
- AWS reserves 5 IP addresses per subnet

**Why**:
- AWS needs IPs for internal services (DNS, DHCP, etc.)
- Network routing efficiency
- Prevents IP address exhaustion

### Reserved IP Addresses in Subnets

AWS reserves 5 IP addresses in every subnet for internal services. These IPs cannot be assigned to your instances.

#### The 5 Reserved IP Addresses:

**1. Network Address (First IP)**
- **IP**: First IP in the subnet range
- **Use Case**: 
  - Network identifier (represents the network itself)
  - Used for network routing
  - Cannot be assigned to any host

**2. VPC Router (Second IP)**
- **IP**: Second IP in the subnet range
- **Use Case**:
  - VPC router for the subnet
  - Handles routing between subnets
  - Default gateway for instances
  - Used for inter-subnet communication

**3. DNS Server (Third IP)**
- **IP**: Third IP in the subnet range
- **Use Case**:
  - Amazon-provided DNS server
  - Resolves DNS queries within VPC
  - Also available at 169.254.169.253
  - Handles Route 53 private hosted zones

**4. Reserved for Future Use (Fourth IP)**
- **IP**: Fourth IP in the subnet range
- **Use Case**:
  - Reserved by AWS for future use
  - Currently not used
  - May be used for new AWS services

**5. Broadcast Address (Last IP)**
- **IP**: Last IP in the subnet range
- **Use Case**:
  - Network broadcast address
  - Used for network-wide broadcasts
  - Not used in modern TCP/IP (legacy)

#### Important Notes:

- **Cannot Assign**: You cannot assign these 5 IPs to your EC2 instances
- **Always Reserved**: Reserved in every subnet, regardless of size
- **Automatic**: AWS automatically reserves these IPs
- **Planning**: Always subtract 5 from total IPs when planning subnet capacity
- **Minimum Subnet**: /28 is minimum because smaller subnets wouldn't have enough usable IPs after reservation

### Subnets Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **Minimum Subnet Size** | /28 (16 IPs) | No |
| **Maximum Subnet Size** | /16 (65,536 IPs) | No |
| **Reserved IPs per Subnet** | 5 IPs | No |
| **Subnets per VPC** | 200 (soft) | Yes (to 250+) |
| **Subnet AZ Binding** | 1 AZ per subnet | No |
| **CIDR Overlap** | Not allowed | No |

---

### 2. Subnets Per VPC Limit

**What**:
- Maximum 200 subnets per VPC (soft limit)
- Can be increased to 250+ by request

**Why**:
- Route table management complexity
- Network performance optimization
- Resource management

---

### 3. Subnet Availability Zone Binding

**What**:
- Each subnet exists in exactly one Availability Zone
- Cannot span multiple AZs
- Cannot move subnet to different AZ

**Why**:
- Network isolation and fault tolerance
- AZ-level redundancy design
- Prevents cross-AZ network issues

---

### 4. CIDR Block Overlap Restriction

**What**:
- Subnet CIDR blocks cannot overlap within a VPC
- Cannot overlap with VPC CIDR
- Cannot overlap with other subnets

**Why**:
- Prevents routing conflicts
- Ensures unique IP addressing
- Network routing accuracy

---

## Route Tables Limitations

### 1. Route Tables Per VPC Limit

**What**:
- Maximum 200 route tables per VPC (soft limit)
- Can be increased by request

**Why**:
- Resource management
- Routing table lookup performance
- Network complexity management

---

### 2. Routes Per Route Table Limit

**What**:
- Maximum 50 routes per route table (soft limit)
- Can be increased to 100+ by request

**Why**:
- Routing table lookup performance
- Network efficiency
- Prevents routing table bloat

---

### Route Tables Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **Route Tables per VPC** | 200 (soft) | Yes |
| **Routes per Route Table** | 50 (soft) | Yes (to 100+) |

---

## Internet Gateway Limitations

### 1. Internet Gateway Per VPC Limit

**What**:
- Maximum 1 Internet Gateway per VPC
- Cannot attach multiple IGWs to one VPC

**Why**:
- Simplified routing
- Single point of internet access
- Network design simplicity

---

### 2. IGW Attachment Limitation

**What**:
- IGW can only be attached to one VPC at a time
- Cannot share IGW across VPCs

**Why**:
- VPC isolation
- Security boundaries
- Network segmentation

---

### 3. IPv6 Support Limitation

**What**:
- IGW supports both IPv4 and IPv6
- But IPv6 must be explicitly enabled
- Not all instance types support IPv6

**Why**:
- Backward compatibility
- Gradual IPv6 adoption
- Instance type limitations

### Internet Gateway Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **IGW per VPC** | 1 | No |
| **IGW Attachment** | 1 VPC per IGW | No |
| **IPv6 Support** | Must be enabled | N/A |

---

## NAT Gateway Limitations

### 1. NAT Gateway Per Availability Zone

**What**:
- One NAT Gateway per Availability Zone
- Cannot have multiple NAT Gateways in same AZ
- NAT Gateway is AZ-specific

**Why**:
- Network routing efficiency
- AZ-level redundancy design
- Prevents routing conflicts

---

### 2. NAT Gateway Bandwidth Limitation

**What**:
- Maximum 45 Gbps per NAT Gateway
- Burst up to 100 Gbps
- Shared bandwidth across all instances using it

**Why**:
- Network capacity management
- Cost optimization
- Performance guarantees

---

### 3. NAT Gateway Connection Limit

**What**:
- Maximum 55,000 concurrent connections per NAT Gateway
- TCP/UDP connections counted separately

**Why**:
- Resource management
- Connection state tracking
- Performance optimization

---

### 4. NAT Gateway Cost

**What**:
- Charges per hour (even when idle)
- Data processing charges
- No free tier

**Why**:
- Managed service costs
- High availability infrastructure
- AWS pricing model

### NAT Gateway Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **NAT Gateway per AZ** | 1 | No |
| **Bandwidth per NAT Gateway** | 45 Gbps (burst 100 Gbps) | No |
| **Concurrent Connections** | 55,000 | No |
| **Cost** | ~$32/month + data charges | N/A |

---

## Security Groups Limitations

### 1. Security Groups Per Instance Limit

**What**:
- Maximum 5 security groups per network interface
- Each instance can have multiple network interfaces
- Each ENI can have up to 5 security groups

**Why**:
- Rule evaluation performance
- Complexity management
- Network security efficiency

---

### 2. Rules Per Security Group Limit

**What**:
- Maximum 60 inbound rules per security group
- Maximum 60 outbound rules per security group
- Can be increased to 250 by request

**Why**:
- Rule evaluation performance
- Security group lookup efficiency
- Resource management

---

### 3. Security Groups Per VPC Limit

**What**:
- Maximum 2,500 security groups per VPC (soft limit)
- Can be increased to 5,000+ by request

**Why**:
- Resource management
- Network performance
- VPC complexity management

---

### 4. Security Group Rule Reference Limit

**What**:
- Security group can reference up to 1,000 other security groups
- Inbound/outbound rules combined

**Why**:
- Rule evaluation performance
- Network lookup efficiency
- Prevents circular references

---

### 5. Default Deny Behavior

**What**:
- All inbound traffic denied by default
- All outbound traffic allowed by default
- Stateful (return traffic automatically allowed)

**Why**:
- Security best practice
- Least privilege principle
- Network security

### Security Groups Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **Security Groups per ENI** | 5 | No |
| **Inbound Rules per SG** | 60 | Yes (to 250) |
| **Outbound Rules per SG** | 60 | Yes (to 250) |
| **Security Groups per VPC** | 2,500 (soft) | Yes (to 5,000+) |
| **SG Rule References** | 1,000 other SGs | No |
| **Default Behavior** | Inbound deny, Outbound allow | N/A |

---

## Network ACLs Limitations

### 1. Network ACLs Per VPC Limit

**What**:
- Maximum 200 network ACLs per VPC (soft limit)
- Can be increased by request

**Why**:
- Resource management
- Network complexity
- Performance optimization

---

### 2. Rules Per Network ACL Limit

**What**:
- Maximum 20 rules per Network ACL (inbound)
- Maximum 20 rules per Network ACL (outbound)
- Total: 40 rules per NACL
- Can be increased to 40 per direction (80 total) by request

**Why**:
- Rule evaluation performance
- Network efficiency
- Simplicity

---

### 3. Stateless Nature

**What**:
- Network ACLs are stateless
- Must allow both inbound and outbound traffic
- Return traffic not automatically allowed

**Why**:
- Different from security groups
- More granular control
- Explicit rule requirement

---

### 4. Rule Evaluation Order

**What**:
- Rules evaluated in numerical order (lowest to highest)
- First matching rule applies
- Default deny at end

**Why**:
- Predictable rule evaluation
- Explicit rule priority
- Network security

### Network ACLs Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **Network ACLs per VPC** | 200 (soft) | Yes |
| **Inbound Rules per NACL** | 20 | Yes (to 40) |
| **Outbound Rules per NACL** | 20 | Yes (to 40) |
| **Total Rules per NACL** | 40 | Yes (to 80) |
| **Stateless Nature** | Must allow both directions | No |
| **Rule Evaluation** | Numerical order | N/A |

---

## VPC Peering Limitations

### 1. VPC Peering Connections Per VPC

**What**:
- Maximum 125 active VPC peering connections per VPC (soft limit)
- Can be increased to 500+ by request

**Why**:
- Route table management
- Network complexity
- Performance optimization

---

### 2. Non-Transitive Peering

**What**:
- VPC peering is not transitive
- VPC A → VPC B → VPC C does NOT mean A can reach C
- Direct peering required for connectivity

**Why**:
- Security boundaries
- Explicit connectivity
- Network isolation

---

### 3. CIDR Block Overlap Restriction

**What**:
- Peered VPCs cannot have overlapping CIDR blocks
- Must have unique IP address ranges

**Why**:
- Routing conflicts
- Network ambiguity
- Prevents routing issues

---

### 4. Cross-Region Peering Limitations

**What**:
- Cross-region VPC peering supported
- Higher latency than same-region
- Additional data transfer costs

**Why**:
- Geographic distance
- Network infrastructure
- AWS pricing model

---

### VPC Peering Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **Peering Connections per VPC** | 125 (soft) | Yes (to 500+) |
| **Transitive Peering** | Not supported | No |
| **CIDR Overlap** | Not allowed | No |
| **Cross-Region Latency** | Higher than same-region | N/A |

---

## Elastic Load Balancer Limitations

### 1. Application Load Balancer (ALB) Limitations

#### ALB Per VPC Limit
**What**:
- Maximum 50 ALBs per region (soft limit)
- Can be increased to 100+ by request

**Why**:
- Resource management
- Network complexity
- Performance optimization

---

#### ALB Target Limit
**What**:
- Maximum 1,000 targets per ALB
- Can register multiple target groups

**Why**:
- Load balancer capacity
- Health check performance
- Resource management

---

#### ALB Listener Limit
**What**:
- Maximum 50 listeners per ALB
- Can be increased to 100+ by request

**Why**:
- Resource management
- Listener rule evaluation
- Performance optimization

---

### 2. Network Load Balancer (NLB) Limitations

#### NLB Per VPC Limit
**What**:
- Maximum 50 NLBs per region (soft limit)
- Can be increased by request

**Why**:
- Resource management
- Network complexity
- Performance optimization

---

#### NLB Target Limit
**What**:
- Maximum 500 targets per NLB
- Lower than ALB (500 vs 1,000)

**Why**:
- NLB architecture
- Network performance
- Resource management

---

#### NLB Static IP Limitation
**What**:
- NLB provides static IP per AZ
- But IP changes if NLB is recreated
- Cannot reserve specific IPs

**Why**:
- NLB architecture
- IP address management
- Network design

---

### 3. Classic Load Balancer Limitations

#### CLB Deprecation
**What**:
- Classic Load Balancer is legacy
- AWS recommends ALB or NLB
- Limited new features

**Why**:
- Modern load balancer options
- Better features and performance
- Migration path available

### Elastic Load Balancer Limitations Summary Table

| Load Balancer Type | Limitation | Limit | Can Increase |
|-------------------|------------|-------|-------------|
| **ALB** | ALBs per region | 50 (soft) | Yes (to 100+) |
| **ALB** | Targets per ALB | 1,000 | No |
| **ALB** | Listeners per ALB | 50 | Yes (to 100+) |
| **NLB** | NLBs per region | 50 (soft) | Yes |
| **NLB** | Targets per NLB | 500 | No |
| **NLB** | Static IP | Changes on recreation | No |
| **CLB** | Status | Legacy/Deprecated | N/A |

---

## EC2 Networking Limitations

### 1. Network Interfaces Per Instance

**What**:
- Varies by instance type
- Small instances: 2-4 ENIs
- Large instances: Up to 15 ENIs

**Why**:
- Instance type capabilities
- Network performance
- Resource allocation

---

### 2. IP Addresses Per ENI

**What**:
- Varies by instance type
- Small instances: 2-4 private IPs per ENI
- Large instances: Up to 50 private IPs per ENI

**Why**:
- Instance type capabilities
- Network addressing
- Resource allocation

---

### 3. Elastic IP Address Limit

**What**:
- Maximum 5 Elastic IPs per region (soft limit)
- Can be increased by request
- Charges apply if not attached to running instance

**Why**:
- IP address management
- Cost control
- Resource allocation

---

### 4. Instance Bandwidth Limitations

**What**:
- Bandwidth varies by instance type
- Small instances: 5 Gbps
- Large instances: Up to 100 Gbps

**Why**:
- Instance type capabilities
- Network performance
- Cost optimization

---

### 5. Enhanced Networking Requirements

**What**:
- Requires supported instance types
- Requires SR-IOV support
- Not available on all instance types

**Why**:
- Hardware requirements
- Network performance
- Instance type capabilities

### EC2 Networking Limitations Summary Table

| Limitation | Limit | Notes |
|------------|-------|-------|
| **ENIs per Instance** | 2-15 | Varies by instance type |
| **Private IPs per ENI** | 2-50 | Varies by instance type |
| **Elastic IPs per Region** | 5 (soft) | Can be increased |
| **Instance Bandwidth** | 5-100 Gbps | Varies by instance type |
| **Enhanced Networking** | Instance type dependent | Requires SR-IOV support |

---

## Auto Scaling in VPC Limitations

### 1. Auto Scaling Group Size

**What**:
- Maximum 10,000 instances per Auto Scaling Group
- Can be increased by request

**Why**:
- Resource management
- Scaling performance
- AWS infrastructure

---

### 2. Subnet Distribution

**What**:
- Auto Scaling Group can span multiple subnets
- But subnets must be in same VPC
- Instances distributed across subnets

**Why**:
- High availability
- AZ-level distribution
- VPC architecture

---

### 3. Launch Template Limitations

**What**:
- Launch template specifies VPC and subnets
- Cannot change VPC after creation
- Must recreate to change VPC

**Why**:
- Network architecture
- Security boundaries
- VPC isolation

### Auto Scaling in VPC Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **Instances per ASG** | 10,000 | Yes |
| **Subnet Distribution** | Must be in same VPC | No |
| **Launch Template VPC** | Cannot change after creation | No |

---

## RDS in VPC Limitations

### 1. RDS Subnet Group Requirements

**What**:
- RDS requires DB Subnet Group
- Must have subnets in at least 2 AZs
- Cannot use single subnet

**Why**:
- High availability
- Multi-AZ deployment
- Database redundancy

---

### 2. RDS Security Group Limits

**What**:
- RDS instance can have up to 5 security groups
- Same as EC2 limit
- Security groups control database access

**Why**:
- Network security
- Access control
- Resource management

---

### 3. RDS Public Access Limitation

**What**:
- RDS can be made publicly accessible
- But requires public subnet
- And security group allowing public access

**Why**:
- Security best practices
- Network isolation
- Access control

---

### 4. RDS VPC Peering Limitations

**What**:
- RDS can be accessed via VPC peering
- But requires proper route table configuration
- Security groups must allow peering traffic

**Why**:
- Network routing
- Security boundaries
- VPC isolation

### RDS in VPC Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **DB Subnet Group AZs** | Minimum 2 AZs | No |
| **Security Groups per RDS** | 5 | No |
| **Public Access** | Requires public subnet | N/A |
| **VPC Peering Access** | Requires route table config | N/A |

---

## Lambda with VPC Limitations

### 1. Lambda VPC Cold Start

**What**:
- Lambda in VPC has longer cold starts
- Additional 1-3 seconds for ENI attachment
- No cold start when not in VPC

**Why**:
- ENI creation and attachment
- VPC network setup
- Resource allocation

---

### 2. Lambda ENI Limit

**What**:
- Lambda creates ENIs for VPC connectivity
- Limited ENI capacity per AZ
- Can cause throttling

**Why**:
- ENI resource management
- VPC network capacity
- Resource allocation

---

### 3. Lambda VPC Timeout

**What**:
- Lambda in VPC has network timeout issues
- Must configure proper timeouts
- NAT Gateway timeout considerations

**Why**:
- Network routing complexity
- NAT Gateway timeouts
- VPC endpoint considerations

---

### 4. Lambda VPC Cost

**What**:
- Lambda in VPC incurs NAT Gateway costs
- Data processing charges
- VPC endpoint costs (if used)

**Why**:
- Network infrastructure costs
- Managed service pricing
- AWS pricing model

### Lambda with VPC Limitations Summary Table

| Limitation | Limit | Notes |
|------------|-------|-------|
| **VPC Cold Start** | +1-3 seconds | Additional ENI attachment time |
| **ENI Capacity** | Limited per AZ | Can cause throttling |
| **VPC Timeout** | Network timeout issues | Must configure properly |
| **VPC Cost** | NAT Gateway + data charges | ~$32/month + processing |

---

## ECS/EKS Networking Limitations

### 1. ECS Task Networking

**What**:
- ECS tasks can use awsvpc network mode
- Each task gets its own ENI
- Limited by ENI capacity

**Why**:
- Network isolation
- Security boundaries
- Resource management

---

### 2. EKS Pod Networking

**What**:
- EKS pods use VPC CNI
- Each pod gets IP from VPC subnet
- Limited by subnet IP capacity

**Why**:
- VPC-native networking
- IP address management
- Network architecture

---

### 3. EKS Service Limits

**What**:
- EKS services use LoadBalancer type
- Creates ALB or NLB
- Subject to load balancer limits

**Why**:
- Load balancer resource management
- Network capacity
- AWS service limits

### ECS/EKS Networking Limitations Summary Table

| Service | Limitation | Limit | Notes |
|---------|------------|-------|-------|
| **ECS** | ENIs per Instance | Varies | Limits task density in awsvpc mode |
| **EKS** | Pod IPs per Subnet | Subnet size - 5 | Can exhaust subnet IPs |
| **EKS** | Service Load Balancers | Subject to ALB/NLB limits | Multiple services = multiple LBs |

---

## PrivateLink Limitations

### 1. PrivateLink Endpoint Services

**What**:
- Maximum 50 endpoint services per account per region
- Can be increased by request

**Why**:
- Resource management
- Network complexity
- Performance optimization

---

### 2. PrivateLink Endpoints

**What**:
- Maximum 1,000 endpoints per VPC (soft limit)
- Can be increased by request

**Why**:
- Resource management
- Network complexity
- Performance optimization

---

### 3. PrivateLink Bandwidth

**What**:
- Bandwidth varies by endpoint type
- Interface endpoints: Up to 10 Gbps
- Gateway endpoints: Up to 25 Gbps

**Why**:
- Network architecture
- Service type capabilities
- Performance optimization

### PrivateLink Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **Endpoint Services per Account/Region** | 50 | Yes |
| **Endpoints per VPC** | 1,000 (soft) | Yes |
| **Interface Endpoint Bandwidth** | Up to 10 Gbps | No |
| **Gateway Endpoint Bandwidth** | Up to 25 Gbps | No |

---

## IPv4 & IPv6 Limitations

### 1. IPv4 Address Exhaustion

**What**:
- IPv4 addresses are limited
- AWS has limited IPv4 pool
- May require IPv6 adoption

**Why**:
- Global IPv4 exhaustion
- Limited address space
- IPv6 migration

---

### 2. IPv6 Support Limitations

**What**:
- Not all AWS services support IPv6
- Instance type support varies
- Must enable IPv6 on VPC and subnets

**Why**:
- Gradual IPv6 adoption
- Service development timeline
- Backward compatibility

---

### 3. IPv6 Subnet Size

**What**:
- IPv6 subnets are /64 (minimum)
- Much larger than IPv4 subnets
- Cannot use smaller subnets

**Why**:
- IPv6 addressing architecture
- Network requirements
- Protocol specifications

### IPv4 & IPv6 Limitations Summary Table

| Limitation | Limit | Notes |
|------------|-------|-------|
| **IPv4 Address Exhaustion** | Limited pool | May require IPv6 adoption |
| **IPv6 Service Support** | Varies by service | Not all services support IPv6 |
| **IPv6 Subnet Size** | Minimum /64 | Much larger than IPv4 subnets |
| **NAT Gateway IPv6** | Not supported | IPv4 only |

---

## DNS & DHCP Limitations

### 1. VPC DNS Limitations

**What**:
- VPC provides DNS at 169.254.169.253
- Plus 2 (base + 2)
- Limited DNS resolution

**Why**:
- VPC DNS architecture
- Network design
- AWS service integration

---

### 2. DHCP Options Set

**What**:
- Maximum 200 DHCP options sets per region
- One DHCP options set per VPC
- Cannot modify after creation

**Why**:
- Resource management
- Network configuration
- VPC architecture

---

### 3. DNS Resolution Limitations

**What**:
- VPC DNS resolves VPC resources
- Limited external DNS resolution
- May need Route 53

**Why**:
- VPC network scope
- DNS architecture
- Service integration

### DNS & DHCP Limitations Summary Table

| Limitation | Limit | Can Increase |
|------------|-------|-------------|
| **VPC DNS Servers** | 169.254.169.253 + VPC base + 2 | No |
| **DHCP Options Sets per Region** | 200 | No |
| **DHCP Options Set per VPC** | 1 | No |
| **DHCP Options Set Modification** | Cannot modify | Must recreate |
| **DNS Resolution Scope** | VPC resources | May need Route 53 for external |

---

## Summary of Key Limitations

### Most Common Limitations:

1. **Subnet Size**: Minimum /28, 5 reserved IPs
2. **Security Groups**: 5 per ENI, 60 rules per group
3. **Route Tables**: 50 routes per table
4. **VPC Peering**: Non-transitive, no CIDR overlap
5. **NAT Gateway**: 45 Gbps, AZ-specific
6. **Lambda VPC**: Cold start penalty, ENI limits
7. **IPv4 Exhaustion**: Limited IPv4 addresses
8. **Cost**: NAT Gateway, VPC Endpoints add costs

### Best Practices:

1. **Plan IP Addressing**: Plan CIDR blocks carefully
2. **Consolidate Rules**: Combine security group rules
3. **Use VPC Endpoints**: Avoid NAT Gateway costs where possible
4. **Consider IPv6**: Plan for IPv6 adoption
5. **Request Increases**: Contact AWS Support for limit increases
6. **Monitor Costs**: Track VPC-related costs
7. **Design for Scale**: Plan for growth and limits

Understanding these limitations helps design scalable, cost-effective, and efficient VPC architectures.

