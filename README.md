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

## Important Note on Docker

This repository also contains Docker configuration files and a containerized deployment example.

The Docker-based setup is separate from the Lambda-based self-healing architecture described in this document.

- The self-healing serverless platform uses ZIP-based Lambda deployments.
- Docker images are not used in the Lambda runtime.
- The container configuration exists to demonstrate an alternative ECS-based deployment model.

The two approaches represent different compute patterns:
- Serverless (Lambda + API Gateway)
- Container-based (Docker + ECS)

The self-healing logic described in this README applies specifically to the serverless implementation.

---

## Problem Statement

In real production systems:

- Failures are inevitable
- Manual recovery increases MTTR
- Blind automation can introduce instability

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

Self-healing is implemented using a dedicated remediation Lambda function.

- CloudWatch alarms detect unhealthy behavior
- SNS triggers the healer Lambda automatically
- The healer performs a predefined remediation action
- Healing is achieved by dynamically setting:

  FAILURE_RATE = 0

- Error generation stops and the system stabilizes

Terraform remains the source of truth for baseline configuration. Runtime remediation stabilizes the system during incidents, while the next Terraform apply restores the defined configuration unless intentionally modified.

---

## Design Principles

- Infrastructure defined entirely using Terraform
- Runtime remediation is safe, deterministic, and reversible
- No manual console intervention required
- No infinite remediation loops
- Clear separation of detection, decision, and remediation responsibilities
- Observability drives automation

---

## Technologies Used

- AWS Lambda (ZIP-based deployment)
- Amazon API Gateway (HTTP API)
- Amazon CloudWatch (metrics, logs, alarms)
- Amazon SNS
- Terraform (Infrastructure as Code)
- Python
- Docker (separate containerized deployment demonstration)

---

## Repository Structure

- src/
  - fragile_service/
    - app.py
  - healer/
    - app.py

- deploy/
  - fragile/
    - api_gateway.tf
    - alarms.tf
    - backend.tf
    - cloudwatch.tf
    - healer.tf
    - healer_iam.tf
    - healer_subscription.tf
    - healer_sns_permission.tf
    - iam.tf
    - lambda.tf
    - outputs.tf
    - sns.tf
    - variables.tf

- container-service/
  - Dockerfile
  - (ECS-based container deployment files)

- README.md

---

## Deployment Instructions

Prerequisites:

- AWS CLI configured
- Terraform installed
- Appropriate IAM permissions for Lambda, API Gateway, SNS, and CloudWatch

Steps:

1. Navigate to the Terraform directory:

   cd deploy/fragile

2. Initialize Terraform:

   terraform init

3. Review the execution plan:

   terraform plan

4. Apply the infrastructure:

   terraform apply

5. After deployment, retrieve the API endpoint from Terraform outputs.

---

## How to Observe Self-Healing

1. Send traffic to the API Gateway endpoint
2. Failures are injected based on FAILURE_RATE
3. CloudWatch Alarm transitions to ALARM
4. SNS triggers the healer Lambda automatically
5. The healer corrects the failure condition
6. Error metrics drop
7. The alarm transitions back to OK

No manual intervention is required once deployed.

---

## Example Self-Healing Scenario

- FAILURE_RATE is set to 0.3
- Increased traffic causes elevated error rates
- CloudWatch Alarm threshold is breached
- Alarm publishes to SNS
- Healer Lambda sets FAILURE_RATE = 0
- Errors stop
- System stabilizes
- Alarm returns to OK

---

## Key Takeaways

- Demonstrates real-world self-healing infrastructure patterns
- Shows safe automation driven by observability
- Preserves Infrastructure as Code integrity
- Avoids uncontrolled or recursive remediation
- Reflects production-grade DevOps and SRE practices
- Demonstrates both serverless and container-based compute patterns



