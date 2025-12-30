# Day 5: Purchasing Options, Tenancies, Placement Groups, and Instance Types

## Purchasing Options in AWS

AWS offers multiple purchasing options for EC2 instances, allowing you to optimize costs based on your workload requirements and usage patterns.

### 1. On-Demand Instances

**Definition**: Pay for compute capacity by the hour or second with no long-term commitments or upfront payments.

#### Characteristics:

- **Billing**: Pay per second (minimum 60 seconds) or per hour
- **No Commitment**: No upfront payment or long-term commitment
- **Flexibility**: Can be started or stopped at any time
- **Pricing**: Highest per-hour cost but no upfront costs
- **Availability**: Available immediately when needed

#### Use Cases:

- **Short-term, unpredictable workloads**: Applications with unpredictable usage patterns
- **Testing and development**: Development and testing environments
- **Applications that cannot be interrupted**: Critical applications requiring full control
- **First-time users**: Trying out AWS services
- **Spike workloads**: Sudden traffic spikes

#### Advantages:

- **No upfront costs**: Pay only for what you use
- **No long-term commitment**: Cancel anytime
- **Full control**: Complete control over instance lifecycle
- **Flexibility**: Change instance types easily

#### Disadvantages:

- **Higher cost**: Most expensive option per hour
- **No discounts**: No volume or commitment discounts
- **Capacity not guaranteed**: May not be available during high demand

#### Pricing Example:

- t3.micro: ~$0.0104/hour
- m5.large: ~$0.096/hour
- c5.xlarge: ~$0.17/hour

---

### 2. Reserved Instances (RI)

**Definition**: Purchase capacity reservation for a 1-year or 3-year term, providing significant discounts compared to On-Demand pricing.

#### Characteristics:

- **Commitment**: 1-year or 3-year term commitment
- **Discount**: Up to 72% discount compared to On-Demand
- **Payment Options**: All Upfront, Partial Upfront, or No Upfront
- **Flexibility**: Can be modified or exchanged (Standard RIs)
- **Capacity Reservation**: Guaranteed capacity in specific AZ

#### Types of Reserved Instances:

##### **Standard Reserved Instances**

- **Discount**: Up to 72% off On-Demand
- **Modifiable**: Can modify Availability Zone, instance size, networking type
- **Exchangeable**: Can exchange for different instance types
- **Sellable**: Can be sold on Reserved Instance Marketplace (3-year term)
- **Best For**: Steady-state applications with predictable usage

##### **Convertible Reserved Instances**

- **Discount**: Up to 54% off On-Demand
- **Flexible**: Can change instance family, OS, tenancy, payment option
- **Exchangeable**: Can exchange for different configurations
- **Best For**: Applications with evolving requirements

##### **Scheduled Reserved Instances**

- **Discount**: Up to 70% off On-Demand
- **Time-based**: Reserve capacity for specific time windows
- **Recurring**: Can schedule recurring reservations
- **Best For**: Applications that run on a schedule (e.g., batch processing)

#### Payment Options:

1. **All Upfront**: Pay entire amount upfront (highest discount)
2. **Partial Upfront**: Pay part upfront, rest monthly (medium discount)
3. **No Upfront**: Pay monthly (lowest discount, no upfront cost)

#### Use Cases:

- **Steady-state applications**: Applications with consistent usage
- **Predictable workloads**: Known capacity requirements
- **Cost optimization**: Long-term cost savings
- **Capacity planning**: Guaranteed capacity in specific AZ

#### Advantages:

- **Significant savings**: Up to 72% discount
- **Capacity guarantee**: Reserved capacity in specific AZ
- **Flexibility**: Can modify or exchange (depending on type)
- **Predictable costs**: Known monthly costs

#### Disadvantages:

- **Upfront commitment**: Long-term commitment required
- **Less flexibility**: Cannot easily change if requirements change
- **AZ-specific**: Standard RIs are tied to specific AZ

---

### 3. Spot Instances

**Definition**: Purchase unused EC2 capacity at up to 90% discount, but instances can be interrupted when AWS needs the capacity back.

#### Characteristics:

- **Discount**: Up to 90% off On-Demand pricing
- **Interruptible**: Can be terminated by AWS with 2-minute notice
- **Bidding**: Set maximum price you're willing to pay
- **Availability**: Depends on spare capacity
- **No guarantee**: No guarantee of availability or duration

#### How Spot Instances Work:

