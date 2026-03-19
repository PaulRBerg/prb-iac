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
# Networking
# ──────────────────────────────────────────────────────────────────────────────

# https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#SecurityGroup:groupId=sg-0fbba805c4291f497
variable "security_group_id" {
  description = "ID of an existing security group to attach to the instance"
  type        = string
  default     = "sg-0fbba805c4291f497"
}

# https://us-east-1.console.aws.amazon.com/iam/home#/roles/details/SSMAccessRole
variable "instance_profile_name" {
  description = "Name of an existing IAM instance profile with SSM access"
  type        = string
  default     = "SSMAccessRole"
}

# ──────────────────────────────────────────────────────────────────────────────
# Secrets
# ──────────────────────────────────────────────────────────────────────────────

variable "github_token_ssm_path" {
  description = "SSM Parameter Store path for the GitHub personal access token"
  type        = string
  default     = "/prb-agents/github-token"
}
