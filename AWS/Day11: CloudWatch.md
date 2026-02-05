# Day 11: Amazon CloudWatch

## Introduction to CloudWatch

Understanding Amazon CloudWatch is essential for:
- **Monitoring and Observability**: Track performance, health, and availability of your AWS resources
- **Troubleshooting**: Identify and diagnose issues quickly with detailed metrics and logs
- **Cost Optimization**: Monitor resource utilization and optimize costs
- **Automation**: Trigger automated actions based on metrics and alarms
- **Interview Preparation**: Common AWS interview topics
- **Certification Exams**: Core topic in AWS certifications (Solutions Architect, SysOps, DevOps Engineer)
- **Real-world Applications**: Foundation for building production-ready, monitored applications

---

## 1. What is Amazon CloudWatch?

### Definition

**Amazon CloudWatch** is a monitoring and observability service provided by AWS that collects and tracks metrics, monitors log files, sets alarms, and automatically reacts to changes in your AWS resources. It provides a unified view of your AWS infrastructure, applications, and services, enabling you to monitor, troubleshoot, and optimize your systems.

### Simple Explanation

Think of CloudWatch as a health monitoring system for your AWS infrastructure, similar to a car's dashboard. Just like a car dashboard shows speed, fuel level, engine temperature, and warning lights, CloudWatch shows:
- **Metrics**: Performance data (CPU usage, memory, network traffic) - like speed and fuel gauges
- **Logs**: Detailed records of what's happening - like a car's event log
- **Alarms**: Warnings when something goes wrong - like warning lights on dashboard
- **Dashboards**: Visual displays of your metrics - like the dashboard itself

When your application's "engine temperature" (CPU) gets too high, CloudWatch's "warning light" (alarm) alerts you, and you can take action to prevent problems.

### Detailed Definition

CloudWatch is a fully managed monitoring and observability service that provides data and actionable insights for AWS resources, applications, and services. It collects monitoring and operational data in the form of logs, metrics, and events, giving you a unified view of your AWS resources and applications.

#### Key Components

**1. Metrics**
- Numerical data points representing the performance of your resources
- Collected automatically for AWS services (EC2, RDS, S3, etc.)
- Can be custom metrics sent from your applications
- Stored for 15 months (detailed monitoring) or 15 days (basic monitoring)
- Examples: CPU utilization, network in/out, disk read/write, request count

**2. Logs**
- Detailed records of events, errors, and activities
- Collected from EC2 instances, Lambda functions, and other AWS services
- Stored in log groups and log streams
- Can be searched, filtered, and analyzed
- Examples: Application logs, system logs, access logs, error logs

**3. Alarms**
- Automated notifications based on metric thresholds
- Can trigger actions (SNS notifications, Auto Scaling, EC2 actions)
- Monitors metrics continuously
- Sends notifications when conditions are met
- Examples: CPU > 80%, memory < 20%, error rate > 5%

**4. Dashboards**
- Visual displays of your metrics and logs
- Customizable widgets showing graphs, numbers, and text
- Real-time or historical data visualization
- Share dashboards with team members
- Examples: Application performance dashboard, infrastructure health dashboard

**5. Events (EventBridge)**
- Automated responses to changes in your AWS environment
- Event-driven architecture support
- Routes events to targets (Lambda, SNS, SQS, etc.)
- Examples: Instance state changes, API calls, scheduled events

### Key Characteristics

#### 1. **Comprehensive Monitoring**

**What It Does**:
- Monitors AWS services automatically (EC2, RDS, Lambda, etc.)
- Collects metrics every 1 minute (detailed) or 5 minutes (basic)
- Tracks performance, availability, and health
- Provides historical data for analysis

**Why It Matters**:
- Understand system behavior
- Identify performance bottlenecks
- Track resource utilization
- Make data-driven decisions

#### 2. **Custom Metrics and Logs**

**What It Does**:
- Accepts custom metrics from your applications
- Collects application and system logs from EC2 instances
- Supports any metric or log you want to track
- Flexible data collection

**Why It Matters**:
- Monitor application-specific metrics
- Track business KPIs
- Debug application issues
- Customize monitoring for your needs

#### 3. **Automated Alerts and Actions**

**What It Does**:
- Sets alarms based on metric thresholds
- Sends notifications via SNS, email, SMS
- Triggers automated actions (Auto Scaling, Lambda)
- Responds to issues automatically

**Why It Matters**:
- Proactive issue detection
- Reduces manual monitoring
- Faster incident response
- Automated remediation

#### 4. **Centralized Logging**

**What It Does**:
- Collects logs from multiple sources
- Centralizes log storage and analysis
- Provides log search and filtering
- Integrates with other AWS services

**Why It Matters**:
- Single source of truth for logs
- Easier troubleshooting
- Better security auditing
- Compliance requirements

#### 5. **Integration with AWS Services**

**What It Does**:
- Works seamlessly with all AWS services
- Integrates with Auto Scaling, Lambda, SNS
- Supports AWS-native monitoring
- Unified monitoring experience

**Why It Matters**:
- Consistent monitoring across services
- Easy to set up and use
- Leverages AWS ecosystem
- Reduces complexity

### CloudWatch Use Cases

#### 1. **EC2 Instance Monitoring**

**Scenario**: Monitor EC2 instances for performance and health

**How CloudWatch Helps**:
- Tracks CPU, memory, disk, network metrics
- Monitors instance status and health checks
- Sends alerts when instances have issues
- Helps optimize instance sizing

**Example**: Monitor CPU utilization of web servers. Set alarm when CPU > 80% to trigger Auto Scaling.

#### 2. **Application Performance Monitoring**

**Scenario**: Monitor application performance and errors

**How CloudWatch Helps**:
- Collects application logs
- Tracks custom application metrics
- Monitors response times and error rates
- Identifies performance bottlenecks

**Example**: Track API response times. Set alarm when response time > 1 second.

#### 3. **Cost Optimization**

**Scenario**: Monitor resource usage to optimize costs

**How CloudWatch Helps**:
- Tracks resource utilization
- Identifies underutilized resources
- Monitors cost-related metrics
- Provides data for right-sizing

**Example**: Monitor EC2 CPU utilization. Identify instances running at < 20% CPU for downsizing.

#### 4. **Automated Scaling**

**Scenario**: Automatically scale resources based on demand