1. **Set Maximum Price**: Specify maximum price per hour
2. **Request Instances**: Request Spot instances
3. **Launch When Available**: Instances launch when Spot price ≤ your max price
4. **Run Until Interrupted**: Run until AWS needs capacity or price exceeds your max
5. **2-Minute Warning**: Receive interruption notice 2 minutes before termination

#### Spot Instance Interruption:

- **AWS Needs Capacity**: AWS reclaims capacity for On-Demand or Reserved Instances
- **Price Exceeds Max**: Spot price rises above your maximum price
- **Capacity Constraints**: Insufficient capacity in the AZ
- **2-Minute Notice**: Receive interruption notice via instance metadata or CloudWatch Events

#### Use Cases:

- **Fault-tolerant applications**: Applications that can handle interruptions
- **Batch processing**: Large-scale batch jobs
- **Data analysis**: Big data processing, analytics
- **CI/CD**: Continuous integration and deployment
- **Testing**: Development and testing workloads
- **Image rendering**: Video encoding, image processing

#### Advantages:

- **Extreme savings**: Up to 90% discount
- **High performance**: Same performance as On-Demand
- **Scalability**: Can scale to thousands of instances
- **Flexibility**: Can use different instance types

#### Disadvantages:

- **Interruptions**: Can be terminated at any time
- **No guarantee**: No SLA or availability guarantee
- **Complexity**: Requires fault-tolerant architecture
- **Unpredictable**: Availability depends on spare capacity

#### Best Practices:

- **Fault-tolerant design**: Design applications to handle interruptions
- **Diversify**: Use multiple instance types and AZs
- **Checkpointing**: Save work frequently
- **Spot Fleets**: Use Spot Fleets for better availability

---

### 4. Dedicated Hosts

**Definition**: Physical EC2 server dedicated for your use, providing additional visibility and control over the underlying server.

#### Characteristics:

- **Physical Server**: Entire physical server dedicated to you
- **Visibility**: Visibility into sockets, cores, and hyperthreads
- **Control**: Control over instance placement
- **Compliance**: Meet compliance and regulatory requirements
- **Licensing**: Use existing server-bound software licenses

#### Use Cases:

- **Compliance requirements**: Regulatory or compliance requirements
- **Software licensing**: Server-bound software licenses (Windows Server, SQL Server)
- **Visibility**: Need visibility into physical server attributes
- **Multi-tenancy**: Strict isolation requirements

#### Advantages:

- **Compliance**: Meet regulatory requirements
- **License optimization**: Use existing licenses efficiently
- **Visibility**: Full visibility into physical server
- **Control**: Complete control over instance placement

#### Disadvantages:

- **Higher cost**: More expensive than other options
- **Less flexibility**: Less flexible than virtualized instances
- **Maintenance**: Responsible for host maintenance

---

### 5. Dedicated Instances

**Definition**: Instances that run on hardware dedicated to a single customer, but you don't have visibility or control over the physical server.

#### Characteristics:

- **Dedicated Hardware**: Run on single-tenant hardware
- **No Visibility**: No visibility into physical server
- **Isolation**: Isolated from other customers
- **Compliance**: Meet compliance requirements
- **No Control**: No control over instance placement

#### Use Cases:

- **Compliance**: Regulatory compliance requirements
- **Isolation**: Need for strict isolation
- **Security**: Enhanced security requirements

#### Advantages:

- **Isolation**: Complete isolation from other customers
- **Compliance**: Meet compliance requirements
- **Security**: Enhanced security

#### Disadvantages:

- **Higher cost**: Additional per-hour charge
- **No visibility**: No visibility into physical server
- **Less control**: Less control than Dedicated Hosts

---

### 6. Savings Plans

**Definition**: Flexible pricing model that provides savings up to 72% in exchange for a commitment to a consistent amount of compute usage (measured in $/hour) for a 1-year or 3-year term.

#### Types of Savings Plans:

##### **Compute Savings Plans**

- **Flexibility**: Most flexible option
- **Coverage**: Applies to EC2, Lambda, Fargate usage
- **Instance Flexibility**: Can change instance families, sizes, regions, OS
- **Discount**: Up to 66% savings
- **Best For**: Diverse workloads across multiple services

##### **EC2 Instance Savings Plans**

- **EC2 Specific**: Applies only to EC2 usage
- **Flexibility**: Can change instance families, sizes, regions, OS, tenancy
- **Discount**: Up to 72% savings
- **Best For**: EC2-focused workloads

