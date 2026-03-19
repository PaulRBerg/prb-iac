# PRB IaC

@README.md

## Structure

```
aws/                  # EC2 dev box module ("prb-agents")
  main.tf             # Data sources, security group, IAM role, EC2 instance
  variables.tf        # Input variables
  outputs.tf          # Instance ID, IPs, SG ID
  locals.tf           # name = "prb-agents"
  providers.tf        # AWS provider config with default tags
  terraform.tf        # Required versions
  bootstrap.sh.tftpl  # Bootstrap script (clones dotfiles, runs bootstrap_ubuntu.sh)
.tflint.hcl           # TFLint config
```

## Conventions

- Use HashiCorp style: 2-space indent, `snake_case` for all identifiers
- Section comments use `# ---` dividers
- All resources tagged via `default_tags` in provider (`ManagedBy=Terraform`, `Project=prb-agents`)
- Secrets stored in SSM Parameter Store, read via `data.aws_ssm_parameter`
- Bootstrap templates use `.sh.tftpl` extension
- VPC and subnet are discovered dynamically via `data.aws_vpc` and `data.aws_subnets` — not hardcoded

## Editing Guidelines

- `variables.tf`: keep grouped by concern (Region, Compute, Secrets) with section dividers
- Do not hardcode secrets — always reference SSM parameters
- `bootstrap.sh.tftpl` is a Terraform templatefile — use `${var}` syntax for interpolation