**How CloudWatch Helps**:
- Provides metrics for Auto Scaling
- Triggers scaling actions via alarms
- Monitors scaling effectiveness
- Ensures optimal capacity

**Example**: Auto Scaling uses CloudWatch CPU metric to scale EC2 instances up or down.

#### 5. **Troubleshooting and Debugging**

**Scenario**: Debug issues in production environment

**How CloudWatch Helps**:
- Provides detailed logs
- Shows metric trends before issues
- Enables log search and filtering
- Historical data for analysis

**Example**: Application errors occur. Search CloudWatch Logs to find error patterns and root cause.

---

## 2. CloudWatch Components Explained

### Overview

CloudWatch consists of several key components that work together to provide comprehensive monitoring and observability. Understanding each component helps you use CloudWatch effectively.

### 2.1 Metrics

#### What are Metrics?

**Metrics** are numerical data points that represent the performance, health, or state of your AWS resources or applications. They are time-ordered sets of data points that are published to CloudWatch.

#### Simple Explanation

Think of metrics like a fitness tracker that records your heart rate, steps, and calories burned over time. CloudWatch metrics record things like CPU usage, memory consumption, and request counts over time. Each metric is a series of data points showing how something changes over time.

#### Key Characteristics

**1. Namespace**
- Logical container for metrics
- Groups related metrics together
- Examples: `AWS/EC2`, `AWS/RDS`, `Custom/MyApp`
- Helps organize and filter metrics

**2. Metric Name**
- Name of the specific metric
- Examples: `CPUUtilization`, `NetworkIn`, `MemoryUsage`
- Identifies what is being measured

**3. Dimensions**
- Key-value pairs that uniquely identify a metric
- Examples: `InstanceId=i-1234567890abcdef0`, `AutoScalingGroupName=web-servers`
- Allows filtering and aggregation
- Up to 10 dimensions per metric

**4. Timestamp**
- When the metric data point was collected
- Used for time-series analysis
- Enables historical comparisons

**5. Value**
- The actual measurement
- Can be a number, count, or percentage
- Examples: 75.5 (CPU %), 1024 (bytes), 150 (requests)

#### Types of Metrics

**1. AWS Service Metrics (Default Metrics)**
- Automatically collected by AWS services
- No additional setup required
- Examples:
  - **EC2**: `CPUUtilization`, `NetworkIn`, `NetworkOut`, `DiskReadOps`, `DiskWriteOps`
  - **RDS**: `CPUUtilization`, `DatabaseConnections`, `FreeableMemory`
  - **S3**: `BucketSizeBytes`, `NumberOfObjects`
  - **Lambda**: `Invocations`, `Duration`, `Errors`

**2. Custom Metrics**
- Metrics you send from your applications
- Application-specific measurements
- Examples:
  - `ActiveUsers`, `OrdersPerMinute`, `CacheHitRate`
  - `ResponseTime`, `ErrorCount`, `QueueDepth`
  - `MemoryUsage`, `DiskSpace`, `CustomBusinessMetric`

**3. High-Resolution Metrics**
- Metrics with 1-second granularity
- Standard metrics are 1-minute granularity
- Useful for real-time monitoring
- More expensive than standard metrics

#### Metric Statistics

CloudWatch provides several statistics for metrics:

**1. Average**
- Mean value of all data points
- Example: Average CPU utilization over 5 minutes

**2. Sum**
- Sum of all data points
- Example: Total bytes transferred

**3. Minimum**
- Lowest value in the period
- Example: Minimum free memory

**4. Maximum**
- Highest value in the period
- Example: Maximum CPU utilization

**5. SampleCount**
- Number of data points
- Example: Number of requests

**6. Percentiles (p50, p90, p95, p99)**
- Value below which a percentage of data points fall
- Example: p95 response time = 95% of requests are faster than this

#### Metric Retention

**Basic Monitoring (Free Tier)**:
- 5-minute granularity
- 15 days retention
- Free for AWS service metrics

**Detailed Monitoring (Paid)**:
- 1-minute granularity
- 15 days retention
- Additional cost per metric

**Extended Retention**:
- Can extend retention up to 15 months
- Additional cost for extended retention
- Useful for long-term analysis

### 2.2 Logs

#### What are Logs?

**Logs** are detailed records of events, activities, errors, and information generated by your applications, systems, and AWS services. CloudWatch Logs collects, stores, and analyzes these logs.

#### Simple Explanation

Think of logs like a detailed diary or journal. Every time something happens in your application (a user logs in, an error occurs, a request is processed), it writes an entry in the log. CloudWatch Logs is like a library that stores all these diaries, lets you search through them, and alerts you when important things happen.

#### Key Concepts

**1. Log Groups**
- Container for log streams
- Groups related log streams together
- Examples: `/aws/ec2/web-servers`, `/aws/lambda/my-function`
- Defines retention policy and access permissions

**2. Log Streams**
- Sequence of log events from a single source
- Examples: One log stream per EC2 instance, one per Lambda execution
- Automatically created when logs are sent
- Can have multiple streams per group

**3. Log Events**
- Individual log entries
- Contains timestamp, message, and optional metadata
- Examples: Error messages, access logs, application output

**4. Log Retention**
- How long logs are stored
- Options: 1 day to Never expire
- Default: Never expire (you pay for storage)
- Can set retention per log group

#### Types of Logs

**1. System Logs**
- Operating system logs
- Examples: `/var/log/syslog`, `/var/log/messages`
- System-level events and errors

**2. Application Logs**
- Application-generated logs
- Examples: Application errors, debug logs, info logs
- Business logic and application events

**3. Access Logs**
- Web server access logs
- Examples: Apache access logs, Nginx access logs
- HTTP requests and responses

**4. AWS Service Logs**
- Logs from AWS services
- Examples: VPC Flow Logs, Lambda execution logs, API Gateway logs
- Service-specific events

#### Log Collection Methods

**1. CloudWatch Agent**
- Installed on EC2 instances
- Collects logs from files
- Sends logs to CloudWatch Logs
- Most common method for EC2

**2. SDK/API**
- Applications send logs directly via API
- Programmatic log submission
- Real-time log streaming
- Good for serverless applications

**3. AWS Service Integration**
- Automatic log collection from AWS services
- Examples: Lambda, API Gateway, VPC Flow Logs
- No agent required

