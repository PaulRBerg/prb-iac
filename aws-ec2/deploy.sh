#!/usr/bin/env bash
set -euo pipefail

STACK_NAME="prb-agents"
PREREQS_STACK_NAME="prb-agents-prereqs"
KEY_NAME="${1:-ssh}"
REGION="us-east-1"
DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Deploy prereqs (idempotent) ---
echo ">>> Deploying prereqs stack: $PREREQS_STACK_NAME"
aws cloudformation deploy \
  --capabilities CAPABILITY_NAMED_IAM \
  --stack-name "$PREREQS_STACK_NAME" \
  --no-fail-on-empty-changeset \
  --region "$REGION" \
  --template-file "$DIR/prereqs.yaml"

# --- Deploy instance ---
echo ">>> Deploying instance stack: $STACK_NAME"
aws cloudformation deploy \
  --no-fail-on-empty-changeset \
  --parameter-overrides "KeyName=$KEY_NAME" \
  --region "$REGION" \
  --stack-name "$STACK_NAME" \
  --template-file "$DIR/template.yaml"

# --- Show outputs ---
echo ">>> Stack outputs:"
aws cloudformation describe-stacks \
  --output table \
  --query "Stacks[0].Outputs" \
  --region "$REGION" \
  --stack-name "$STACK_NAME"
