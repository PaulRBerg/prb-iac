# ──────────────────────────────────────────────────────────────────────────────
# Region
# ──────────────────────────────────────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

# ──────────────────────────────────────────────────────────────────────────────
# Networking
# ──────────────────────────────────────────────────────────────────────────────

variable "subnet_id" {
  description = "Subnet in the default VPC (us-east-1a)"
  type        = string
  default     = "subnet-056574513ac9c1846"
}

variable "vpc_id" {
  description = "VPC for the security group"
  type        = string
  default     = "vpc-0dd3061076bccd5b6"
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
