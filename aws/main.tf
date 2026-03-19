# =============================================================================
# Deployment
# =============================================================================
#
#   # 1. Store secrets in SSM (one-time)
#   aws ssm put-parameter --name /prb-agents/github-token --type SecureString --value "ghp_..."
#
#   # 2. Deploy
#   terraform init && terraform apply -var key_name=ssh
#
#   # 3. Check UserData progress
#   ssh ubuntu@<ip> tail -f /var/log/user-data.log
#

# -----------------------------------------------------------------------------
# Data Sources — default VPC + subnet
# -----------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["${var.aws_region}a"]
  }
}

# -----------------------------------------------------------------------------
# Data Sources — SSM secrets
# -----------------------------------------------------------------------------

data "aws_ssm_parameter" "github_token" {
  name            = var.github_token_ssm_path
  with_decryption = true
}

# -----------------------------------------------------------------------------
# Security Group — existing SSH ingress SG
# -----------------------------------------------------------------------------

data "aws_security_group" "main" {
  id = var.security_group_id
}

# -----------------------------------------------------------------------------
# IAM — existing instance profile with SSM access
# -----------------------------------------------------------------------------

data "aws_iam_instance_profile" "instance" {
  name = var.instance_profile_name
}

# -----------------------------------------------------------------------------
# EC2 Instance — Ubuntu 24.04 dev box
# -----------------------------------------------------------------------------

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [data.aws_security_group.main.id]
  iam_instance_profile   = data.aws_iam_instance_profile.instance.name

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = base64encode(templatefile("${path.module}/bootstrap.sh.tftpl", {
    github_token = data.aws_ssm_parameter.github_token.value
  }))

  tags = {
    Name = local.name
  }
}