#### Characteristics:

- **Commitment**: 1-year or 3-year commitment
- **Usage Commitment**: Commit to $/hour of compute usage
- **Flexibility**: Can change instance types, families, regions
- **Automatic Application**: Automatically applies to matching usage
- **Payment Options**: All Upfront, Partial Upfront, No Upfront

#### Use Cases:

- **Diverse workloads**: Multiple instance types and families
- **Flexibility needed**: Need to change instance configurations
- **Cost optimization**: Long-term cost savings with flexibility

#### Advantages:

- **Significant savings**: Up to 72% discount
- **Flexibility**: Can change instance types and families
- **Automatic**: Automatically applies to matching usage
- **Multi-service**: Compute Savings Plans cover multiple services

#### Disadvantages:

- **Commitment**: Long-term commitment required
- **Complexity**: More complex than Reserved Instances
- **Usage tracking**: Need to track usage to optimize

---

## Tenancies in AWS

**Tenancy** refers to how EC2 instances are placed on physical hardware and whether they share hardware with other customers.

### 1. Shared Tenancy (Default)

**Definition**: Your instances run on shared hardware with other AWS customers. This is the default tenancy option.

#### Characteristics:

- **Shared Hardware**: Multiple customers share the same physical server
- **Cost**: No additional charges
- **Isolation**: Virtual isolation at hypervisor level
- **Default**: Default option for all instance types
- **Security**: AWS manages security and isolation

#### How It Works:

- Multiple customers' instances run on the same physical server
- Hypervisor provides isolation between instances
- AWS manages the underlying hardware
- No visibility into other customers' instances

#### Use Cases:

- **General workloads**: Most common use case
- **Cost-sensitive**: When cost is a primary concern
- **Standard security**: Standard security requirements
- **Development/Testing**: Development and testing environments

#### Advantages:

- **Lowest cost**: No additional charges
- **Flexibility**: Can use any instance type
- **Managed**: AWS manages underlying hardware
- **Scalability**: Easy to scale up or down

#### Disadvantages:

- **Shared resources**: Share physical resources with others
- **No control**: No control over physical server
- **Compliance**: May not meet strict compliance requirements

---

### 2. Dedicated Instances

**Definition**: Instances that run on single-tenant hardware dedicated to your AWS account, but you don't have visibility or control over the physical server.

#### Characteristics:

- **Dedicated Hardware**: Physical server dedicated to your account
- **No Visibility**: No visibility into physical server attributes
- **Isolation**: Complete isolation from other customers
- **Additional Cost**: Additional per-hour charge
- **Compliance**: Meet compliance and regulatory requirements

#### How It Works:

- Instances run on hardware dedicated to your AWS account
- No other customers' instances on the same hardware
- AWS manages the physical server
- You don't see physical server details

#### Use Cases:

- **Compliance**: Regulatory compliance requirements
- **Security**: Enhanced security requirements
- **Isolation**: Need for strict isolation
- **Corporate policies**: Corporate policies requiring dedicated hardware

#### Advantages:

- **Isolation**: Complete isolation from other customers
- **Compliance**: Meet compliance requirements
- **Security**: Enhanced security
- **No visibility needed**: Don't need physical server visibility

#### Disadvantages:

- **Additional cost**: Additional per-hour charge (~$2/hour)
- **No visibility**: No visibility into physical server
- **Less control**: Less control than Dedicated Hosts

#### Pricing:

- Additional charge on top of instance cost
- Varies by instance type and region
- Example: ~$2.00/hour for m5.large

---

### 3. Dedicated Hosts

**Definition**: Physical EC2 server dedicated for your use, providing additional visibility and control over the underlying server, including the number of sockets and physical cores.

#### Characteristics:

- **Physical Server**: Entire physical server dedicated to you
- **Visibility**: Full visibility into sockets, cores, hyperthreads
- **Control**: Control over instance placement
- **Licensing**: Use existing server-bound software licenses
- **Compliance**: Meet compliance and regulatory requirements

#### How It Works:

- You get an entire physical server
- Full visibility into physical attributes
- Control which instances run on which hosts
- Can use existing software licenses
- Pay for the host, not individual instances

#### Use Cases:

- **Software licensing**: Server-bound software licenses (Windows Server, SQL Server)
- **Compliance**: Regulatory compliance requiring physical server visibility
- **Control**: Need control over instance placement
- **License optimization**: Optimize software license usage

