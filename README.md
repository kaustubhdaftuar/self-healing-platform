# Self-Healing Serverless Platform on AWS

A production-style, Terraform-managed serverless system that automatically detects failures and heals itself using AWS-native observability and remediation patterns.

---

## Overview

This project demonstrates a real-world self-healing serverless architecture on AWS.

The system intentionally injects failures into a Lambda function using a configurable failure rate. When error thresholds are breached, CloudWatch alarms detect the issue and automatically trigger remediation logic that stabilizes the system without human intervention.

The architecture implements a complete:

Detect → Decide → Act → Verify

self-healing loop.

---

## Problem Statement

In real production systems:
- Failures are inevitable
- Manual recovery increases MTTR
- Blind automation can be dangerous

This project demonstrates how to:
- Detect failures reliably using metrics
- Trigger controlled automation
- Heal safely without infinite loops
- Preserve Infrastructure as Code as the source of truth

---

## Architecture Flow

1. API Gateway exposes an HTTP endpoint
2. Requests invoke the primary Lambda function
3. Failures are injected using a configurable FAILURE_RATE
4. CloudWatch monitors Lambda error metrics
5. When errors exceed a defined threshold:
   - A CloudWatch Alarm enters ALARM state
   - The alarm publishes an event to SNS
   - A remediation (healer) Lambda is invoked automatically
6. The healer Lambda corrects the failure condition at runtime
7. Error rates drop and the alarm transitions back to OK

---

## Self-Healing Mechanism

Self-healing is implemented using a dedicated remediation Lambda function:

- CloudWatch alarms detect unhealthy behavior
- SNS triggers the healer Lambda automatically
- The healer performs a predefined remediation action
- In this implementation, healing is achieved by dynamically setting:

  FAILURE_RATE = 0

- Error generation stops and the system stabilizes

Terraform remains the source of truth for the baseline configuration, while runtime remediation stabilizes the system during incidents. On the next Terraform apply, the baseline configuration is restored unless intentionally changed.

---

## Design Principles

- Infrastructure defined entirely using Terraform
- Runtime remediation is safe, deterministic, and reversible
- No manual console intervention required
- No infinite remediation loops
- Clear separation of detection, decision, and remediation responsibilities

---

## Technologies Used

- AWS Lambda
- Amazon API Gateway (HTTP API)
- Amazon CloudWatch (metrics, logs, alarms)
- Amazon SNS
- Terraform (Infrastructure as Code)
- Python

---

## Repository Structure
.
├── src/
│ ├── fragile_service/ # Primary Lambda with failure injection
│ │ └── app.py
│ │
│ └── healer/ # Remediation (self-healing) Lambda
│ └── app.py
│
├── deploy/
│ └── fragile/ # Terraform infrastructure
│ ├── api_gateway.tf
│ ├── alarms.tf
│ ├── backend.tf
│ ├── cloudwatch.tf
│ ├── healer.tf
│ ├── healer_iam.tf
│ ├── healer_subscription.tf
│ ├── healer_sns_permission.tf
│ ├── iam.tf
│ ├── lambda.tf
│ ├── outputs.tf
│ ├── sns.tf
│ └── variables.tf
│
└── README.md

---

## How to Observe Self-Healing

1. Deploy the infrastructure using Terraform
2. Send traffic to the API Gateway endpoint
3. Failures are injected based on FAILURE_RATE
4. CloudWatch Alarm transitions to ALARM
5. SNS triggers the healer Lambda automatically
6. The healer corrects the failure condition
7. Error metrics drop
8. The alarm transitions back to OK

No manual intervention is required once deployed.

---

## Key Takeaways

- Demonstrates real-world self-healing infrastructure patterns
- Shows safe automation driven by observability
- Preserves Infrastructure as Code integrity
- Avoids uncontrolled or recursive remediation
- Reflects production-grade DevOps and SRE practices


