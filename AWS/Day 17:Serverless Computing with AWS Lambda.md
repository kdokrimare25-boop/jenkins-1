# Serverless Computing with AWS Lambda

**Training Notes for AWS & Cloud Computing Beginners**

---

## Table of Contents

1. [Introduction to Serverless Computing](#1-introduction-to-serverless-computing)
2. [Introduction to AWS Lambda](#2-introduction-to-aws-lambda)
3. [Features of AWS Lambda](#3-features-of-aws-lambda)
4. [Lambda Function Demo (Practical Understanding)](#4-lambda-function-demo-practical-understanding)
5. [Lambda Layers](#5-lambda-layers)
6. [Lambda Triggers](#6-lambda-triggers)
7. [Introduction to API Gateway](#7-introduction-to-api-gateway)
8. [API Gateway + Lambda Integration](#8-api-gateway--lambda-integration)
9. [Practical Demo Workflow](#9-practical-demo-workflow)
10. [Best Practices](#10-best-practices)

---

## 1. Introduction to Serverless Computing

### Definition of Serverless Computing

**Serverless computing** is a cloud execution model where the cloud provider (e.g., AWS) runs your code without you managing servers. You write and deploy code; the provider handles provisioning, scaling, patching, and availability. You pay only for the actual execution time of your code.

**Note:** "Serverless" does not mean there are no servers. It means you don't have to manage or think about them—the cloud provider does.

### Traditional Server-Based Architecture vs Serverless Architecture

| Aspect | Traditional (EC2, etc.) | Serverless (Lambda) |
|--------|-------------------------|---------------------|
| **Server management** | You provision, patch, and maintain servers | Provider manages everything |
| **Scaling** | You configure auto-scaling, load balancers | Automatic scaling per request |
| **Cost** | Pay for server uptime (24/7) | Pay only when code runs |
| **Deployment** | Deploy to servers, manage OS and runtime | Deploy code; provider runs it |
| **Idle time** | Pay for idle servers | No cost when no requests |
| **Capacity planning** | Estimate traffic and size instances | No capacity planning needed |

### Why Serverless is Used

- **No server management** – Focus on code, not infrastructure.
- **Automatic scaling** – Handles 1 or 1 million requests without manual setup.
- **Cost efficiency** – Pay per execution; no cost when idle.
- **Faster development** – Deploy code quickly without managing servers.
- **Event-driven** – Run code in response to events (file upload, API call, schedule).

### Benefits of Serverless Computing

| Benefit | Description |
|---------|-------------|
| **Reduced operational burden** | No servers to patch, monitor, or scale |
| **Pay-per-use** | Charges only for compute time (and requests) |
| **Automatic scaling** | Scales from zero to high concurrency automatically |
| **High availability** | Provider runs your code across multiple AZs |
| **Faster time to market** | Deploy and iterate quickly |

### Real-World Examples of Serverless Applications

| Use Case | How Serverless Helps |
|----------|----------------------|
| **Image processing** | Lambda runs when image uploaded to S3; resizes, compresses, or adds watermarks |
| **REST APIs** | API Gateway + Lambda serve API endpoints without servers |
| **Scheduled tasks** | Lambda runs on a schedule (e.g., daily reports, cleanup) |
| **Chatbots** | Lambda processes messages and returns responses |
| **Data pipelines** | Lambda processes data from S3, DynamoDB, or Kinesis |
| **Webhooks** | Lambda handles webhooks from GitHub, Stripe, etc. |
| **Form submissions** | Lambda processes form data and sends emails or stores in DB |

---

## 2. Introduction to AWS Lambda

### Definition of AWS Lambda

**AWS Lambda** is a serverless compute service that runs your code in response to events or on-demand. You upload your code; AWS runs it when triggered, scaling automatically. You pay only for the compute time consumed.

### What Type of Service Lambda is

- **Compute service** – Executes your code.
- **Serverless** – No servers to manage.
- **Event-driven** – Invoked by events (S3, API Gateway, schedule, etc.).
- **Managed** – AWS handles runtime, scaling, and availability.

### How Lambda Works

1. **You write code** – Function in a supported language (Python, Node.js, Java, etc.).
2. **You deploy** – Upload code (zip or container) or use inline editor.
3. **Event occurs** – S3 upload, API request, schedule, etc.
4. **Lambda runs** – AWS provisions an execution environment and runs your code.
5. **Response** – Your function returns a result (e.g., to API Gateway or S3).

### Key Concepts

#### Function

- A **Lambda function** is your code (a single unit of work). Each function has:
  - **Handler** – Entry point (e.g., `lambda_function.lambda_handler` in Python).
  - **Runtime** – Language and version (e.g., Python 3.12).
  - **Configuration** – Memory, timeout, environment variables.

#### Event

- An **event** is the input that triggers your function. Examples:
  - S3: Object created or deleted.
  - API Gateway: HTTP request.
  - DynamoDB: Stream record.
  - CloudWatch Events: Scheduled (e.g., every 5 minutes).

#### Execution Environment

- The **execution environment** is the isolated runtime where your code runs. AWS creates it when your function is invoked and may reuse it for subsequent invocations (warm start).

### Advantages of AWS Lambda

- **No server management** – No EC2, no SSH, no OS updates.
- **Automatic scaling** – Handles concurrent requests.
- **Pay-per-use** – Charged per request and per GB-second of compute.
- **Integrations** – Works with S3, API Gateway, DynamoDB, SNS, SQS, and many more.
- **Multiple languages** – Python, Node.js, Java, Go, Ruby, .NET, custom runtimes.

### Common Use Cases of Lambda

- **Web backends** – API Gateway + Lambda for REST APIs.
- **File processing** – S3 triggers for images, videos, documents.
- **Data processing** – ETL, stream processing, batch jobs.
- **Scheduled tasks** – Cron-like jobs (reports, cleanup).
- **Chatbots and voice assistants** – Alexa skills, chatbots.
- **Real-time notifications** – React to events and send alerts.

---

## 3. Features of AWS Lambda

### Automatic Scaling

- Lambda **scales automatically** with the number of requests.
- No configuration needed—AWS provisions more execution environments as traffic increases.
- **Concurrency limit** – Default 1000 concurrent executions per region (can be increased).
- **Scale to zero** – No cost when there are no invocations.

### Pay-Per-Use Pricing Model

- **Requests** – Charged per number of invocations (first 1M free per month).
- **Duration** – Charged per GB-second (memory × time). More memory = higher cost per second but often faster execution.
- **No charge when idle** – Unlike EC2, you pay only when code runs.

**Example:** 1 million requests, 128 MB memory, 200 ms each ≈ very low cost (often within free tier).

### Event-Driven Execution

- Lambda runs **only when triggered** by an event.
- Events come from AWS services (S3, API Gateway, DynamoDB, etc.) or custom applications.
- No polling—Lambda is invoked when the event occurs.

### Built-in Monitoring with CloudWatch

- **CloudWatch Logs** – Your function’s `print`/`console.log` output goes to CloudWatch.
- **Metrics** – Invocations, duration, errors, throttles, concurrent executions.
- **Alarms** – Set alarms on errors or throttling.
- **X-Ray** – Optional distributed tracing for debugging.

### Multiple Programming Language Support

| Language | Runtime |
|----------|---------|
| Python | 3.8, 3.9, 3.10, 3.11, 3.12 |
| Node.js | 18.x, 20.x |
| Java | 11, 17, 21 |
| Go | Custom runtime |
| Ruby | 3.2 |
| .NET | .NET 6, 8 |
| Custom | Bring your own runtime |

### High Availability

- Lambda runs your code across **multiple Availability Zones** in a region.
- AWS manages failover and redundancy.
- No single point of failure for the Lambda service itself.

---

## 4. Lambda Function Demo (Practical Understanding)

### Step 1: Create Lambda Function

1. Open **AWS Console** → **Lambda** → **Functions**.
2. Click **Create function**.
3. **Author from scratch**.
4. **Function name:** `HelloWorld` (or any name).
5. **Runtime:** Python 3.12 (or Node.js 20.x).
6. **Architecture:** x86_64.
7. Click **Create function**.

### Step 2: Select Runtime (Python / Node.js)

- **Python 3.12** – Good for data processing, integrations, scripting.
- **Node.js 20.x** – Good for web APIs, async I/O.

Choose based on your familiarity or project needs.

### Step 3: Write Simple Code Example

**Python example:**

```python
def lambda_handler(event, context):
    """
    event: Input data (e.g., from API Gateway, S3)
    context: Runtime information (request ID, remaining time, etc.)
    """
    name = event.get('name', 'World')
    return {
        'statusCode': 200,
        'body': f'Hello, {name}!'
    }
```

**Node.js example:**

```javascript
exports.handler = async (event, context) => {
    const name = event.name || 'World';
    return {
        statusCode: 200,
        body: `Hello, ${name}!`
    };
};
```

### Step 4: Deploy the Function

1. Click **Deploy** (or **Save**) in the Lambda console.
2. Your code is deployed and ready to invoke.
3. For larger projects, use zip upload or CI/CD (e.g., SAM, Serverless Framework).

### Step 5: Test the Function Using Test Events

1. Click **Test** tab.
2. **Create new event** → Name: `TestEvent`.
3. **Event JSON:**

```json
{
  "name": "AWS Learner"
}
```

4. Click **Test**.
5. View **Execution result** – e.g., `Hello, AWS Learner!`.

### Step 6: View Logs in CloudWatch

1. After a test run, open **Monitor** tab → **View CloudWatch logs**.
2. Or go to **CloudWatch** → **Log groups** → `/aws/lambda/HelloWorld`.
3. Open the latest log stream to see `print` output and execution details.

**Add logging in code:**

```python
import json

def lambda_handler(event, context):
    print("Event received:", json.dumps(event))
    name = event.get('name', 'World')
    print(f"Returning greeting for: {name}")
    return {
        'statusCode': 200,
        'body': f'Hello, {name}!'
    }
```

---

## 5. Lambda Layers

### Definition of Lambda Layer

A **Lambda Layer** is a ZIP archive that contains libraries, custom runtimes, or other dependencies. You attach layers to Lambda functions so multiple functions can share the same dependencies without packaging them in each deployment.

### Why Lambda Layers are Used

- **Reduce deployment size** – Keep function code small; put dependencies in a layer.
- **Share code** – Use the same layer across many functions.
- **Faster updates** – Update a layer once; all functions using it get the update.
- **Separation of concerns** – Code vs dependencies.

### Sharing Libraries Across Multiple Functions

- Create one layer with common libraries (e.g., `requests`, `boto3` extras).
- Attach that layer to multiple functions.
- All functions use the same libraries without duplicating them in each deployment package.

### How Layers Reduce Code Duplication

**Without layers:** Each function includes its own copy of libraries → larger packages, slower deployments.

**With layers:** Libraries live in a layer; functions reference the layer → smaller packages, shared updates.

### Example Use Case of Lambda Layer

**Scenario:** Ten Lambda functions need the `requests` library for HTTP calls.

**Without layer:** Package `requests` in each function’s zip (repeated 10 times).

**With layer:**
1. Create a layer with `requests` (and optionally other libs).
2. Attach the layer to all 10 functions.
3. Each function code stays small; `requests` is loaded from the layer.

**Layer structure (Python):**
```
python/
  requests/
    (library files)
```
Zipped and uploaded as a layer. Lambda adds `/opt/python` to `PYTHONPATH`, so `import requests` works.

---

## 6. Lambda Triggers

### What Triggers Are and How They Work

A **trigger** is an AWS resource or event that invokes your Lambda function. When the trigger event occurs, AWS runs your function and passes the event data as input.

**Flow:** Event occurs → AWS invokes Lambda → Lambda receives event → Function runs → Returns response (if applicable).

### Common Lambda Triggers

#### Amazon S3

- **Event:** Object created, deleted, or other S3 events.
- **Use case:** Process new uploads (resize images, validate files, trigger pipelines).
- **Example:** User uploads image → S3 event → Lambda processes image.

#### Amazon API Gateway

- **Event:** HTTP request (GET, POST, etc.).
- **Use case:** REST APIs, webhooks.
- **Example:** User calls `GET /users` → API Gateway → Lambda → Returns user list.

#### Amazon DynamoDB

- **Event:** DynamoDB Streams (insert, update, delete).
- **Use case:** React to data changes, sync to another store, send notifications.
- **Example:** New item in table → Stream event → Lambda processes it.

#### Amazon CloudWatch Events (EventBridge)

- **Event:** Scheduled (cron/rate) or event-based.
- **Use case:** Cron jobs, periodic reports, cleanup.
- **Example:** Every day at 2 AM → EventBridge → Lambda runs backup script.

#### Amazon SNS

- **Event:** Message published to SNS topic.
- **Use case:** Fan-out notifications, async processing.
- **Example:** Order placed → SNS → Lambda sends confirmation email.

#### Amazon SQS

- **Event:** Message in SQS queue.
- **Use case:** Decouple producers and consumers, batch processing.
- **Example:** Message in queue → Lambda processes it and deletes from queue.

### How an Event Triggers Lambda Execution

```
1. Event occurs (e.g., file uploaded to S3)
2. AWS service (S3) invokes Lambda with event payload
3. Lambda receives event in the "event" parameter
4. Your function runs and can use event data
5. Function returns (optional); some triggers use the response (e.g., API Gateway)
```

**Example S3 event structure (simplified):**
```json
{
  "Records": [
    {
      "s3": {
        "bucket": { "name": "my-bucket" },
        "object": { "key": "uploads/photo.jpg" }
      }
    }
  ]
}
```

---

## 7. Introduction to API Gateway

### Definition of Amazon API Gateway

**Amazon API Gateway** is an AWS service for creating, publishing, and managing REST and WebSocket APIs. It acts as a front door for your backend (e.g., Lambda), handling HTTP requests, authentication, throttling, and monitoring.

### Why API Gateway is Required

- **HTTP endpoints** – Lambda does not expose HTTP URLs by itself. API Gateway provides URLs like `https://abc123.execute-api.us-east-1.amazonaws.com/prod/hello`.
- **Request/response handling** – Transforms HTTP requests into Lambda events and Lambda responses into HTTP responses.
- **Authentication** – IAM, API keys, Cognito, or custom authorizers.
- **Throttling** – Rate limiting to protect backends.

### Role of API Gateway in Serverless Applications

- **Entry point** – Receives HTTP requests from clients.
- **Routing** – Maps paths and methods to Lambda functions.
- **Integration** – Invokes Lambda and passes request data.
- **Response** – Returns Lambda output as HTTP response.

### Key Features of API Gateway

| Feature | Description |
|---------|-------------|
| **REST APIs** | RESTful HTTP APIs |
| **WebSocket APIs** | Real-time two-way communication |
| **HTTP APIs** | Simpler, lower-cost HTTP APIs (Lambda, HTTP integrations) |
| **Authentication** | IAM, API keys, Cognito, custom |
| **Throttling** | Request rate and burst limits |
| **Caching** | Cache responses to reduce Lambda invocations |
| **Custom domains** | Use your own domain (e.g., api.example.com) |

### Types of APIs in API Gateway

| Type | Use Case | Cost |
|------|----------|------|
| **REST API** | Full REST features, request/response transformation | Higher |
| **HTTP API** | Simple HTTP, Lambda proxy, JWT | Lower |
| **WebSocket API** | Real-time (chat, gaming) | Per message |

---

## 8. API Gateway + Lambda Integration

### How API Gateway and Lambda Work Together

1. **User** sends HTTP request to API Gateway URL.
2. **API Gateway** receives request, validates it, and invokes Lambda.
3. **Lambda** runs and returns a response.
4. **API Gateway** converts the response to HTTP and sends it back to the user.

### Creating an API Endpoint

1. **API Gateway Console** → Create API → HTTP API (or REST API).
2. **Add integration** → Lambda.
3. **Select Lambda function** (e.g., `HelloWorld`).
4. **Define routes** – e.g., `GET /hello` → `HelloWorld`.
5. **Deploy** to a stage (e.g., `prod`).

### Connecting API Gateway with Lambda Function

- **Integration type:** Lambda function.
- **Lambda proxy integration:** Request (path, query, headers, body) is passed to Lambda as the `event` object. Lambda returns `statusCode`, `headers`, `body`.
- **Permission:** API Gateway needs permission to invoke Lambda. AWS can add this automatically when you create the integration.

### Sending HTTP Request to Trigger Lambda

**URL format:** `https://{api-id}.execute-api.{region}.amazonaws.com/{stage}/{path}`

**Example:**
```bash
curl https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod/hello
```

**With query parameter:**
```bash
curl "https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod/hello?name=Student"
```

### Receiving Response from Lambda

**Lambda response format (for API Gateway):**
```python
return {
    'statusCode': 200,
    'headers': {'Content-Type': 'application/json'},
    'body': '{"message": "Hello, World!"}'
}
```

API Gateway sends this as the HTTP response to the client.

### Simple Example: User → API Gateway → Lambda → Response

```
User (browser/Postman)
    │
    │ GET https://api.example.com/hello
    ▼
API Gateway
    │
    │ Invokes Lambda with event: { "queryStringParameters": {"name": "User"} }
    ▼
Lambda (HelloWorld function)
    │
    │ Returns: { "statusCode": 200, "body": "Hello, User!" }
    ▼
API Gateway
    │
    │ Sends HTTP 200 with body "Hello, User!"
    ▼
User receives response
```

---

## 9. Practical Demo Workflow

### Step 1: Create Lambda Function

1. Lambda Console → **Create function**.
2. Name: `ApiHelloWorld`.
3. Runtime: Python 3.12.
4. Create function.
5. Replace code with:

```python
def lambda_handler(event, context):
    name = 'World'
    if event.get('queryStringParameters') and event['queryStringParameters'].get('name'):
        name = event['queryStringParameters']['name']
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'text/plain'},
        'body': f'Hello, {name}!'
    }
```

6. **Deploy**.

### Step 2: Create API Gateway Endpoint

1. **API Gateway Console** → **Create API**.
2. Choose **HTTP API** → **Build**.
3. **Integrations** → **Add integration**.
4. **Lambda** → Select `ApiHelloWorld` → **Next**.
5. **API name:** `DemoAPI`.
6. **Configure routes:** `GET /hello` → `ApiHelloWorld` → **Next**.
7. **Stages:** `$default` or `prod` → **Next** → **Create**.

### Step 3: Connect API Gateway to Lambda

- This is done in Step 2 when you add the Lambda integration and route.
- Ensure **Lambda invoke permission** is granted (API Gateway can add it automatically).

### Step 4: Deploy API

- HTTP APIs often use `$default` stage automatically.
- For REST APIs: **Actions** → **Deploy API** → Select stage (e.g., `prod`).

### Step 5: Test API Using Browser or Postman

1. Copy the **Invoke URL** from API Gateway (e.g., `https://abc123.execute-api.us-east-1.amazonaws.com`).
2. **Browser:** Open `https://abc123.execute-api.us-east-1.amazonaws.com/hello`
3. **With parameter:** `https://abc123.execute-api.us-east-1.amazonaws.com/hello?name=Learner`
4. **Postman:** GET request to the same URL.

**Expected response:** `Hello, World!` or `Hello, Learner!`

---

## 10. Best Practices

### Keep Lambda Functions Lightweight

- **Small deployment packages** – Faster cold starts.
- **Minimal dependencies** – Use Lambda Layers for large libraries.
- **Short execution time** – Optimize code; set appropriate timeout.
- **Single responsibility** – One function, one clear purpose.

### Use Environment Variables

- Store configuration (API URLs, table names, feature flags) in **environment variables**.
- Avoid hardcoding; use Lambda configuration → Environment variables.
- For secrets, use **AWS Secrets Manager** or **Parameter Store**.

### Use Lambda Layers for Dependencies

- Put shared libraries in layers.
- Keeps function code small and deployments fast.
- Update layers independently from function code.

### Monitor Logs Using CloudWatch

- Use `print` / `console.log` for debugging; logs go to CloudWatch.
- Create **CloudWatch alarms** for errors and throttles.
- Use **CloudWatch Insights** to search and analyze logs.
- Consider **X-Ray** for tracing across services.

### Secure APIs Using Authentication

- **API keys** – Simple, for server-to-server or low-security use.
- **IAM** – For AWS service-to-service calls.
- **Cognito** – For user authentication (JWT).
- **Custom authorizer** – Lambda that validates tokens or custom logic.
- **Always use HTTPS** – Enforce TLS for all API traffic.

---

## Quick Reference

### Lambda Concepts

| Term | Meaning |
|------|---------|
| **Function** | Your code + configuration |
| **Handler** | Entry point (e.g., `lambda_handler`) |
| **Event** | Input that triggers the function |
| **Trigger** | AWS resource that invokes the function |
| **Layer** | Shared dependencies (libraries, runtimes) |

### Common Triggers

| Service | Event |
|---------|-------|
| S3 | Object created/deleted |
| API Gateway | HTTP request |
| DynamoDB | Stream record |
| EventBridge | Schedule or event |
| SNS | Message published |
| SQS | Message in queue |

### API Gateway + Lambda Flow

```
HTTP Request → API Gateway → Lambda → Response → Client
```

---

*End of Serverless Computing with AWS Lambda training notes.*
