# PRB IaC

Personal Terraform IaC templates for AWS infrastructure.

## Stack

- Terraform >= 1.7
- AWS provider ~> 5.0
- TFLint with `recommended` preset + AWS ruleset (`0.38.0`)

## Structure

```
aws-ec2/              # EC2 dev box module ("prb-agents")
  main.tf             # Security group, IAM role, EC2 instance
  variables.tf        # Input variables
  outputs.tf          # Instance ID, IPs, SG ID
  locals.tf           # name = "prb-agents"
  providers.tf        # AWS provider config with default tags
  terraform.tf        # Required versions
  user-data.sh.tftpl  # Bootstrap script (packages, git creds, dotfiles)
.tflint.hcl           # TFLint config
```

## Conventions

- Use HashiCorp style: 2-space indent, `snake_case` for all identifiers
- Section comments use `# ---` dividers
- All resources tagged via `default_tags` in provider (`ManagedBy=Terraform`, `Project=prb-agents`)
- Secrets stored in SSM Parameter Store, read via `data.aws_ssm_parameter`
- User-data templates use `.sh.tftpl` extension

## Commands

```bash
# Lint
tflint --chdir=aws-ec2

# Deploy
cd aws-ec2 && terraform init && terraform apply -var key_name=<key>

# Destroy
cd aws-ec2 && terraform destroy -var key_name=<key>
```

## Editing Guidelines

- `variables.tf`: keep grouped by concern (Region, Networking, Compute, Secrets) with section dividers
- Do not hardcode secrets — always reference SSM parameters
- `user-data.sh.tftpl` is a Terraform templatefile — use `${var}` syntax for interpolation
