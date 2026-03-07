# Content Delivery with CloudFront

**Training Notes for AWS & Cloud Computing Beginners**

---

## Table of Contents

1. [Introduction to Content Delivery Networks (CDN)](#1-introduction-to-content-delivery-networks-cdn)
2. [Introduction to Amazon CloudFront](#2-introduction-to-amazon-cloudfront)
3. [CloudFront Architecture](#3-cloudfront-architecture)
4. [CloudFront + S3 Integration](#4-cloudfront--s3-integration)
5. [Hosting a Frontend Website using CloudFront and S3](#5-hosting-a-frontend-website-using-cloudfront-and-s3)
6. [Practical Demo Commands / Workflow](#6-practical-demo-commands--workflow)
7. [CloudFront Security Features](#7-cloudfront-security-features)
8. [Best Practices](#8-best-practices)

---

## 1. Introduction to Content Delivery Networks (CDN)

### Definition of CDN

A **Content Delivery Network (CDN)** is a network of servers distributed across the globe that stores copies of content (images, videos, CSS, JavaScript, HTML) close to users. When a user requests content, the CDN serves it from the nearest server instead of from a single central location.

Think of it as having **multiple mini-warehouses** around the world instead of one big warehouse. Products reach customers faster when they come from the nearest warehouse.

### Why CDN is Required

- **Distance causes delay** – Data travels at the speed of light, but crossing oceans adds milliseconds or hundreds of milliseconds.
- **Single server overload** – One server handling millions of users can become slow or fail.
- **Bandwidth costs** – Serving large files (videos, images) from one location is expensive and slow.
- **User experience** – Slow websites lead to higher bounce rates and lower conversions.

### Problems with Traditional Website Hosting

| Problem | Description |
|---------|-------------|
| **High latency** | User in Tokyo requests from a server in Virginia → long round-trip time |
| **Single point of failure** | If the main server goes down, the whole site is unavailable |
| **Bandwidth bottleneck** | One server has limited capacity; traffic spikes cause slowdowns |
| **Expensive scaling** | Scaling a single server is costly and complex |
| **Slow for static content** | Images, CSS, JS are fetched from the same far-away server every time |

### How CDN Improves Performance

1. **Caching** – Stores copies of content at edge locations. Users get content from nearby servers.
2. **Reduced latency** – Shorter distance = faster response.
3. **Load distribution** – Traffic is spread across many edge servers instead of one origin.
4. **Bandwidth savings** – Origin server sends content once to the CDN; CDN serves many users locally.
5. **DDoS mitigation** – CDN can absorb and filter malicious traffic before it reaches the origin.

### Real-World Examples of CDN Usage

| Company | Use Case |
|---------|----------|
| **Netflix** | Streams movies and shows from edge locations so playback starts quickly |
| **Amazon** | Product images, CSS, and JavaScript load from nearby edge servers for faster page loads |
| **YouTube** | Video chunks are served from edge locations for smooth playback |
| **Facebook** | Profile pictures, posts, and ads are cached at the edge |
| **Large news sites** | Articles, images, and videos load quickly for readers worldwide |

---

## 2. Introduction to Amazon CloudFront

### Definition of Amazon CloudFront

**Amazon CloudFront** is AWS's global Content Delivery Network (CDN) service. It delivers content (web pages, images, videos, APIs) to users with low latency by caching copies at **edge locations** around the world and serving them from the location closest to each user.

### What Type of Service CloudFront is

- **CDN service** – Distributes content globally.
- **Managed service** – AWS operates and maintains the edge locations.
- **Pay-as-you-go** – You pay for data transfer and requests; no upfront cost.
- **Integrated** – Works with S3, EC2, ELB, and custom origins.

### Key Features of CloudFront

| Feature | Description |
|---------|-------------|
| **Global edge network** | Hundreds of edge locations worldwide |
| **Multiple origin types** | S3, EC2, ELB, or any custom HTTP(S) server |
| **HTTPS support** | SSL/TLS encryption for secure delivery |
| **Custom domains** | Use your own domain (e.g., www.example.com) |
| **Caching** | Configurable cache behavior (TTL, headers, cookies) |
| **Compression** | Automatic gzip compression for text-based content |
| **WAF integration** | Protect against common web attacks |

### Benefits of Using CloudFront

#### Low Latency

- Content is served from the **nearest edge location** to the user.
- Example: User in Mumbai gets content from an edge in Mumbai or nearby, not from us-east-1.

#### High Data Transfer Speed

- Edge locations have high bandwidth and optimized networks.
- Large files (videos, downloads) transfer faster than from a single origin.

#### Global Edge Locations

- AWS has edge locations in North America, Europe, Asia, South America, and Australia.
- Content is replicated to many locations for global coverage.

#### Security Integration

- HTTPS by default.
- Integration with AWS WAF (Web Application Firewall).
- Origin Access Identity (OAI) to restrict direct S3 access.

### What are Edge Locations

- **Edge locations** are data centers where CloudFront caches copies of your content.
- They are **smaller than AWS Regions** and are placed in densely populated areas.
- When a user requests content, CloudFront serves it from the nearest edge location.
- **There are hundreds of edge locations** worldwide (exact count changes as AWS expands).

**Example:** A user in London might get content from an edge in London or Manchester, not from the origin server in Virginia.

### Difference Between Origin Server and Edge Location

| Aspect | Origin Server | Edge Location |
|--------|---------------|---------------|
| **What it is** | Your actual source of content (S3, EC2, etc.) | CloudFront cache server |
| **Location** | Usually in one or few AWS Regions | Hundreds of locations worldwide |
| **Role** | Stores the original, authoritative content | Stores cached copies for fast delivery |
| **When used** | When content is not in cache (cache miss) | When content is in cache (cache hit) |
| **You manage** | Yes (S3 bucket, EC2, etc.) | No (AWS manages) |

---

## 3. CloudFront Architecture

### Core Components

#### 1. User / Client

- The end user (browser, mobile app, IoT device) that requests content.
- Example: Someone in Tokyo opens `https://www.example.com/image.jpg`.

#### 2. Edge Location

- A CloudFront server that caches content and serves it to nearby users.
- If the content is cached (cache hit), the edge location responds directly.
- If not (cache miss), it fetches from the origin and caches it for future requests.

#### 3. Origin Server

- The source of your content (S3 bucket, EC2, Load Balancer, or custom server).
- Holds the original, authoritative version of your files.
- CloudFront fetches from the origin when the edge cache doesn't have the content.

#### 4. Distribution

- The CloudFront configuration that defines:
  - Which origin(s) to use
  - Cache behavior (what to cache, for how long)
  - Domain names (CloudFront URL or custom domain)
  - SSL certificate
  - Price class (which edge locations to use)

### How CloudFront Delivers Content – Step by Step

```
Step 1: User (e.g., in Mumbai) requests https://d1234abcd.cloudfront.net/image.jpg
        ↓
Step 2: Request goes to the nearest CloudFront edge location (e.g., Mumbai)
        ↓
Step 3: Edge location checks its cache:
        • CACHE HIT  → Content is in cache → Go to Step 6
        • CACHE MISS → Content not in cache → Go to Step 4
        ↓
Step 4: Edge location fetches content from Origin (e.g., S3 bucket in us-east-1)
        ↓
Step 5: Edge location stores a copy in its cache (for future requests)
        ↓
Step 6: Edge location sends content back to the user
        ↓
Step 7: User receives the content (image loads in browser)
```

**First request (cache miss):** User → Edge → Origin → Edge → User (slower)  
**Later requests (cache hit):** User → Edge → User (faster)

---

## 4. CloudFront + S3 Integration

### What is Amazon S3

**Amazon S3 (Simple Storage Service)** is AWS's object storage service. You store files (objects) in buckets. S3 is highly durable, scalable, and cost-effective for storing static content like images, CSS, JavaScript, and HTML.

### Why S3 is Used to Host Static Websites

- **Static content** – HTML, CSS, JS, images don't need a server to process them.
- **Cost-effective** – Pay only for storage and requests; no EC2 to manage.
- **Scalable** – Handles any amount of traffic.
- **Simple** – Enable static website hosting, upload files, and the site is live.

**Limitation:** S3 alone serves content from one region. Users far from that region experience higher latency.

### How CloudFront Improves S3 Website Performance

| Without CloudFront | With CloudFront |
|-------------------|-----------------|
| All requests go to S3 in one region | Requests served from nearest edge location |
| Higher latency for distant users | Lower latency globally |
| S3 receives every request | S3 receives only cache-miss requests |
| No caching at edge | Content cached at edge for fast repeat access |

### Role of Origin in CloudFront

- The **origin** is the source CloudFront uses to fetch content.
- For S3, the origin is your **S3 bucket** (or S3 website endpoint).
- CloudFront pulls content from the origin when:
  - The content is not in cache (cache miss)
  - The cached content has expired (TTL reached)
  - You invalidate the cache

### Using S3 Bucket as Origin for CloudFront

**Two options:**

1. **S3 bucket endpoint** (e.g., `my-bucket.s3.amazonaws.com`)
   - Use for general content delivery.
   - Works with Origin Access Identity (OAI) for private buckets.

2. **S3 website endpoint** (e.g., `my-bucket.s3-website-us-east-1.amazonaws.com`)
   - Use when S3 static website hosting is enabled.
   - Supports default index and error documents.

**In CloudFront:** You create a distribution and set the S3 bucket (or website endpoint) as the origin. CloudFront then fetches and caches content from that bucket.

---

## 5. Hosting a Frontend Website using CloudFront and S3

### Step 1: Create an S3 Bucket

1. Open **S3 Console** → **Create bucket**.
2. **Bucket name:** Choose a unique name (e.g., `my-website-bucket-12345`).
3. **Region:** Select your preferred region (e.g., `us-east-1`).
4. **Block Public Access:** Leave default for now; we'll adjust in Step 4.
5. Create the bucket.

### Step 2: Enable Static Website Hosting

1. Open your bucket → **Properties** tab.
2. Scroll to **Static website hosting**.
3. Click **Edit**.
4. Select **Enable**.
5. **Hosting type:** Host a static website.
6. **Index document:** `index.html` (default).
7. **Error document:** `error.html` (optional).
8. Save changes.

### Step 3: Upload Frontend Files (HTML, CSS, JS)

1. Open your bucket → **Objects** tab.
2. Click **Upload**.
3. Add your files:
   - `index.html` (main page)
   - `style.css` (styles)
   - `script.js` (JavaScript)
   - Images, fonts, etc.
4. Upload.

**Structure example:**
```
my-website-bucket/
├── index.html
├── style.css
├── script.js
└── images/
    └── logo.png
```

### Step 4: Set Bucket Permissions for Public Access

**Option A: Public bucket (simple, for demo)**

1. Bucket → **Permissions** → **Block public access**.
2. Edit → Uncheck **Block all public access** (for demo only).
3. Add bucket policy to allow public read:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-website-bucket-12345/*"
    }
  ]
}
```

**Option B: Private bucket + CloudFront OAI (recommended for production)**  
- Keep bucket private and use Origin Access Identity (OAI) so only CloudFront can access S3. See Security section.

### Step 5: Create CloudFront Distribution

1. Open **CloudFront Console** → **Create distribution**.
2. **Origin domain:** Select your S3 bucket (e.g., `my-website-bucket-12345.s3.amazonaws.com`).
   - Or use S3 website endpoint if you use static website hosting.
3. **Origin path:** Leave blank.
4. **Name:** Auto-filled from origin.
5. **Origin access:** 
   - Legacy access identities (deprecated) or
   - Origin access control settings (recommended) – Create new OAC if bucket is private.
6. **Viewer protocol policy:** Redirect HTTP to HTTPS (recommended).
7. **Allowed HTTP methods:** GET, HEAD, OPTIONS (for static sites).
8. **Cache key and origin requests:** Default (or customize).
9. **Price class:** Use all edge locations (or reduce for cost savings).
10. **Alternate domain names (CNAME):** Optional – add your domain (e.g., `www.example.com`).
11. **SSL certificate:** Default CloudFront certificate (or custom if using your domain).
12. **Default root object:** `index.html` (so `/` serves index.html).
13. Click **Create distribution**.

### Step 6: Configure S3 as Origin

- This is done in Step 5 when you select the S3 bucket as **Origin domain**.
- CloudFront automatically uses that S3 bucket as the origin for the distribution.

### Step 7: Access Website Using CloudFront Domain

1. After creation, CloudFront assigns a domain like: `d1234abcd.cloudfront.net`.
2. Open: `https://d1234abcd.cloudfront.net` in your browser.
3. Your website loads from the nearest edge location.
4. For a custom domain, add a CNAME in Route 53 pointing to `d1234abcd.cloudfront.net`.

---

## 6. Practical Demo Commands / Workflow

### Using AWS CLI

#### Step 1: Upload Website Files to S3

```bash
# Create a test index.html
echo "<h1>Hello from CloudFront!</h1><p>This is served via CDN.</p>" > index.html

# Upload to S3 bucket
aws s3 cp index.html s3://my-website-bucket-12345/
aws s3 cp style.css s3://my-website-bucket-12345/  # if you have one
```

**Upload entire folder:**
```bash
aws s3 sync ./website-folder s3://my-website-bucket-12345/
```

#### Step 2: Create CloudFront Distribution

```bash
aws cloudfront create-distribution \
  --origin-domain-name my-website-bucket-12345.s3.amazonaws.com \
  --default-root-object index.html \
  --viewer-protocol-policy redirect-to-https
```

**Note:** Full distribution creation often uses a JSON config. For simplicity, use the Console for the first time.

#### Step 3: Access the Website Through CloudFront URL

1. Get the distribution domain from the CloudFront console or CLI:
   ```bash
   aws cloudfront list-distributions --query 'DistributionList.Items[*].DomainName' --output text
   ```
2. Open `https://<distribution-domain>.cloudfront.net` in your browser.
3. You should see your website.

#### Step 4: How Caching Works

**First request:**
```
User (Mumbai) → Edge (Mumbai) → Cache MISS → Origin (S3 us-east-1) → Edge caches → User
```
- Slower (includes fetch from S3).

**Second request (same or different user in Mumbai):**
```
User → Edge (Mumbai) → Cache HIT → User
```
- Faster (served from edge cache).

**Cache TTL:** By default, CloudFront caches based on `Cache-Control` headers from the origin. You can set default TTL in the distribution (e.g., 86400 seconds = 24 hours).

**Invalidation (clear cache):**
```bash
aws cloudfront create-invalidation \
  --distribution-id E1234ABCD5678 \
  --paths "/*"
```

---

## 7. CloudFront Security Features

### HTTPS Support

- CloudFront supports **HTTPS (TLS/SSL)** by default.
- **Viewer protocol policy** options:
  - **HTTP and HTTPS** – Allow both.
  - **Redirect HTTP to HTTPS** – Force secure connections (recommended).
  - **HTTPS only** – Reject HTTP.

### SSL Certificates

- **Default certificate:** CloudFront provides `*.cloudfront.net` – works for `d1234abcd.cloudfront.net`.
- **Custom certificate:** Use **AWS Certificate Manager (ACM)** to add your domain (e.g., `www.example.com`) and enable HTTPS.
- Certificates must be in **us-east-1** for CloudFront.

### AWS WAF Integration

- **AWS WAF (Web Application Firewall)** can be attached to a CloudFront distribution.
- Protects against:
  - SQL injection
  - Cross-site scripting (XSS)
  - Common vulnerabilities (OWASP Top 10)
- You can create rules to block or allow traffic based on IP, headers, or request patterns.

### Access Control Using Origin Access Identity (OAI)

**Problem:** If your S3 bucket is public, anyone can access files directly via the S3 URL, bypassing CloudFront.

**Solution: Origin Access Identity (OAI) / Origin Access Control (OAC)**

1. **Create OAI/OAC** in CloudFront distribution settings.
2. **Update S3 bucket policy** to allow access only from CloudFront (using the OAI/OAC principal).
3. **Block public access** on the S3 bucket.
4. **Result:** Users can access content only through CloudFront, not directly from S3.

**Benefits:**
- S3 bucket stays private.
- All traffic goes through CloudFront (logging, WAF, caching).
- No direct S3 URLs; only your CloudFront domain works.

---

## 8. Best Practices

### Use CloudFront for Global Websites

- If your users are in multiple regions, use CloudFront to reduce latency.
- Static sites, APIs, and media benefit the most.

### Configure Proper Caching

- **Static assets (images, CSS, JS):** Use longer TTL (e.g., 24 hours or more).
- **Dynamic content:** Use shorter TTL or disable caching.
- **Cache invalidation:** Use when you update content; avoid `/*` if possible to reduce cost.

### Enable HTTPS

- Always use **Redirect HTTP to HTTPS** for production.
- Use ACM for custom domains.

### Protect S3 Buckets Using OAI/OAC

- Keep S3 buckets private.
- Use Origin Access Identity (OAI) or Origin Access Control (OAC) so only CloudFront can read from S3.
- Prevents direct S3 access and reduces risk of data exposure.

### Monitor Distribution Performance

- Use **CloudWatch** metrics:
  - Requests
  - Bytes downloaded
  - Error rate (4xx, 5xx)
  - Cache hit rate
- Set alarms for high error rates or unusual traffic.
- Use **CloudFront access logs** (optional) for detailed analysis.

---

## Quick Reference

### CloudFront Concepts

| Term | Meaning |
|------|---------|
| **Distribution** | CloudFront configuration (origin, cache, domain) |
| **Edge location** | Cache server close to users |
| **Origin** | Source of content (S3, EC2, etc.) |
| **Cache hit** | Content served from edge (fast) |
| **Cache miss** | Content fetched from origin, then cached |
| **OAI/OAC** | Restricts S3 access to CloudFront only |

### Typical Workflow

```
S3 (origin) → CloudFront (distribution) → Edge locations → Users
```

---

*End of Content Delivery with CloudFront training notes.*