### 2.3 Alarms

#### What are Alarms?

**Alarms** are automated notifications that trigger when a metric crosses a threshold you define. They can send notifications, trigger actions, or both.

#### Simple Explanation

Think of alarms like a smoke detector. When smoke (metric value) reaches a dangerous level (threshold), the alarm sounds (notification) and can trigger the sprinkler system (automated action). CloudWatch alarms work the same way - they watch metrics and alert you or take action when something goes wrong.

#### Key Characteristics

**1. Metric**
- The metric to monitor
- Can be AWS service metric or custom metric
- Examples: `CPUUtilization`, `ErrorRate`, `MemoryUsage`

**2. Threshold**
- The value that triggers the alarm
- Can be greater than, less than, or equal to
- Examples: CPU > 80%, Memory < 20%, ErrorCount > 10

**3. Evaluation Period**
- How long the condition must be true
- Examples: 1 minute, 5 minutes, 15 minutes
- Prevents false alarms from temporary spikes

**4. Datapoints to Alarm**
- Number of data points that must breach threshold
- Examples: 2 out of 3, 3 out of 3
- Reduces false positives

**5. Actions**
- What happens when alarm triggers
- Examples: Send SNS notification, trigger Auto Scaling, stop EC2 instance
- Can have multiple actions

#### Alarm States

**1. OK**
- Metric is within normal range
- No action needed
- Alarm is not triggered

**2. ALARM**
- Metric has breached threshold
- Alarm condition is met
- Actions are triggered

**3. INSUFFICIENT_DATA**
- Not enough data to evaluate
- Metric not available or just started
- No action taken

#### Alarm Types

**1. Static Threshold Alarms**
- Fixed threshold value
- Example: CPU > 80%
- Simple and predictable
- Most common type

**2. Anomaly Detection Alarms**
- Uses machine learning to detect anomalies
- Learns normal behavior
- Alerts on unusual patterns
- Good for unpredictable metrics

**3. Composite Alarms**
- Combines multiple alarms
- Uses AND/OR logic
- Example: CPU > 80% AND Memory > 90%
- More sophisticated alerting

### 2.4 Dashboards

#### What are Dashboards?

**Dashboards** are customizable visual displays of your CloudWatch metrics and logs. They provide a unified view of your infrastructure and applications.

#### Simple Explanation

Think of dashboards like a control room with multiple screens showing different information. One screen shows CPU usage, another shows memory, another shows error rates. CloudWatch dashboards are like that - multiple widgets showing different metrics in one place, so you can see everything at a glance.

#### Key Features

**1. Widgets**
- Individual visualizations on dashboard
- Types: Line graphs, bar charts, numbers, text, logs
- Customizable size and position
- Multiple widgets per dashboard

**2. Real-Time Data**
- Shows current metric values
- Updates automatically
- Refresh intervals: 1 second to 1 hour

**3. Historical Data**
- Shows past metric values
- Time range selection
- Trend analysis
- Comparison views

**4. Customization**
- Arrange widgets as needed
- Choose metrics to display
- Set time ranges
- Add annotations

#### Dashboard Use Cases

**1. Application Performance Dashboard**
- Response times, error rates, throughput
- User-facing metrics
- Business KPIs

**2. Infrastructure Health Dashboard**
- CPU, memory, disk, network
- Resource utilization
- System health

**3. Cost Monitoring Dashboard**
- Resource costs
- Usage trends
- Cost optimization metrics

**4. Security Dashboard**
- Failed login attempts
- Unusual access patterns
- Security events

---

## 3. Default EC2 Metrics vs Custom Metrics

### Overview

Understanding the difference between default EC2 metrics and custom metrics is crucial for effective monitoring. Each serves different purposes and has different capabilities.

### 3.1 Default EC2 Metrics

#### What are Default Metrics?

**Default EC2 Metrics** are metrics that AWS automatically collects and publishes to CloudWatch for your EC2 instances. These metrics are available without any additional setup or agents.

#### Available Default Metrics

**1. CPUUtilization**
- Percentage of CPU capacity used
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Range: 0-100%
- Use case: Monitor CPU usage, trigger scaling

**2. NetworkIn**
- Bytes received on all network interfaces
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Bytes
- Use case: Monitor incoming traffic, bandwidth usage

**3. NetworkOut**
- Bytes sent on all network interfaces
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Bytes
- Use case: Monitor outgoing traffic, bandwidth usage

**4. NetworkPacketsIn**
- Number of packets received
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Count
- Use case: Monitor network packet volume

**5. NetworkPacketsOut**
- Number of packets sent
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Count
- Use case: Monitor network packet volume

**6. StatusCheckFailed**
- Whether instance passed status checks
- Granularity: 1 minute
- Values: 0 (passed) or 1 (failed)
- Use case: Monitor instance health

**7. StatusCheckFailed_Instance**
- Whether instance-level status check failed
- Granularity: 1 minute
- Values: 0 (passed) or 1 (failed)
- Use case: Detect instance-level issues

**8. StatusCheckFailed_System**
- Whether system-level status check failed
- Granularity: 1 minute
- Values: 0 (passed) or 1 (failed)
- Use case: Detect system-level issues

**9. DiskReadOps**
- Completed read operations from all disks
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Count
- Use case: Monitor disk I/O

**10. DiskWriteOps**
- Completed write operations to all disks
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Count
- Use case: Monitor disk I/O

**11. DiskReadBytes**
- Bytes read from all disks
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Bytes
- Use case: Monitor disk throughput

**12. DiskWriteBytes**
- Bytes written to all disks
- Granularity: 5 minutes (basic) or 1 minute (detailed)
- Unit: Bytes
- Use case: Monitor disk throughput

#### Limitations of Default Metrics

**1. No Memory Metrics**
- ❌ No RAM usage metrics
- ❌ No swap usage metrics
- ❌ No memory pressure indicators
- **Solution**: Use CloudWatch Agent for memory metrics

**2. No Disk Space Metrics**
- ❌ No disk space usage
- ❌ No disk space available
- ❌ No inode usage
- **Solution**: Use CloudWatch Agent for disk metrics

**3. No Process-Level Metrics**
- ❌ No per-process CPU or memory
- ❌ No application-specific metrics
- ❌ No custom business metrics
- **Solution**: Use CloudWatch Agent or custom metrics