#### Advantages:

- **License optimization**: Use existing licenses efficiently
- **Full visibility**: See physical server attributes
- **Control**: Control instance placement
- **Compliance**: Meet strict compliance requirements

#### Disadvantages:

- **Higher cost**: More expensive than other options
- **Less flexibility**: Less flexible than virtualized instances
- **Maintenance**: Responsible for host maintenance
- **Complexity**: More complex to manage

#### Pricing:

- Pay per host per hour
- Varies by instance family and region
- Example: ~$3.00-5.00/hour for a host

---

### Tenancy Comparison Table

| Feature | Shared | Dedicated Instances | Dedicated Hosts |
|---------|--------|---------------------|-----------------|
| **Hardware** | Shared | Dedicated | Dedicated |
| **Visibility** | No | No | Yes (sockets, cores) |
| **Control** | No | No | Yes (placement) |
| **Isolation** | Virtual | Physical | Physical |
| **Cost** | No extra | Additional charge | Pay per host |
| **Licensing** | AWS managed | AWS managed | Your licenses |
| **Compliance** | Standard | Enhanced | Full control |
| **Use Case** | General | Compliance | Licensing/Compliance |

---

## Placement Groups in AWS

**Placement Groups** are logical groupings of instances within a single Availability Zone that influence how instances are placed on underlying hardware.

### Purpose:

- **Control Placement**: Control how instances are placed on hardware
- **Optimize Performance**: Optimize for low latency or high throughput
- **Network Performance**: Improve network performance between instances
- **Availability**: Balance between performance and availability

### Types of Placement Groups:

#### 1. Cluster Placement Group

**Definition**: Groups instances into a single Availability Zone, placing them close together on the same underlying hardware to achieve the lowest latency and highest network performance.

#### Characteristics:

- **Low Latency**: Lowest network latency between instances
- **High Throughput**: Highest network throughput (up to 10 Gbps)
- **Single AZ**: All instances in one Availability Zone
- **Close Placement**: Instances placed on same hardware
- **Risk**: Single point of failure if hardware fails

#### Use Cases:

- **High-Performance Computing (HPC)**: Applications requiring low latency
- **Big Data**: Big data processing requiring high throughput
- **Real-time Applications**: Real-time applications with strict latency requirements
- **Clustered Applications**: Applications that benefit from being close together

#### Advantages:

- **Lowest Latency**: Lowest network latency
- **Highest Throughput**: Up to 10 Gbps network throughput
- **Performance**: Best performance for clustered workloads

#### Disadvantages:

- **Single AZ**: All instances in one AZ (availability risk)
- **Hardware Failure**: Risk if underlying hardware fails
- **Limited Size**: Limited to one AZ
- **Instance Types**: Some instance types not supported

#### Best Practices:

- **Fault Tolerance**: Design for hardware failures
- **Backup**: Implement backup and recovery strategies
- **Monitoring**: Monitor instance health
- **Diversify**: Use multiple placement groups for critical workloads

---

#### 2. Partition Placement Group

**Definition**: Spreads instances across logical partitions, ensuring that instances in one partition do not share underlying hardware with instances in another partition.

#### Characteristics:

- **Partitions**: Instances organized into logical partitions
- **Hardware Isolation**: Partitions on different hardware
- **Multiple AZs**: Can span multiple Availability Zones
- **Fault Isolation**: Fault in one partition doesn't affect others
- **Scalability**: Can have up to 7 partitions per AZ

#### Use Cases:

- **Large Distributed Systems**: Large-scale distributed applications
- **Hadoop/Spark**: Big data frameworks (Hadoop, Spark)
- **Fault Isolation**: Applications requiring fault isolation
- **Multi-Tenant**: Multi-tenant applications

#### Advantages:

- **Fault Isolation**: Faults isolated to partitions
- **Scalability**: Can scale to large numbers of instances
- **Multi-AZ**: Can span multiple AZs
- **Reliability**: Better reliability than cluster placement

#### Disadvantages:

- **Higher Latency**: Higher latency than cluster placement
- **Complexity**: More complex to manage
- **Partition Management**: Need to manage partitions

#### Partition Structure:

- Up to 7 partitions per Availability Zone
- Each partition can have multiple instances
- Partitions isolated from each other
- Instances within partition share hardware

---

#### 3. Spread Placement Group

**Definition**: Places instances on distinct underlying hardware to reduce the risk of simultaneous failures.

