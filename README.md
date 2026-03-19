# PRB IaC

Personal infrastructure-as-code templates using Terraform.

## 📦 Modules

### `aws-ec2`

Provisions an Ubuntu 24.04 EC2 dev box (`prb-agents`) with:

- SSH ingress security group
- SSM Session Manager via IAM instance profile
- Encrypted gp3 root volume (50 GB default)
- User-data bootstrap: system packages, git credentials, [dotfiles](https://github.com/PaulRBerg/dotfiles) via chezmoi

## 🚀 Usage

### Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.7
- AWS CLI configured with appropriate credentials
- An SSH key pair in your target region

### Store Secrets

```bash
aws ssm put-parameter \
  --name /prb-agents/github-token \
  --type SecureString \
  --value "ghp_..."
```

### Deploy

```bash
cd aws-ec2
terraform init
terraform apply -var key_name=<your-key-pair>
```

### Connect

```bash
ssh ubuntu@$(terraform output -raw public_ip)
```

### Monitor Bootstrap

```bash
ssh ubuntu@<ip> tail -f /var/log/user-data.log
```

## 🔧 Variables

| Variable                | Description                                 | Default                       |
| ----------------------- | ------------------------------------------- | ----------------------------- |
| `aws_region`            | AWS region                                  | `us-east-1`                   |
| `instance_type`         | EC2 instance type                           | `t3.large`                    |
| `volume_size`           | Root EBS volume size (GB)                   | `50`                          |
| `key_name`              | SSH key pair name                           | **required**                  |
| `ami_id`                | Ubuntu 24.04 LTS AMI                        | `ami-0ec10929233384c7f`       |
| `subnet_id`             | Subnet in the default VPC                   | `subnet-056574513ac9c1846`    |
| `vpc_id`                | VPC for the security group                  | `vpc-0dd3061076bccd5b6`       |
| `github_token_ssm_path` | SSM path for GitHub PAT                    | `/prb-agents/github-token`    |

## 📤 Outputs

| Output              | Description               |
| ------------------- | ------------------------- |
| `instance_id`       | EC2 instance ID           |
| `public_ip`         | Public IP (SSH target)    |
| `private_ip`        | Private IP address        |
| `security_group_id` | Security group ID         |

## 🧹 Linting

[TFLint](https://github.com/terraform-linters/tflint) is configured with the `recommended` preset and the [AWS ruleset](https://github.com/terraform-linters/tflint-ruleset-aws):

```bash
tflint --chdir=aws-ec2
```