**4. Limited Granularity (Basic Monitoring)**
- ❌ 5-minute granularity (basic monitoring)
- ❌ May miss short spikes
- **Solution**: Enable detailed monitoring (1-minute) or use CloudWatch Agent

**5. Only Instance-Level Metrics**
- ❌ No per-volume metrics (for EBS)
- ❌ No per-interface metrics
- **Solution**: Use CloudWatch Agent for detailed metrics

### 3.2 Custom Metrics

#### What are Custom Metrics?

**Custom Metrics** are metrics that you define and send to CloudWatch from your applications, scripts, or CloudWatch Agent. They allow you to monitor anything specific to your application or infrastructure.

#### Why Use Custom Metrics?

**1. Application-Specific Monitoring**
- Monitor business metrics (orders, users, revenue)
- Track application performance (response times, queue depth)
- Measure custom KPIs

**2. System-Level Metrics**
- Memory usage (not available in default metrics)
- Disk space usage (not available in default metrics)
- Process-level metrics
- Application-specific resource usage

**3. Better Granularity**
- 1-second granularity (high-resolution metrics)
- Real-time monitoring
- Capture short-lived spikes

**4. Business Intelligence**
- Track business metrics alongside technical metrics
- Correlate business and technical performance
- Data-driven decision making

#### Types of Custom Metrics

**1. System Metrics (via CloudWatch Agent)**
- Memory usage, disk space, swap usage
- Process-level CPU and memory
- Network interface statistics
- File system metrics

**2. Application Metrics**
- Response times, error rates, throughput
- Business metrics (orders, users, revenue)
- Queue depths, cache hit rates
- Custom performance indicators

**3. High-Resolution Metrics**
- 1-second granularity
- Real-time monitoring
- Useful for critical metrics

### 3.3 Comparison Table

| Feature | Default EC2 Metrics | Custom Metrics |
|---------|---------------------|----------------|
| **Setup Required** | None (automatic) | CloudWatch Agent or API calls |
| **Cost** | Free (basic) or paid (detailed) | Paid per metric |
| **Granularity** | 5 min (basic) or 1 min (detailed) | 1 min (standard) or 1 sec (high-res) |
| **Memory Metrics** | ❌ Not available | ✅ Available via agent |
| **Disk Space Metrics** | ❌ Not available | ✅ Available via agent |
| **CPU Metrics** | ✅ Available | ✅ Available (more detailed) |
| **Network Metrics** | ✅ Available | ✅ Available (more detailed) |
| **Application Metrics** | ❌ Not available | ✅ Available |
| **Business Metrics** | ❌ Not available | ✅ Available |
| **Retention** | 15 days (basic) or 15 months | 15 days (standard) or 15 months |
| **Use Case** | Basic monitoring, cost-effective | Detailed monitoring, custom needs |

### 3.4 When to Use Each

#### Use Default Metrics When:
- ✅ Basic monitoring is sufficient
- ✅ Cost is a primary concern
- ✅ CPU and network monitoring is enough
- ✅ You don't need memory or disk metrics
- ✅ 5-minute granularity is acceptable

**Example**: Development environment where you just need to know if instances are running and CPU usage.

#### Use Custom Metrics When:
- ✅ You need memory or disk space monitoring
- ✅ Application-specific metrics are required
- ✅ Business metrics need tracking
- ✅ Higher granularity is needed
- ✅ Detailed system monitoring is required

**Example**: Production application where you need to monitor memory usage, disk space, application response times, and business metrics like orders per minute.

#### Use Both Together:
- ✅ Default metrics for basic infrastructure monitoring
- ✅ Custom metrics for detailed application monitoring
- ✅ Comprehensive monitoring strategy
- ✅ Cost-effective (use defaults where possible, custom where needed)

**Example**: Production environment using default metrics for basic monitoring and custom metrics for application performance and business KPIs.

---

## 4. CloudWatch Agent Setup on EC2 (Linux)

### Overview

The CloudWatch Agent is a software package that you install on your EC2 instances to collect system-level metrics (memory, disk) and logs, and send them to CloudWatch. This section provides a complete step-by-step guide for setting up the CloudWatch Agent on Linux EC2 instances.

### 4.1 Prerequisites

#### 1. EC2 Instance Requirements
- Running Linux EC2 instance (Amazon Linux, Ubuntu, RHEL, etc.)
- SSH access to the instance
- Internet connectivity (or VPC endpoint for CloudWatch)
- Sufficient IAM permissions (covered in IAM section)

#### 2. IAM Role Requirements
- EC2 instance must have an IAM role attached
- IAM role must have CloudWatch permissions
- Detailed IAM policy in next section

#### 3. Network Requirements
- Outbound HTTPS (443) access to CloudWatch endpoints
- Or VPC endpoint for CloudWatch (for private subnets)

### 4.2 Step-by-Step Installation

#### Step 1: Attach IAM Role to EC2 Instance

**Option A: Attach Role to Existing Instance**

1. Go to EC2 Console → Instances
2. Select your instance
3. Click "Actions" → "Security" → "Modify IAM role"
4. Select IAM role with CloudWatch permissions
5. Click "Update IAM role"

**Option B: Create Instance with Role**

1. When launching instance, in "Configure Instance" step
2. Under "IAM role", select role with CloudWatch permissions
3. Continue with launch

**Note**: IAM role details provided in next section.

#### Step 2: Connect to EC2 Instance

```bash
# Connect via SSH
ssh -i your-key.pem ec2-user@your-instance-ip

# For Ubuntu, use 'ubuntu' instead of 'ec2-user'
ssh -i your-key.pem ubuntu@your-instance-ip
```

#### Step 3: Download CloudWatch Agent

**For Amazon Linux 2 / Amazon Linux 2023:**

```bash
# Download the agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

# Install the agent
sudo rpm -U ./amazon-cloudwatch-agent.rpm
```

**For Ubuntu / Debian:**

```bash
# Download the agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

# Install the agent
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
```

**For RHEL / CentOS:**

```bash
# Download the agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm

# Install the agent
sudo rpm -U ./amazon-cloudwatch-agent.rpm
```

#### Step 4: Verify Installation