#### Characteristics:

- **Hardware Isolation**: Each instance on different hardware
- **Maximum Availability**: Maximum availability and fault tolerance
- **Single AZ**: All instances in one Availability Zone
- **Limited Instances**: Maximum 7 instances per AZ
- **Risk Reduction**: Reduces risk of simultaneous failures

#### Use Cases:

- **Critical Applications**: Applications requiring maximum availability
- **Small Clusters**: Small clusters that need fault isolation
- **High Availability**: High availability requirements
- **Risk Reduction**: Reduce risk of simultaneous failures

#### Advantages:

- **Maximum Availability**: Best availability option
- **Fault Isolation**: Each instance isolated
- **Risk Reduction**: Minimal risk of simultaneous failures

#### Disadvantages:

- **Limited Instances**: Maximum 7 instances per AZ
- **Higher Latency**: Higher latency than cluster placement
- **Not Scalable**: Cannot scale beyond 7 instances per AZ

---

### Placement Group Comparison Table

| Feature | Cluster | Partition | Spread |
|---------|---------|-----------|--------|
| **Latency** | Lowest | Medium | Highest |
| **Throughput** | Highest (10 Gbps) | Medium | Lower |
| **Availability** | Single AZ | Multi-AZ | Single AZ |
| **Fault Isolation** | None | Per Partition | Per Instance |
| **Max Instances** | Many | Many | 7 per AZ |
| **Use Case** | HPC, Low Latency | Distributed Systems | Critical Apps |
| **Risk** | Hardware Failure | Partition Failure | Minimal |

---

### Placement Group Best Practices:

1. **Choose Wisely**: Select placement group type based on requirements
2. **Fault Tolerance**: Design for failures
3. **Monitoring**: Monitor instance health
4. **Testing**: Test placement group configurations
5. **Documentation**: Document placement group strategy

---

## Different Types of Instances in AWS

AWS offers a wide variety of EC2 instance types optimized for different use cases. Instances are categorized into families based on their capabilities.

### Instance Naming Convention:

**Format**: `<family>.<generation>.<size>`

**Example**: `m5.xlarge`
- `m` = Instance family (General Purpose)
- `5` = Generation (5th generation)
- `xlarge` = Size (4 vCPUs, 16 GiB RAM)

### Instance Sizes:

| Size | vCPUs | RAM (GiB) | Use Case |
|------|-------|-----------|----------|
| **nano** | 1 | 0.5 | Lightweight workloads |
| **micro** | 1 | 1 | Development, testing |
| **small** | 1 | 2 | Small applications |
| **medium** | 2 | 4 | Medium applications |
| **large** | 2 | 8 | Production workloads |
| **xlarge** | 4 | 16 | Large applications |
| **2xlarge** | 8 | 32 | High-performance apps |
| **4xlarge** | 16 | 64 | Very large applications |
| **8xlarge** | 32 | 128 | Extreme workloads |
| **12xlarge** | 48 | 192 | Massive workloads |
| **16xlarge** | 64 | 256 | Enterprise workloads |
| **24xlarge** | 96 | 384 | Extreme enterprise |
| **32xlarge** | 128 | 512 | Maximum performance |

---

## Instance Categories

### 1. General Purpose Instances

**Purpose**: Balanced compute, memory, and networking resources for a wide variety of workloads.

#### Instance Families:

##### **M5/M5a/M5d/M5n/M5dn**

- **M5**: Latest generation, Intel Xeon Platinum processors
- **M5a**: AMD EPYC processors (cost-effective)
- **M5d**: NVMe SSD instance store volumes
- **M5n**: Enhanced networking (25 Gbps)
- **M5dn**: Enhanced networking + NVMe SSD

**Use Cases:**
- Web servers
- Application servers
- Small to medium databases
- Development and testing
- Code repositories

**Characteristics:**
- Balanced CPU, memory, and network
- Good for most workloads
- Cost-effective
- Wide variety of sizes

##### **M6i/M6a/M6id**

- **M6i**: Latest generation, Intel processors
- **M6a**: AMD processors
- **M6id**: Intel + NVMe SSD

**Use Cases:**
- Same as M5 family
- Better performance than M5
- Latest generation features

##### **T3/T3a/T4g**

- **T3**: Burstable performance instances
- **T3a**: AMD-based burstable
- **T4g**: ARM-based (Graviton2)

**Use Cases:**
- Development and testing
- Low-traffic web servers
- Small applications
- Microservices

