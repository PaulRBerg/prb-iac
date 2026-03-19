# ──────────────────────────────────────────────────────────────────────────────
# Region
# ──────────────────────────────────────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

# ──────────────────────────────────────────────────────────────────────────────
# Compute
# ──────────────────────────────────────────────────────────────────────────────

variable "ami_id" {
  description = "Ubuntu 24.04 LTS amd64 AMI (us-east-1)"
  type        = string
  default     = "ami-0ec10929233384c7f"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "prb-agents-key"
}

variable "volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 50
}

# ──────────────────────────────────────────────────────────────────────────────
# Secrets
# ──────────────────────────────────────────────────────────────────────────────

variable "github_token_ssm_path" {
  description = "SSM Parameter Store path for the GitHub personal access token"
  type        = string
  default     = "/prb-agents/github-token"
}
