variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "self-healing-platform"
}

variable "failure_rate" {
  description = "Failure rate for chaos testing"
  type        = number
  default     = 0.3
}

variable "use_artifacts" {
  description = "Whether to use prebuilt lambda artifacts (CD only)"
  type        = bool
  default     = false
}