```bash
# Check if agent is installed
which amazon-cloudwatch-agent-ctl

# Check agent version
amazon-cloudwatch-agent-ctl -v

# Expected output: version number like "1.300030.0"
```

#### Step 5: Create Agent Configuration File

The CloudWatch Agent uses a JSON configuration file to specify what metrics and logs to collect. We'll create this file.

**Create configuration directory:**

```bash
# Create config directory
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

# Create config file
sudo nano /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

**Basic configuration for metrics only:**

```json
{
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "*"
        ]
      },
      "diskio": {
        "measurement": [
          "io_time"
        ],
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_time_wait"
        ]
      },
      "processes": {
        "measurement": [
          "running",
          "sleeping",
          "dead"
        ]
      }
    }
  }
}
```

**Save the file** (Ctrl+O, Enter, Ctrl+X in nano)

#### Step 6: Start CloudWatch Agent

```bash
# Start the agent with configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

# Expected output:
# Successfully fetched the config and saved in /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
# Start configuration validation...
# Configuration validation first phase succeeded
# Configuration validation second phase succeeded
# Configuration validation third phase succeeded
# Start the agent...
# Successfully started the CloudWatch agent
```

#### Step 7: Verify Agent is Running

```bash
# Check agent status
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status

# Expected output:
# {
#   "status": "running",
#   "starttime": "2024-01-15T10:30:00Z",
#   "version": "1.300030.0"
# }
```

#### Step 8: Verify Metrics in CloudWatch

1. Go to CloudWatch Console → Metrics → All metrics
2. Look for namespace: `CWAgent`
3. You should see metrics like:
   - `CWAgent > cpu_usage_idle`
   - `CWAgent > mem_used_percent`
   - `CWAgent > disk_used_percent`

### 4.3 Advanced Configuration

#### Configuration with Logs

**Full configuration file (metrics + logs):**

```json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "resources": [
          "*"
        ]
      },
      "diskio": {
        "measurement": [
          "io_time"
        ],
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_available_percent"
        ]
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_time_wait"
        ]
      },
      "processes": {
        "measurement": [
          "running",
          "sleeping",
          "dead"
        ]
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/aws/ec2/system",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/secure",
            "log_group_name": "/aws/ec2/secure",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/myapp/application.log",
            "log_group_name": "/aws/ec2/myapp",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
```

#### Configuration Parameters Explained

**Agent Settings:**
- `metrics_collection_interval`: How often to collect metrics (seconds)
- `run_as_user`: User to run agent as (default: cwagent)

**Metrics Settings:**
- `namespace`: Namespace for metrics (appears in CloudWatch)
- `metrics_collected`: Which metrics to collect
  - `cpu`: CPU metrics
  - `disk`: Disk space metrics
  - `diskio`: Disk I/O metrics
  - `mem`: Memory metrics
  - `netstat`: Network statistics
  - `processes`: Process statistics

**Logs Settings:**
- `logs_collected`: Which log files to collect
  - `file_path`: Path to log file on instance
  - `log_group_name`: CloudWatch Logs group name
  - `log_stream_name`: Log stream name (can use {instance_id})
  - `timezone`: Timezone for log timestamps

### 4.4 Managing the Agent

#### Start Agent

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m ec2
```

#### Stop Agent

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a stop -m ec2
```


#### Reload Configuration

```bash
# Update configuration file, then reload
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s
```

#### Check Agent Status

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

#### View Agent Logs

```bash
# Agent logs location
sudo tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```

### 4.5 Troubleshooting

#### Agent Not Starting

**Check IAM permissions:**
```bash
# Test IAM role permissions
aws cloudwatch put-metric-data \
  --namespace TestNamespace \
  --metric-name TestMetric \
  --value 1 \
  --region us-east-1
```

**Check agent logs:**
```bash
sudo cat /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```

**Verify configuration:**
```bash
# Validate configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s
```

#### Metrics Not Appearing in CloudWatch

**Wait for metrics:**
- Metrics appear within 1-2 minutes after agent starts
- Check namespace: `CWAgent` (or your custom namespace)

**Verify agent is running:**
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

**Check network connectivity:**
```bash
# Test CloudWatch endpoint
curl -I https://monitoring.us-east-1.amazonaws.com
```

#### Logs Not Appearing

**Check log file permissions:**
```bash
# Ensure agent can read log files
sudo ls -la /var/log/myapp/application.log
```

**Note – Fixing permissions for `/var/log/nginx/access.log`:**

The CloudWatch agent runs as the `cwagent` user. If collecting nginx access logs, the agent may not have read access. Add `cwagent` to the `adm` group so it can read system logs (including nginx logs that are typically readable by adm):

```bash
usermod -aG adm cwagent
```

Then restart the CloudWatch agent for the change to take effect.

**Check log group exists:**
```bash
# List log groups
aws logs describe-log-groups --region us-east-1
```

**Verify log file path:**
```bash
# Ensure file path in config matches actual file
ls -la /var/log/myapp/application.log
```

---

## 5. IAM Role Requirements and Policies

### Overview

The CloudWatch Agent requires specific IAM permissions to send metrics and logs to CloudWatch. This section explains the IAM role requirements, provides policy examples, and explains each permission.

### 5.1 IAM Role Setup

#### Step 1: Create IAM Role

1. Go to IAM Console → Roles → Create role
2. Select "AWS service" → "EC2"
3. Click "Next"
4. Attach policies (see next section)
5. Name the role: `CloudWatchAgentServerRole`
6. Create role

#### Step 2: Attach Role to EC2 Instance

1. Go to EC2 Console → Instances
2. Select instance
3. Actions → Security → Modify IAM role
4. Select the role
5. Update IAM role

### 5.2 Required IAM Policies

#### Policy 1: CloudWatchAgentServerPolicy (AWS Managed Policy)

AWS provides a managed policy that includes all necessary permissions:

**Policy Name**: `CloudWatchAgentServerPolicy`

**Attach this policy:**
1. IAM Console → Roles → Your role
2. Click "Add permissions" → "Attach policies"
3. Search for `CloudWatchAgentServerPolicy`
4. Select and attach

**What this policy includes:**
- `cloudwatch:PutMetricData` - Send metrics to CloudWatch
- `logs:CreateLogGroup` - Create log groups
- `logs:CreateLogStream` - Create log streams
- `logs:PutLogEvents` - Send log events
- `logs:DescribeLogStreams` - Describe log streams
- `ssm:GetParameter` - Get SSM parameters (for agent configuration)
- `ssm:PutParameter` - Put SSM parameters (for agent configuration)

#### Policy 2: Custom Policy (If Needed)

If you need more control or additional permissions, create a custom policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    }
  ]
}
```

### 5.3 Permission Explanations

#### CloudWatch Permissions

**1. cloudwatch:PutMetricData**
- **Purpose**: Send custom metrics to CloudWatch
- **Required for**: All metric collection (default and custom)
- **Scope**: Can be restricted to specific namespaces or allowed for all

**2. cloudwatch:GetMetricStatistics**
- **Purpose**: Retrieve metric statistics (optional, for agent validation)
- **Required for**: Agent self-validation
- **Scope**: Usually allowed for all metrics

**3. cloudwatch:ListMetrics**
- **Purpose**: List available metrics (optional)
- **Required for**: Agent discovery and validation
- **Scope**: Usually allowed for all metrics

#### CloudWatch Logs Permissions

**1. logs:CreateLogGroup**
- **Purpose**: Create new log groups in CloudWatch Logs
- **Required for**: First time sending logs to a new log group
- **Scope**: Can be restricted to specific log group ARNs or allowed for all

**2. logs:CreateLogStream**
- **Purpose**: Create new log streams within log groups
- **Required for**: Creating log streams for each instance
- **Scope**: Usually allowed for all log streams

**3. logs:PutLogEvents**
- **Purpose**: Send log events to CloudWatch Logs
- **Required for**: All log collection
- **Scope**: Can be restricted to specific log groups/streams or allowed for all

**4. logs:DescribeLogStreams**
- **Purpose**: List and describe log streams
- **Required for**: Agent to find existing log streams
- **Scope**: Usually allowed for all log streams

**5. logs:DescribeLogGroups**
- **Purpose**: List and describe log groups
- **Required for**: Agent to find existing log groups
- **Scope**: Usually allowed for all log groups

#### EC2 Permissions

**1. ec2:DescribeTags**
- **Purpose**: Read EC2 instance tags
- **Required for**: Agent to use instance tags in metric dimensions
- **Scope**: Usually allowed for all instances

#### Systems Manager (SSM) Permissions

**1. ssm:GetParameter**
- **Purpose**: Retrieve agent configuration from SSM Parameter Store
- **Required for**: Using SSM for agent configuration (optional method)
- **Scope**: Usually restricted to CloudWatch-related parameters

**2. ssm:PutParameter**
- **Purpose**: Store agent configuration in SSM Parameter Store
- **Required for**: Storing configuration in SSM (optional method)
- **Scope**: Usually restricted to CloudWatch-related parameters

### 5.4 Scoped Policies (Best Practice)

For production environments, use scoped policies that restrict permissions to specific resources:

#### Scoped Policy Example

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "cloudwatch:namespace": [
            "CWAgent",
            "MyApp/CustomMetrics"
          ]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:123456789012:log-group:/aws/ec2/myapp:*",
        "arn:aws:logs:us-east-1:123456789012:log-group:/aws/ec2/system:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
```

**Benefits of Scoped Policies:**
- ✅ Follows principle of least privilege
- ✅ Reduces risk of accidental data in wrong namespace
- ✅ Better security posture
- ✅ Easier to audit

### 5.5 Testing IAM Permissions

#### Test from EC2 Instance

```bash
# Test CloudWatch PutMetricData
aws cloudwatch put-metric-data \
  --namespace TestNamespace \
  --metric-name TestMetric \
  --value 1 \
  --region us-east-1

# Expected: Success (no error)

# Test CloudWatch Logs
aws logs create-log-group \
  --log-group-name /test/log-group \
  --region us-east-1

# Expected: Success or "ResourceAlreadyExistsException" (both are OK)

# Test PutLogEvents
aws logs put-log-events \
  --log-group-name /test/log-group \
  --log-stream-name test-stream \
  --log-events timestamp=$(date +%s)000,message="Test log entry" \
  --region us-east-1

# Expected: Success
```

#### Common Permission Errors

**Error: "User is not authorized to perform: cloudwatch:PutMetricData"**
- **Cause**: Missing `cloudwatch:PutMetricData` permission
- **Fix**: Add permission to IAM role

**Error: "User is not authorized to perform: logs:PutLogEvents"**
- **Cause**: Missing `logs:PutLogEvents` permission
- **Fix**: Add permission to IAM role

**Error: "Access Denied" when creating log group**
- **Cause**: Missing `logs:CreateLogGroup` permission
- **Fix**: Add permission to IAM role

### 5.6 Best Practices

#### 1. Use IAM Roles, Not Access Keys
- ✅ Always use IAM roles for EC2 instances
- ❌ Never hardcode access keys in instances
- ✅ Roles provide automatic credential rotation
- ✅ More secure

#### 2. Follow Principle of Least Privilege
- ✅ Grant only necessary permissions
- ✅ Use scoped policies when possible
- ✅ Restrict to specific namespaces/log groups
- ❌ Avoid wildcard permissions in production

#### 3. Use Managed Policies When Possible
- ✅ Use `CloudWatchAgentServerPolicy` for standard use cases
- ✅ Easier to maintain
- ✅ AWS updates managed policies automatically

#### 4. Regular Permission Audits
- ✅ Review IAM permissions regularly
- ✅ Remove unused permissions
- ✅ Test permissions after changes
- ✅ Monitor CloudTrail for permission denials

---

## 6. Examples: Custom Metrics and Logs

### Overview

This section provides practical examples of sending custom metrics and logs to CloudWatch from EC2 instances. These examples cover common use cases and can be adapted for your specific needs.

### 6.1 Example 1: Custom Metrics Using AWS CLI

#### Scenario

Send a custom metric to CloudWatch using the AWS CLI command `aws cloudwatch put-metric-data`. This is useful for one-off metrics or scripts.

#### Command Syntax

```bash
aws cloudwatch put-metric-data \
  --namespace YourNamespace \
  --metric-name YourMetricName \
  --value YourValue \
  --unit Count \
  --dimensions Key=Value,Key2=Value2 \
  --region us-east-1
```

#### Example 1: Simple Custom Metric

```bash
# Send a simple count metric
aws cloudwatch put-metric-data \
  --namespace MyApp \
  --metric-name OrdersProcessed \
  --value 150 \
  --unit Count \
  --region us-east-1
```

**What this does:**
- Sends metric `OrdersProcessed` with value 150
- Namespace: `MyApp`
- Unit: Count
- Appears in CloudWatch under `MyApp > OrdersProcessed`

#### Example 2: Metric with Dimensions

```bash
# Send metric with dimensions for filtering
aws cloudwatch put-metric-data \
  --namespace MyApp \
  --metric-name ResponseTime \
  --value 250 \
  --unit Milliseconds \
  --dimensions Environment=Production,ServerType=WebServer \
  --region us-east-1
```

**What this does:**
- Sends `ResponseTime` metric with value 250ms
- Dimensions: Environment=Production, ServerType=WebServer
- Can filter by Environment or ServerType in CloudWatch

#### Example 3: Multiple Metrics in One Call

```bash
# Send multiple metrics at once
aws cloudwatch put-metric-data \
  --namespace MyApp \
  --metric-data \
    MetricName=ActiveUsers,Value=1250,Unit=Count \
    MetricName=PageViews,Value=5000,Unit=Count \
    MetricName=ErrorRate,Value=0.5,Unit=Percent \
  --region us-east-1
```

**What this does:**
- Sends 3 metrics in one API call
- More efficient than multiple calls
- All metrics in same namespace

#### Example 4: Metric with Timestamp

```bash
# Send metric with specific timestamp
aws cloudwatch put-metric-data \
  --namespace MyApp \
  --metric-name CustomMetric \
  --value 100 \
  --timestamp $(date -u +%Y-%m-%dT%H:%M:%S) \
  --region us-east-1
```

**What this does:**
- Sends metric with explicit timestamp
- Useful for backfilling historical data
- Timestamp must be within 2 weeks

### 6.2 Example 2: Memory and Disk Metrics via CloudWatch Agent

#### Scenario

Monitor memory usage and disk space using CloudWatch Agent. These metrics are not available in default EC2 metrics.

#### CloudWatch Agent Configuration

**File: `/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json`**

Ensure the agent config includes `mem` and `disk` in `metrics_collected` (as shown in Section 4.3). After starting the agent, metrics appear under namespace `CWAgent`:

- **Memory**: `mem_used_percent`, `mem_available_percent`
- **Disk**: `disk_used_percent` (per mount), `inodes_free`

**Verify in CloudWatch:**

1. CloudWatch → Metrics → All metrics → CWAgent
2. Select `mem_used_percent` or `disk_used_percent`
3. Add dimension `InstanceId` to filter by instance

#### Example 3: Sending Logs via AWS CLI

```bash
# Create log group (one-time)
aws logs create-log-group --log-group-name /myapp/application --region us-east-1

# Create log stream (one-time per source)
aws logs create-log-stream \
  --log-group-name /myapp/application \
  --log-stream-name instance-$(hostname) \
  --region us-east-1

# Send log events
TIMESTAMP=$(date +%s)000
aws logs put-log-events \
  --log-group-name /myapp/application \
  --log-stream-name instance-$(hostname) \
  --log-events "[{\"timestamp\":$TIMESTAMP,\"message\":\"Application started successfully\"}]" \
  --region us-east-1
```

#### Example 4: Python Script for Custom Metrics

```python
import boto3
from datetime import datetime

client = boto3.client('cloudwatch')

# Send custom metric
client.put_metric_data(
    Namespace='MyApp',
    MetricData=[
        {
            'MetricName': 'ActiveConnections',
            'Value': 42,
            'Unit': 'Count',
            'Timestamp': datetime.utcnow(),
            'Dimensions': [
                {'Name': 'Environment', 'Value': 'Production'},
                {'Name': 'Service', 'Value': 'API'}
            ]
        }
    ]
)
```

---

## 7. CloudWatch Logs Insights

### Overview

**CloudWatch Logs Insights** is a feature that lets you interactively search and analyze log data in CloudWatch Logs using a purpose-built query language. You can run queries, visualize results, and add queries to dashboards.

### 7.1 Key Features

- **Query Language**: Purpose-built syntax for log analysis (and support for OpenSearch PPL/SQL in some regions)
- **Automatic Field Discovery**: JSON log fields are automatically discovered and indexed
- **Saved Queries**: Save and reuse queries
- **Dashboard Integration**: Add query results as widgets to CloudWatch dashboards
- **Pattern Detection**: Identify common patterns in log data

### 7.2 Basic Query Syntax

#### Common Commands

| Command | Purpose | Example |
|--------|---------|---------|
| `fields` | Select fields to display | `fields @timestamp, @message, statusCode` |
| `filter` | Filter events | `filter statusCode >= 400` |
| `sort` | Sort results | `sort @timestamp desc` |
| `limit` | Limit number of results | `limit 100` |
| `stats` | Aggregate (count, sum, avg, etc.) | `stats count(*) by bin(5m)` |
| `parse` | Extract fields from message | `parse @message "* * *" as a, b, c` |

#### Example Queries

**1. Find errors in application logs:**
```
fields @timestamp, @message
| filter @message like /error|exception|failed/i
| sort @timestamp desc
| limit 50
```

**2. Count requests by status code:**
```
fields @timestamp, @message
| parse @message " * * * * *" as ip, ident, user, timestamp, request, status
| stats count(*) by status
```

**3. Average response time (if logged as duration):**
```
fields @timestamp, @message
| filter duration > 0
| stats avg(duration) as avg_ms by bin(1h)
```

**4. Top 10 sources by log volume:**
```
fields @timestamp, @logStream, @message
| stats count(*) by @logStream
| sort count desc
| limit 10
```

### 7.3 Running Queries

1. CloudWatch → Logs → Log groups → Select log group
2. Click **Logs Insights** (or open Logs Insights from left menu)
3. Select one or more log groups
4. Enter query and choose time range
5. Click **Run query**

---

## 8. Creating and Managing Alarms

### Overview

Alarms watch a single metric and perform one or more actions when the metric crosses a threshold. Alarms can send SNS notifications, trigger Auto Scaling, or perform EC2 actions (reboot, stop, terminate).

### 8.1 Creating an Alarm (Console)

1. CloudWatch → Alarms → All alarms → **Create alarm**
2. **Select metric** → Choose namespace (e.g. AWS/EC2) → Select metric (e.g. CPUUtilization)
3. **Select dimension** (e.g. InstanceId) if needed
4. **Conditions**: Threshold type (Static / Anomaly detection), condition (e.g. Greater/Equal 80), period (e.g. 1 minute), evaluation periods (e.g. 2 out of 2)
5. **Configure actions**: Add notification (create/new SNS topic), or EC2 action, or Auto Scaling action
6. **Alarm name** and optional description → Create alarm

### 8.2 Alarm States and Transitions

| State | Meaning |
|-------|--------|
| **OK** | Metric is within threshold |
| **ALARM** | Threshold breached; actions run |
| **INSUFFICIENT_DATA** | Not enough data (e.g. new metric or instance stopped) |

- **Datapoints to alarm**: e.g. "2 out of 2" = both evaluation periods must breach to avoid false positives.
- **Missing data treatment**: Option to treat missing data as good, bad, or ignore (affects INSUFFICIENT_DATA).

### 8.3 SNS Integration

- Create an SNS topic (e.g. `cloudwatch-alerts`)
- Subscribe email/SMS endpoints to the topic
- When creating alarm, choose "Send notification to..." and select this topic
- Optional: use **OK action** to send a second notification when alarm returns to OK

### 8.4 Example: CLI to Create Alarm

```bash
# Create alarm: CPU > 80% for 2 consecutive 1-minute periods
aws cloudwatch put-metric-alarm \
  --alarm-name "HighCPU-Alarm" \
  --alarm-description "CPU above 80 percent" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 60 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:cloudwatch-alerts \
  --ok-actions arn:aws:sns:us-east-1:123456789012:cloudwatch-alerts
```

---

## 9. CloudWatch Dashboards

### Overview

Dashboards are customizable home pages in CloudWatch that display selected metrics and log query widgets in one place.

### 9.1 Creating a Dashboard

1. CloudWatch → Dashboards → **Create dashboard**
2. Name the dashboard (e.g. `Production-Overview`)
3. Add widgets: Line, Number, Stacked area, Bar, etc.
4. For each widget: select metric(s) or log query, set label and time range
5. Resize and arrange widgets, then **Save dashboard**

### 9.2 Widget Types

- **Line / Stacked area / Bar**: Time series of metrics
- **Number**: Single value (e.g. current CPU or sum of errors)
- **Text**: Markdown or plain text
- **Logs table**: Results of a Logs Insights query
- **Query result**: Metric math or Logs Insights

### 9.3 Best Practices

- Use one dashboard per environment or application
- Put critical alarms (OK/ALARM count) and key metrics on the first row
- Use consistent time ranges (e.g. 3h or 1d) for comparison
- Share dashboard via **Actions → Share dashboard** (optional snapshot link)

---

## 10. Metric Filters and Subscription Filters

### 10.1 Metric Filters

**Metric filters** derive a numeric value from log events and publish it as a CloudWatch metric. Use them to alarm on log patterns (e.g. count of "ERROR" in logs).

**Example**: Count 5xx errors and publish as metric `5xxCount` in namespace `MyApp/Logs`.

1. Log group → **Metric filters** → Create
2. Filter pattern: `[status = 5*]` or `{ $.statusCode >= 500 }` (for JSON)
3. Select metric namespace, name, value (e.g. 1 per event), default 0

### 10.2 Subscription Filters

**Subscription filters** stream log events to a destination (Lambda, Kinesis Data Streams, or Kinesis Data Firehose) for real-time processing.

- One active subscription filter per log stream (per destination)
- Use for: real-time analytics, archival to S3, custom processing in Lambda

---

## 11. Container Insights (Brief)

**Container Insights** collects metrics and logs from containerized workloads:

- **Supported**: Amazon ECS, Amazon EKS, Fargate, Kubernetes on EC2, Red Hat OpenShift on AWS (ROSA)
- **Metrics**: CPU, memory, disk, network at cluster, node, pod, task, service level
- **Logs**: Stored in CloudWatch Logs; use Logs Insights for analysis
- **Setup**: Enable in ECS/EKS console or via CLI; creates log groups and optional dashboards

---

## 12. CloudWatch Pricing (Summary)

| Component | Model |
|-----------|--------|
| **Metrics** | First 10 custom metrics free; then per metric/month. Standard vs high-resolution (1 sec) pricing. |
| **Logs** | Ingestion (per GB), storage (per GB-month), Logs Insights queries (per GB scanned). |
| **Alarms** | Per alarm per month (first 10 free for standard alarms). |
| **Dashboards** | First 3 dashboards free; then per dashboard per month. |
| **API requests** | PutMetricData, GetMetricData, etc. charged per request after free tier. |

- **Free tier**: Includes limited custom metrics, alarms, dashboards, and API usage; check current AWS Free Tier page.

---

## 13. Quick Reference and Interview Points

### Key Facts

- **Default EC2 metrics**: No memory, no disk space; use CloudWatch Agent for those.
- **Basic vs detailed monitoring**: 5-minute vs 1-minute granularity; detailed may incur cost.
- **Alarm states**: OK, ALARM, INSUFFICIENT_DATA.
- **Log hierarchy**: Log group → Log streams → Log events.
- **Namespaces**: e.g. `AWS/EC2`, `CWAgent`, custom like `MyApp/Metrics`.

### Common Interview Questions

1. **How do you get memory/disk for EC2?**  
   Install and configure CloudWatch Agent; collect `mem` and `disk` metrics.

2. **How do you alarm on log content?**  
   Create a metric filter on the log group to emit a metric, then create an alarm on that metric.

3. **Difference between metric filter and subscription filter?**  
   Metric filter turns log events into a CloudWatch metric. Subscription filter streams log events to Lambda/Kinesis/Firehose.

4. **What IAM permissions does the CloudWatch Agent need?**  
   At minimum: `cloudwatch:PutMetricData`, `logs:CreateLogGroup`, `logs:CreateLogStream`, `logs:PutLogEvents`, `logs:DescribeLogStreams`; often use managed policy `CloudWatchAgentServerPolicy`.

5. **How do you analyze logs without downloading them?**  
   Use CloudWatch Logs Insights to query and aggregate log data in place.

---

*End of Day 11: Amazon CloudWatch notes.*