# Self-Healing Platform (AWS Free Tier)

This project demonstrates how production systems detect failures,
log incidents, and recover automatically instead of relying on manual intervention.

## Core Idea
Systems fail. Good systems recover quickly.
This project focuses on Mean Time To Recovery (MTTR), not deployments.

## Failure Mode Implemented
- Downstream API failure (timeouts / HTTP 5xx)

## Tech Stack
- AWS Lambda
- API Gateway
- CloudWatch
- SNS
- DynamoDB

## Status
Phase 1: Failure detection and incident logging
