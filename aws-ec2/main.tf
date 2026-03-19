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
# Data Sources — SSM secrets
# -----------------------------------------------------------------------------

data "aws_ssm_parameter" "github_token" {
  name            = var.github_token_ssm_path
  with_decryption = true
}

# -----------------------------------------------------------------------------
# Security Group — SSH ingress
# -----------------------------------------------------------------------------

resource "aws_security_group" "main" {
  name        = "${local.name}-sg"
  description = "${local.name} — SSH ingress"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.main.id
  description       = "SSH"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# -----------------------------------------------------------------------------
# IAM Role + Instance Profile — SSM Session Manager access
# -----------------------------------------------------------------------------

resource "aws_iam_role" "instance" {
  name = "${local.name}-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance" {
  name = "${local.name}-instance-profile"
  role = aws_iam_role.instance.name
}

# -----------------------------------------------------------------------------
# EC2 Instance — Ubuntu 24.04 dev box
# -----------------------------------------------------------------------------

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.instance.name

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", {
    github_token = data.aws_ssm_parameter.github_token.value
  }))

  tags = {
    Name = local.name
  }
}
