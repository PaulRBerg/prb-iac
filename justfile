set shell := ["bash", "-euo", "pipefail", "-c"]

# ---------------------------------------------------------------------------- #
#                                 DEPENDENCIES                                 #
# ---------------------------------------------------------------------------- #

# Terraform: https://www.terraform.io
terraform := require("terraform")

# TFLint: https://github.com/terraform-linters/tflint
tflint := require("tflint")


# ---------------------------------------------------------------------------- #
#                                   COMMANDS                                   #
# ---------------------------------------------------------------------------- #

# Show available commands
default:
    @just --list

# Initialize Terraform and TFLint
init:
    terraform -chdir=aws-ec2 init
    tflint --init

# ---------------------------------------------------------------------------- #
#                                    CHECKS                                    #
# ---------------------------------------------------------------------------- #

# Run all checks
[group("checks")]
@full-check:
    just rws fmt-check
    just rws validate
    just rws lint
    echo ""
    echo -e '{{ GREEN }}All checks passed!{{ NORMAL }}'
alias fc := full-check

# Run all fixes
[group("checks")]
@full-write:
    just rws fmt-write
    echo ""
    echo -e '{{ GREEN }}All fixes applied!{{ NORMAL }}'
alias fw := full-write

# Check Terraform formatting
[group("checks")]
@fmt-check:
    terraform fmt -check -recursive .

# Fix Terraform formatting
[group("checks")]
@fmt-write:
    terraform fmt -recursive .

# Lint Terraform files with tflint
[group("checks")]
@lint:
    tflint --chdir=aws-ec2

# Validate Terraform configuration
[group("checks")]
@validate:
    terraform -chdir=aws-ec2 validate

# ---------------------------------------------------------------------------- #
#                                   UTILITIES                                  #
# ---------------------------------------------------------------------------- #

# Private recipe to run a check with formatted output
@_run_with-status recipe:
    echo ""
    echo -e '{{ CYAN }}→ Running {{ recipe }}...{{ NORMAL }}'
    just {{ recipe }}
    echo -e '{{ GREEN }}✓ {{ recipe }} completed{{ NORMAL }}'
alias rws := _run_with-status
