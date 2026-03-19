# PRB IaC

Personal infrastructure-as-code templates using Terraform.

## 📦 Modules

### `aws`

Provisions an Ubuntu 24.04 EC2 dev box (`prb-agents`) with:

- SSH ingress security group
- SSM Session Manager via IAM instance profile
- Encrypted gp3 root volume (50 GB default)
- Bootstrap script that clones [dotfiles](https://github.com/PaulRBerg/dotfiles) and runs `bootstrap_ubuntu.sh`
- Auto-discovers default VPC and subnet via data sources

## 🚀 Usage

### Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.7
- [AWS CLI](https://aws.amazon.com/cli/) with a `default` profile configured (`aws configure`)
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
cd aws
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
tflint --chdir=aws
```
