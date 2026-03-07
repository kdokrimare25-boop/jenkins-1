# DNS and Route 53 for Domain Management

**Training Notes for AWS & Cloud Computing Beginners**

---

## Table of Contents

1. [How the Internet Works](#1-how-the-internet-works)
2. [Introduction to DNS (Domain Name System)](#2-introduction-to-dns-domain-name-system)
3. [DNS Records and Zones](#3-dns-records-and-zones)
4. [Introduction to Amazon Route 53](#4-introduction-to-amazon-route-53)
5. [Purchasing a Domain using Route 53](#5-purchasing-a-domain-using-route-53)
6. [Practical Demo Workflow](#6-practical-demo-workflow)
7. [Best Practices](#7-best-practices)

---

## 1. How the Internet Works

### The Basic Concept of the Internet

The **Internet** is a global network of connected computers and servers. When you browse a website, your computer sends a request over the Internet to a server that hosts that website. The server sends back the website content (text, images, videos) to your browser.

Think of it like a postal system: your computer sends a "letter" (request) to a server, and the server sends back a "reply" (the webpage).

### What Happens When a User Enters a Website URL in a Browser

When you type `https://www.google.com` in your browser and press Enter:

1. **Browser receives the URL** – The browser understands you want to visit Google.
2. **DNS lookup** – The browser needs to find the IP address of Google's server (computers use numbers, not names).
3. **Connection established** – Your computer connects to that IP address.
4. **Request sent** – The browser asks for the webpage.
5. **Response received** – The server sends back the HTML, images, and other content.
6. **Page displayed** – Your browser renders and shows the webpage.

### Role of IP Address

- An **IP (Internet Protocol) address** is a unique numeric identifier for a device on the Internet.
- Example: `142.250.185.46` (IPv4) or `2607:f8b0:4004:c07::71` (IPv6).
- **Computers use IP addresses** to find and communicate with each other.
- **Humans find IP addresses hard to remember** – Would you rather remember `google.com` or `142.250.185.46`?

### Role of Web Servers

- A **web server** is a computer (or virtual machine) that stores website files and serves them to users.
- When you request a webpage, the web server:
  - Receives your request
  - Finds the requested files (HTML, images, etc.)
  - Sends them back to your browser
- Web servers have IP addresses so other computers can reach them.

### How Domain Names Connect Users to Servers

- **Domain names** (e.g., `google.com`, `amazon.com`) are human-friendly names.
- **DNS (Domain Name System)** translates domain names into IP addresses.
- Without DNS, you would need to remember and type IP addresses for every website.
- Domain names act as **aliases** for IP addresses – easier to remember and can change without users noticing.

### Simple Step-by-Step: How a Request Reaches the Server

```
Step 1: User types "www.example.com" in browser
        ↓
Step 2: Browser asks DNS: "What is the IP address of www.example.com?"
        ↓
Step 3: DNS responds: "The IP is 93.184.216.34"
        ↓
Step 4: Browser sends request to 93.184.216.34 (port 443 for HTTPS)
        ↓
Step 5: Web server at that IP receives the request
        ↓
Step 6: Server sends back the webpage
        ↓
Step 7: Browser displays the webpage to the user
```

---

## 2. Introduction to DNS (Domain Name System)

### Definition of DNS

**DNS (Domain Name System)** is a distributed system that translates human-readable domain names (like `google.com`) into IP addresses (like `142.250.185.46`) that computers use to communicate over the Internet.

### Why DNS is Required

- **Humans prefer names** – We remember `amazon.com`, not `52.94.236.248`.
- **IP addresses change** – Servers move, scale, or get replaced. DNS lets you keep the same domain name while updating the IP behind it.
- **Load balancing** – One domain can point to multiple IPs; DNS can distribute traffic.
- **Global scale** – DNS works worldwide, so anyone can reach your website by name.

### DNS as the "Phonebook of the Internet"

Just as a phonebook maps names to phone numbers, DNS maps domain names to IP addresses:

| Phonebook        | DNS              |
|------------------|------------------|
| Person's name     | Domain name      |
| Phone number     | IP address       |
| Look up by name   | Look up by domain|

### How DNS Converts Domain Names into IP Addresses

1. Your computer sends a **DNS query**: "What is the IP for www.google.com?"
2. The query goes to a **DNS resolver** (often provided by your ISP or router).
3. The resolver asks **root servers**, then **TLD servers** (.com), then **authoritative servers** for google.com.
4. The authoritative server responds with the IP address.
5. Your computer receives the IP and connects to it.

### Components Involved in DNS Resolution

| Component | Role |
|-----------|------|
| **DNS Resolver** | Receives your query and finds the answer (e.g., your ISP's DNS server) |
| **Root Servers** | Point to Top-Level Domain (TLD) servers (.com, .org, .net) |
| **TLD Servers** | Point to authoritative servers for each domain |
| **Authoritative Name Server** | Holds the actual DNS records for a domain (e.g., Route 53 for your domain) |

### Example: How google.com Resolves to an IP Address

```
User types: www.google.com
     ↓
DNS Resolver: "Where is www.google.com?"
     ↓
Root Server: "For .com, ask the .com TLD server"
     ↓
.com TLD Server: "For google.com, ask Google's authoritative server"
     ↓
Google's Authoritative Server: "www.google.com = 142.250.185.46"
     ↓
Resolver returns: 142.250.185.46
     ↓
Browser connects to 142.250.185.46
```

---

## 3. DNS Records and Zones

### Definition of DNS Record

A **DNS record** is a single mapping stored in a DNS zone. Each record tells the DNS system how to handle a specific type of request for your domain (e.g., "Where is the web server?" or "Where do emails go?").

### Types of DNS Records

#### A Record (Address Record)

- **Purpose:** Maps a domain or subdomain to an **IPv4 address**.
- **Use case:** Points your website to a server's IP address.
- **Example:** `www.example.com` → `93.184.216.34`

```
Type: A
Name: www
Value: 93.184.216.34
TTL: 300
```

**Real-world use:** Your EC2 instance has IP `3.108.45.100`. You create an A record: `www.mywebsite.com` → `3.108.45.100`. Users visiting www.mywebsite.com are directed to your EC2 server.

---

#### AAAA Record

- **Purpose:** Maps a domain or subdomain to an **IPv6 address**.
- **Use case:** Same as A record, but for IPv6 (longer, newer format).
- **Example:** `www.example.com` → `2606:2800:220:1:248:1893:25c8:1946`

```
Type: AAAA
Name: www
Value: 2606:2800:220:1:248:1893:25c8:1946
TTL: 300
```

**Real-world use:** Your server supports IPv6. You add an AAAA record so IPv6 users can reach your site.

---

#### CNAME Record (Canonical Name)

- **Purpose:** Maps one domain name to **another domain name** (alias).
- **Use case:** Point `www.example.com` to `example.com`, or point a subdomain to an external service (e.g., CDN, load balancer).
- **Example:** `www.example.com` → `example.com` (or `lb-12345.us-east-1.elb.amazonaws.com`)

```
Type: CNAME
Name: www
Value: example.com
TTL: 300
```

**Real-world use:** Your website is served by a load balancer: `myapp-1234567890.us-east-1.elb.amazonaws.com`. You create a CNAME: `www.myapp.com` → that load balancer DNS name. Users type www.myapp.com instead of the long AWS URL.

**Note:** You cannot create a CNAME for the root domain (example.com). Use A or AAAA for the root.

---

#### MX Record (Mail Exchange)

- **Purpose:** Specifies which **mail servers** receive email for your domain.
- **Use case:** Directing email (e.g., `user@example.com`) to the correct mail server.
- **Example:** `example.com` → `mail.example.com` (priority 10)

```
Type: MX
Name: (blank for root) or @
Value: mail.example.com
Priority: 10
TTL: 3600
```

**Real-world use:** You use Google Workspace for email. You add MX records pointing to Google's mail servers (e.g., `aspmx.l.google.com`) so emails to `@yourcompany.com` go to Gmail.

---

#### TXT Record (Text Record)

- **Purpose:** Stores **text information** – often used for verification, SPF (email), DKIM, or other metadata.
- **Use case:** Domain ownership verification, email authentication (SPF/DKIM), security policies.
- **Example:** `v=spf1 include:_spf.google.com ~all`

```
Type: TXT
Name: @
Value: "v=spf1 include:_spf.google.com ~all"
TTL: 3600
```

**Real-world use:** 
- **SPF:** Tells receiving mail servers which servers can send email for your domain.
- **Verification:** Services like Google Search Console ask you to add a TXT record to prove you own the domain.

---

#### NS Record (Name Server)

- **Purpose:** Specifies which **name servers** are authoritative for your domain.
- **Use case:** Delegating DNS management – tells the Internet "ask these servers for DNS records for this domain."
- **Example:** `example.com` → `ns-123.awsdns-45.com`

```
Type: NS
Name: @
Value: ns-123.awsdns-45.com
TTL: 172800
```

**Real-world use:** You buy a domain from GoDaddy but use Route 53 for DNS. You update the NS records at GoDaddy to point to Route 53's name servers. All DNS queries for your domain then go to Route 53.

---

### What is a DNS Zone

A **DNS zone** is a portion of the DNS namespace for which a specific organization or service is responsible. It contains all the DNS records for a domain and its subdomains.

- **Example:** The zone for `example.com` can include records for `example.com`, `www.example.com`, `mail.example.com`, etc.

### What is a Hosted Zone

A **hosted zone** is a container in a DNS service (like Route 53) that holds the DNS records for a domain. It is the "file" where you add, edit, and delete A, CNAME, MX, TXT, and other records.

- **Route 53 Hosted Zone** = A hosted zone in AWS that stores your domain's DNS records.
- When you create a hosted zone, Route 53 assigns you **name servers** (NS records) to use.

### Public vs Private Hosted Zone

| Type | Purpose | Visibility |
|------|---------|------------|
| **Public Hosted Zone** | DNS for resources on the public Internet (websites, APIs) | Queried by anyone on the Internet |
| **Private Hosted Zone** | DNS for resources inside a VPC (internal hostnames) | Queried only by resources in linked VPCs |

**Example – Public:** `www.mycompany.com` → EC2 public IP (users worldwide can resolve it).

**Example – Private:** `db.internal.mycompany.com` → RDS private IP (only EC2 instances in your VPC can resolve it).

### How Records are Stored Inside a Hosted Zone

```
Hosted Zone: example.com
├── A      www.example.com        → 93.184.216.34
├── A      example.com            → 93.184.216.34
├── CNAME  blog.example.com       → www.example.com
├── MX     example.com            → mail.example.com (priority 10)
├── TXT    example.com            → "v=spf1 include:_spf.google.com ~all"
└── NS     example.com            → ns-123.awsdns-45.com
```

Each record has: **Type**, **Name**, **Value**, and **TTL** (Time To Live – how long resolvers can cache the answer).

---

## 4. Introduction to Amazon Route 53

### Definition of Amazon Route 53

**Amazon Route 53** is AWS's scalable DNS web service. It lets you:
- Register domain names
- Route traffic to AWS and external resources
- Configure health checks and failover
- Manage DNS with high availability and low latency

The name "53" refers to the port number used for DNS (port 53).

### Why Route 53 is Used in AWS

- **Integration** – Works seamlessly with EC2, S3, CloudFront, Load Balancers, and other AWS services.
- **Reliability** – Built for high availability and used by AWS itself.
- **Single place** – Manage domains and DNS in the same place as your infrastructure.
- **Advanced routing** – Weighted, latency-based, failover, and geolocation routing.

### Key Features of Route 53

| Feature | Description |
|---------|-------------|
| **Domain registration** | Buy and manage domains (.com, .net, .org, etc.) |
| **DNS routing** | Host DNS records and route traffic to your resources |
| **Health checks** | Monitor endpoints and route traffic only to healthy resources |
| **High availability** | Globally distributed DNS; designed for 100% uptime SLA |

### Advantages of Route 53

- **Global anycast** – Queries are answered from the nearest Route 53 location.
- **Low latency** – Fast DNS resolution worldwide.
- **Integration** – Works with ELB, CloudFront, S3, EC2, etc.
- **Flexible routing** – Multiple routing policies for different use cases.
- **Pay-as-you-go** – Pay per hosted zone and queries.

### Routing Policies

#### Simple Routing

- **What it does:** One record per name; returns one or more values (e.g., multiple IPs). The client chooses randomly if multiple values exist.
- **Use case:** Single region, single resource, or basic load distribution.
- **Example:** `www.example.com` → `1.2.3.4`

---

#### Weighted Routing

- **What it does:** Distributes traffic across multiple resources based on **weights** (e.g., 70% to server A, 30% to server B).
- **Use case:** Canary deployments, A/B testing, gradual migration.
- **Example:** 
  - Record 1: `www.example.com` → Server A (weight 70)
  - Record 2: `www.example.com` → Server B (weight 30)

---

#### Latency-based Routing

- **What it does:** Routes users to the region with the **lowest latency** from their location.
- **Use case:** Global applications with replicas in multiple regions.
- **Example:** User in India → ap-south-1; User in USA → us-east-1.

---

#### Failover Routing

- **What it does:** Uses a **primary** resource; if health checks fail, traffic goes to a **secondary** (backup) resource.
- **Use case:** Disaster recovery, high availability.
- **Example:** Primary: us-east-1; Secondary: us-west-2. If primary is unhealthy, Route 53 sends traffic to secondary.

---

#### Geolocation Routing

- **What it does:** Routes traffic based on the user's **geographic location** (country/continent).
- **Use case:** Content localization, compliance, regional restrictions.
- **Example:** Users in India → Indian server; Users in Europe → EU server.

---

## 5. Purchasing a Domain using Route 53

### What is Domain Registration

**Domain registration** is the process of reserving a domain name (e.g., `mycompany.com`) for a period (usually 1–10 years). You pay a registrar (e.g., Route 53) to "own" that name and control its DNS records.

### Searching for Domain Availability

1. Open **Route 53 Console** → **Registered domains** (or **Domains** → **Register domain**).
2. Enter the domain name you want (e.g., `myawesomeapp`).
3. Choose a TLD (e.g., `.com`, `.net`, `.org`).
4. Click **Check** to see if it is available.
5. If available, you can add it to the cart.

### Buying a Domain in AWS Route 53

1. **Add to cart** – Select the domain and add it.
2. **Contact information** – Enter registrant, admin, and tech contact details (required by ICANN).
3. **Privacy protection** – Optionally enable to hide your contact info in WHOIS.
4. **Duration** – Choose 1–10 years.
5. **Payment** – Complete the purchase with your AWS account payment method.

### Automatic Creation of Hosted Zone

- When you register a domain through Route 53, AWS can **automatically create a public hosted zone** for that domain.
- The hosted zone is created with default NS and SOA records.
- You can then add A, CNAME, MX, TXT, and other records.

### Managing Domain DNS Records

1. Go to **Route 53** → **Hosted zones**.
2. Select your domain's hosted zone.
3. **Create record** – Add A, CNAME, MX, TXT, etc.
4. **Edit/Delete** – Update or remove records as needed.
5. Changes propagate globally within minutes (depending on TTL).

### Connecting Domain to a Website or EC2 Server

**Option 1: EC2 instance with Elastic IP**

1. Allocate an Elastic IP to your EC2 instance.
2. Create an **A record** in the hosted zone:
   - Name: `www` (or leave blank for root)
   - Type: A
   - Value: Your Elastic IP
   - TTL: 300

**Option 2: Application Load Balancer**

1. Create an **A record** (alias) or **CNAME**:
   - Name: `www`
   - Type: A – Alias
   - Alias target: Your ALB (e.g., `my-alb-1234567890.us-east-1.elb.amazonaws.com`)

**Option 3: S3 static website or CloudFront**

1. Create an **A record** (alias) pointing to the S3 website endpoint or CloudFront distribution.
2. For HTTPS, use CloudFront with an ACM certificate.

---

## 6. Practical Demo Workflow

### Simple Demo: Domain → EC2 Website

#### Step 1: Purchase a Domain

1. Route 53 → **Register domain**.
2. Search for a domain (e.g., `mydemosite123.com`).
3. Complete registration and payment.
4. Wait for confirmation (usually a few minutes).

#### Step 2: Create Hosted Zone (if not auto-created)

1. Route 53 → **Hosted zones** → **Create hosted zone**.
2. Domain name: `mydemosite123.com`.
3. Type: **Public hosted zone**.
4. Create.
5. If you registered via Route 53, the hosted zone may already exist.

#### Step 3: Add A Record Pointing to EC2 Instance

1. Open the hosted zone for `mydemosite123.com`.
2. **Create record**:
   - **Record name:** `www` (for www.mydemosite123.com) or leave blank for root.
   - **Record type:** A.
   - **Value:** Your EC2 instance's **Elastic IP** (e.g., `3.108.45.100`).
   - **TTL:** 300.
3. **Create records**.

#### Step 4: Update Name Servers at Registrar (if domain was bought elsewhere)

If you bought the domain from another registrar (GoDaddy, Namecheap, etc.):

1. Copy the 4 NS values from the Route 53 hosted zone (e.g., `ns-123.awsdns-45.com`).
2. Log in to your registrar.
3. Find "Name servers" or "DNS settings".
4. Replace existing name servers with Route 53's NS values.
5. Save and wait for propagation (up to 48 hours, often much less).

#### Step 5: Access Website Using Domain Name

1. Wait a few minutes for DNS propagation.
2. Open a browser and go to `www.mydemosite123.com`.
3. The browser resolves the domain to your EC2 IP and loads your website.

**Troubleshooting:** Use `nslookup www.mydemosite123.com` or `dig www.mydemosite123.com` to verify the A record resolves correctly.

---

## 7. Best Practices

### DNS Security Basics

- **Use HTTPS** – Encrypt traffic between users and your servers.
- **Enable DNSSEC** (where supported) – Validates DNS responses and reduces spoofing risk.
- **Restrict access** – Use IAM to limit who can change Route 53 records.
- **Monitor changes** – Use CloudTrail to audit DNS changes.

### Use TTL Wisely

- **Low TTL (e.g., 60–300 seconds):** When you expect to change records soon (e.g., during migrations or failover). Faster updates, more DNS queries.
- **High TTL (e.g., 86400 = 24 hours):** For stable records. Fewer queries, slower propagation of changes.
- **Balance:** Use low TTL for critical records, higher TTL for static records.

### Backup DNS Records

- **Export records** – Use Route 53 API or CLI to list and save your records.
- **Document** – Keep a list of important records (A, CNAME, MX) in a runbook or wiki.
- **Version control** – Store DNS config in IaC (Terraform, CloudFormation) for recovery and audit.

### Protect Domain Ownership

- **Enable domain lock** – Prevents unauthorized transfers.
- **Use strong registrar account security** – MFA, strong password.
- **Verify contact email** – Ensure you receive renewal and transfer notices.
- **Renew before expiry** – Set calendar reminders; consider auto-renewal.

### Use Health Checks for Reliability

- **Configure health checks** – Route 53 can monitor your endpoints (HTTP/HTTPS, TCP).
- **Failover routing** – Combine health checks with failover routing for automatic recovery.
- **Monitor health check status** – Set CloudWatch alarms if health checks fail.

---

## Quick Reference

### Common DNS Record Types

| Type | Purpose |
|------|---------|
| A | Domain → IPv4 address |
| AAAA | Domain → IPv6 address |
| CNAME | Domain → Another domain (alias) |
| MX | Email → Mail servers |
| TXT | Text (verification, SPF, etc.) |
| NS | Domain → Name servers |

### Route 53 Routing Policies (Summary)

| Policy | Use Case |
|--------|----------|
| Simple | Single resource, basic setup |
| Weighted | Split traffic by percentage |
| Latency-based | Route to lowest-latency region |
| Failover | Primary + backup with health checks |
| Geolocation | Route by user location |

---

*End of DNS and Route 53 training notes.*
