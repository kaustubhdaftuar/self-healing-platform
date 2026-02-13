#  Self-Healing Serverless Platform on AWS

A production-style, Terraform-managed serverless system that automatically detects failures and heals itself using AWS-native observability and automated remediation patterns.

This repository demonstrates both:

- **Primary Architecture:** Serverless self-healing using Lambda
- **Alternative Model:** Container-based deployment (ECS + Docker)

The core focus is the **self-healing Lambda architecture**.

---

#  Overview

This project implements a real-world self-healing cloud architecture using AWS services and Infrastructure as Code (Terraform).

The system intentionally injects failures into a Lambda function using a configurable `FAILURE_RATE`. When error thresholds are breached, CloudWatch alarms detect the issue and automatically trigger remediation logic that stabilizes the system without human intervention.

The architecture implements a complete:

Detect → Decide → Act → Verify

self-healing loop.

Additionally, the project includes a fully automated CI/CD pipeline using GitHub Actions to validate and deploy infrastructure changes.

---

#  Architecture (Serverless Self-Healing Flow)

```
Client
   │
   ▼
┌──────────────────────────────┐
│        API Gateway           │
│  (Public HTTP Endpoint)      │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│  Primary Lambda (Fragile)    │
│                              │
│  - Handles request           │
│  - Injects failure based     │
│    on FAILURE_RATE           │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│      CloudWatch Metrics      │
│   (Lambda Errors Monitored)  │
└───────────────┬──────────────┘
                │ Threshold Breached
                ▼
┌──────────────────────────────┐
│      CloudWatch Alarm        │
│        State = ALARM         │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│            SNS               │
│  (Alarm Notification Topic)  │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│     Healer Lambda            │
│                              │
│  - Performs remediation      │
│  - Sets FAILURE_RATE = 0     │
│  - Restores stability        │
└──────────────────────────────┘
```

---

#  Self-Healing Flow

1. API Gateway exposes an HTTP endpoint  
2. Requests invoke the primary Lambda function  
3. Failures are injected using configurable `FAILURE_RATE`  
4. CloudWatch monitors Lambda error metrics  
5. When errors exceed a defined threshold:
   - CloudWatch Alarm enters **ALARM** state  
6. The alarm publishes an event to SNS  
7. SNS triggers the healer Lambda automatically  
8. The healer Lambda corrects the failure condition at runtime  
9. Error rates drop  
10. The alarm transitions back to **OK**

No manual intervention is required once deployed.

---

#  Self-Healing Mechanism

Self-healing is implemented using a dedicated remediation Lambda function.

CloudWatch detects unhealthy behavior.  
SNS triggers the healer automatically.  
The healer performs deterministic remediation.

Healing is achieved by dynamically setting:

```
FAILURE_RATE = 0
```

Error generation stops and the system stabilizes.

---

##  Runtime vs Terraform State

Terraform remains the **source of truth** for baseline configuration.

- Runtime remediation stabilizes the system during incidents.
- The next `terraform apply` restores the defined configuration unless intentionally modified.

This preserves Infrastructure-as-Code integrity while enabling safe runtime healing.

---

#  CI/CD Pipeline (GitHub Actions)

This project includes a fully automated CI and CD workflow.

---

## Continuous Integration (CI)

Triggered on pull requests and pushes:

- Set up Python
- Install dependencies
- Validate Lambda code
- `terraform fmt`
- `terraform validate`

Ensures infrastructure and application correctness before deployment.

---

## Continuous Deployment (CD)

Triggered on push to `main`:

- Configure AWS credentials securely
- `terraform init`
- `terraform apply`
- Automatically update infrastructure and Lambda configuration

Ensures reproducible and consistent infrastructure deployments.

---

#  Important Note on Docker

This repository also contains Docker configuration files and a containerized deployment example.

The Docker-based setup is separate from the Lambda-based self-healing architecture described here.

Key distinctions:

Serverless Model:
- Lambda (ZIP deployment)
- API Gateway
- Event-driven remediation

Container Model:
- Docker image
- ECS-based deployment
- Separate compute paradigm

The self-healing logic described in this README applies specifically to the **serverless implementation**.

---

#  Design Principles

- Infrastructure fully defined using Terraform
- Runtime remediation is safe, deterministic, and reversible
- Observability-driven automation
- No manual console intervention required
- No infinite remediation loops
- Clear separation of detection, decision, and remediation
- CI/CD-enforced infrastructure consistency
- Reproducible cloud architecture

---

#  Technologies Used

- AWS Lambda (ZIP-based deployment)
- Amazon API Gateway (HTTP API)
- Amazon CloudWatch (metrics, logs, alarms)
- Amazon SNS
- Terraform (Infrastructure as Code)
- GitHub Actions (CI/CD)
- Python
- Docker (container-based deployment demonstration)

---

#  Repository Structure

```
src/
  fragile_service/
    app.py
  healer/
    app.py

deploy/
  fragile/
    api_gateway.tf
    alarms.tf
    backend.tf
    cloudwatch.tf
    healer.tf
    healer_iam.tf
    healer_subscription.tf
    healer_sns_permission.tf
    iam.tf
    lambda.tf
    outputs.tf
    sns.tf
    variables.tf

.github/workflows/
  ci.yml
  cd.yml

container-service/
  Dockerfile   (ECS-based example)

docs/
  architecture.md
  decisions.md
  failure-mode-1.md

README.md
```

---

#  How to Observe Self-Healing

1. Send traffic to the API Gateway endpoint  
2. Failures are injected based on `FAILURE_RATE`  
3. CloudWatch Alarm transitions to **ALARM**  
4. SNS triggers the healer Lambda  
5. Healer corrects the failure condition  
6. Error metrics drop  
7. Alarm transitions back to **OK**

---

#  Example Failure Scenario

- `FAILURE_RATE = 0.3`
- Increased traffic elevates error rate
- CloudWatch threshold is breached
- Alarm publishes to SNS
- Healer Lambda sets `FAILURE_RATE = 0`
- Errors stop
- System stabilizes
- Alarm returns to OK

---

#  Key Takeaways

- Demonstrates real-world self-healing infrastructure patterns
- Shows safe automation driven by observability
- Preserves Infrastructure-as-Code integrity
- Implements CI/CD for automated validation and deployment
- Avoids uncontrolled or recursive remediation
- Demonstrates both serverless and container-based compute models
- Reflects production-grade DevOps and SRE practices

---