**Characteristics:**
- Burstable CPU performance
- Baseline performance with ability to burst
- Cost-effective for variable workloads
- Credits system for bursting

---

### 2. Compute Optimized Instances

**Purpose**: Ideal for compute-bound applications that benefit from high-performance processors.

#### Instance Families:

##### **C5/C5a/C5d/C5n/C5dn**

- **C5**: High-performance compute, Intel Xeon
- **C5a**: AMD EPYC processors
- **C5d**: NVMe SSD instance store
- **C5n**: Enhanced networking (100 Gbps)
- **C5dn**: Enhanced networking + NVMe SSD

**Use Cases:**
- High-performance web servers
- Batch processing
- Scientific modeling
- Ad serving
- Highly scalable multiplayer gaming
- Video encoding

**Characteristics:**
- Highest compute performance
- Optimized for CPU-intensive workloads
- High network performance
- Cost-effective for compute workloads

##### **C6i/C6a/C6id**

- **C6i**: Latest generation Intel
- **C6a**: Latest generation AMD
- **C6id**: Intel + NVMe SSD

**Use Cases:**
- Same as C5 family
- Better performance than C5
- Latest generation

---

### 3. Memory Optimized Instances

**Purpose**: Designed to deliver fast performance for workloads that process large datasets in memory.

#### Instance Families:

##### **R5/R5a/R5d/R5n/R5dn**

- **R5**: High memory, Intel Xeon
- **R5a**: AMD EPYC processors
- **R5d**: NVMe SSD instance store
- **R5n**: Enhanced networking (100 Gbps)
- **R5dn**: Enhanced networking + NVMe SSD

**Use Cases:**
- High-performance databases
- In-memory databases (Redis, Memcached)
- Real-time big data analytics
- High-performance computing
- Enterprise applications

**Characteristics:**
- High memory-to-vCPU ratio
- Fast memory performance
- Optimized for memory-intensive workloads
- Support for large datasets

##### **R6i/R6a/R6id**

- **R6i**: Latest generation Intel
- **R6a**: Latest generation AMD
- **R6id**: Intel + NVMe SSD

**Use Cases:**
- Same as R5 family
- Better performance than R5

##### **X1/X1e**

- **X1**: Very high memory (up to 3.9 TiB)
- **X1e**: Extreme memory (up to 3.9 TiB, higher memory-to-vCPU)

**Use Cases:**
- SAP HANA
- Large in-memory databases
- High-performance computing
- Memory-intensive applications

##### **High Memory (u-6tb1, u-9tb1, u-12tb1, u-18tb1, u-24tb1)**

- **u-6tb1**: 6 TiB memory
- **u-9tb1**: 9 TiB memory
- **u-12tb1**: 12 TiB memory
- **u-18tb1**: 18 TiB memory
- **u-24tb1**: 24 TiB memory

**Use Cases:**
- SAP HANA
- Very large in-memory databases
- High-performance computing
- Enterprise applications requiring massive memory

---

### 4. Storage Optimized Instances

**Purpose**: Designed for workloads that require high, sequential read and write access to large datasets on local storage.

#### Instance Families:

##### **I3/I3en**

- **I3**: High IOPS SSD instance store
- **I3en**: Enhanced networking + high IOPS SSD

**Use Cases:**
- NoSQL databases (Cassandra, MongoDB)
- Data warehousing
- OLTP systems
- High-frequency online transaction processing
- Elasticsearch

**Characteristics:**
- Very high IOPS (up to 3.3 million IOPS)
- NVMe SSD instance store
- High sequential and random I/O performance
- Optimized for storage-intensive workloads

##### **D2/D3/D3en**

- **D2**: Dense storage, HDD instance store
- **D3**: Latest generation dense storage
- **D3en**: Enhanced networking + dense storage

**Use Cases:**
- Data warehousing
- Hadoop/Spark clusters
- Log processing
- Large-scale distributed file systems
- Data processing

**Characteristics:**
- Very high storage capacity
- HDD instance store (cost-effective)
- High sequential read/write performance
- Optimized for large datasets

##### **Im4gn/Is4gen**

- **Im4gn**: Memory-optimized with NVMe SSD
- **Is4gen**: Storage-optimized with NVMe SSD

**Use Cases:**
- High-performance databases
- Data analytics
- Storage-intensive applications

---

### 5. Accelerated Computing Instances

