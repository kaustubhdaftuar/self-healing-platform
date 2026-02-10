# Self-Healing Serverless Platform (DevOps Project)

A production-style serverless system built on AWS and hardened using DevOps and SRE best practices.  
This project demonstrates how to design, break, observe, automate, and reproduce a system using Infrastructure as Code.

---

## What This Project Is

This project exposes a simple HTTP API backed by AWS Lambda.  
The system intentionally supports failure and latency injection to validate monitoring, alerting, and recovery behavior.

The system was:
1. Built manually to understand AWS service interactions
2. Migrated to Terraform to make the infrastructure reproducible
3. Tested using controlled chaos (error and latency injection)

---

## Architecture

Client → API Gateway (HTTP API) → Lambda (Python) → CloudWatch

AWS Services Used:
- AWS Lambda (Python 3.10)
- API Gateway (HTTP API)
- CloudWatch Logs and Metrics
- IAM (least-privilege roles)
- Terraform (Infrastructure as Code)

---

## Key DevOps Features

- Infrastructure as Code  
  Lambda, API Gateway, IAM roles, routes, and permissions are fully defined in Terraform.  
  The entire system can be recreated with a single `terraform apply`.

- Failure Injection  
  Controlled via the `FAILURE_RATE` environment variable to simulate downstream failures and timeouts.

- Observability-First Design  
  Errors, error rate, and latency are treated as primary health signals and used to validate system behavior.

- Reproducible and Auditable  
  No manual AWS console dependency.  
  All infrastructure changes are version-controlled in Git.

---

## Repository Structure
'''text
.
├── src/                    # Application source code
├── deploy/
│   └── fragile/            # Terraform IaC (self-healing / chaos environment)
│       ├── main.tf
│       ├── variables.tf
│       ├── iam.tf
│       ├── lambda.tf
│       ├── api_gateway.tf
│       ├── outputs.tf
│       ├── app.py
│       └── function.zip
├── docs/
└── README.md

Note: Git does not track empty directories, so `deploy/` acts as a container for Terraform environments.

---

## Infrastructure Setup (Terraform)

Prerequisites:
- AWS CLI configured locally
- Terraform version 1.4 or higher

Deploy infrastructure:
cd deploy/fragile
terraform init
terraform plan
terraform apply

Retrieve API endpoint:
terraform output -raw api_url

---

## Failure Injection and Testing

The Lambda supports intentional failure injection using an environment variable:

FAILURE_RATE = 0   → Normal operation  
FAILURE_RATE = 1   → 100% failure

Test the API:
curl <api_url>

Expected behavior:
- FAILURE_RATE = 0 → 200 OK
- FAILURE_RATE = 1 → 500 Internal Server Error

This was used to validate error metrics, error-rate behavior, alerting, and system recovery.

---

## DevOps and SRE Concepts Demonstrated

- Infrastructure as Code (Terraform)
- Configuration over code (12-factor principles)
- Failure injection and chaos testing
- Observability-driven operations
- Least-privilege IAM
- Reproducible environments
- Proper Git hygiene (no Terraform state committed)

---

## What This Project Demonstrates

- Ability to design a serverless system
- Ability to operate and monitor it
- Ability to codify infrastructure
- Ability to reason about failure and recovery

This mirrors how real DevOps and SRE teams evolve production systems.

---

## Future Enhancements

- GitHub Actions CI/CD pipeline
- Multiple environments (dev and prod)
- Terraform-managed CloudWatch alarms and dashboards
- Incident response runbooks
- Automated chaos testing

---

## Author

Kaustubh Daftuar  
DevOps / Cloud / SRE-focused project