**Purpose**: Use hardware accelerators, or co-processors, to perform functions more efficiently than is possible in software running on CPUs.

#### Instance Families:

##### **P3/P3dn**

- **P3**: NVIDIA V100 GPUs
- **P3dn**: Enhanced networking + NVIDIA V100 GPUs

**Use Cases:**
- Machine learning
- Deep learning
- High-performance computing
- Scientific computing
- Rendering
- Video encoding

**Characteristics:**
- NVIDIA V100 GPUs
- High GPU memory
- Optimized for parallel processing
- High network performance

##### **P4/P4d**

- **P4**: Latest generation, NVIDIA A100 GPUs
- **P4d**: Enhanced networking + NVIDIA A100 GPUs

**Use Cases:**
- Same as P3
- Better performance than P3
- Latest GPU technology

##### **G4/G4dn**

- **G4**: NVIDIA T4 GPUs
- **G4dn**: Enhanced networking + NVIDIA T4 GPUs

**Use Cases:**
- Machine learning inference
- Graphics-intensive applications
- Video transcoding
- Gaming applications

##### **Inf1**

- **Inf1**: AWS Inferentia chips

**Use Cases:**
- Machine learning inference
- Deep learning inference
- Cost-effective inference workloads

**Characteristics:**
- AWS-designed inference chips
- Cost-effective for inference
- High throughput for inference

##### **F1**

- **F1**: Xilinx Virtex UltraScale+ FPGAs

**Use Cases:**
- Custom hardware acceleration
- Genomics research
- Financial analytics
- Real-time video processing

**Characteristics:**
- Programmable hardware
- Custom acceleration
- High performance for specific workloads

---

### 6. HPC (High Performance Computing) Instances

**Purpose**: Optimized for high-performance computing workloads requiring low latency and high network performance.

#### Instance Families:

##### **Hpc6a/Hpc6id**

- **Hpc6a**: AMD processors, optimized for HPC
- **Hpc6id**: AMD + NVMe SSD

**Use Cases:**
- Scientific computing
- Weather modeling
- Financial modeling
- Engineering simulations
- High-performance computing clusters

**Characteristics:**
- Low latency networking
- High network throughput
- Optimized for HPC workloads
- Cluster placement group support

---

## Instance Type Selection Guide

### Choosing the Right Instance Type:

1. **Workload Analysis**: Analyze your workload requirements
2. **CPU Requirements**: Determine CPU needs
3. **Memory Requirements**: Determine memory needs
4. **Storage Requirements**: Determine storage needs
5. **Network Requirements**: Determine network needs
6. **Cost Optimization**: Balance performance and cost

### Decision Tree:

```
Start
  │
  ├─ Need GPU/FPGA? → Accelerated Computing (P3, G4, F1, Inf1)
  │
  ├─ Need High Memory? → Memory Optimized (R5, X1, High Memory)
  │
  ├─ Need High Storage IOPS? → Storage Optimized (I3, D3)
  │
  ├─ CPU Intensive? → Compute Optimized (C5, C6i)
  │
  └─ Balanced Workload? → General Purpose (M5, T3)
```

---

## Summary

### Purchasing Options:
- **On-Demand**: Pay-as-you-go, no commitment
- **Reserved Instances**: 1-3 year commitment, up to 72% savings
- **Spot Instances**: Up to 90% discount, interruptible
- **Dedicated Hosts**: Physical server, license optimization
- **Dedicated Instances**: Dedicated hardware, no visibility
- **Savings Plans**: Flexible commitment, up to 72% savings

### Tenancies:
- **Shared**: Default, shared hardware, lowest cost
- **Dedicated Instances**: Dedicated hardware, additional cost
- **Dedicated Hosts**: Physical server, full control, license optimization

### Placement Groups:
- **Cluster**: Lowest latency, highest throughput, single AZ
- **Partition**: Fault isolation, scalable, multi-AZ
- **Spread**: Maximum availability, 7 instances per AZ

### Instance Types:
- **General Purpose (M, T)**: Balanced workloads
- **Compute Optimized (C)**: CPU-intensive workloads
- **Memory Optimized (R, X, High Memory)**: Memory-intensive workloads
- **Storage Optimized (I, D)**: Storage-intensive workloads
- **Accelerated Computing (P, G, F, Inf)**: GPU/FPGA workloads
- **HPC**: High-performance computing

Understanding these concepts is essential for optimizing costs, performance, and availability in AWS EC2.

