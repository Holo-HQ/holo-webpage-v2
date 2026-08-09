#!/usr/bin/env bash
set -euo pipefail

profile="${AWS_PROFILE:-holo}"
region="${AWS_REGION:-us-east-1}"
stack_name="holo-contact-service"
artifact_bucket="holo-deployment-artifacts-121470661386-us-east-1"
secret_arn="arn:aws:secretsmanager:us-east-1:121470661386:secret:holo/contact-service/smtp-E70xNg"
origins="https://holo.com.co,https://www.holo.com.co,https://web2.holo.com.co"
recipients="andres@holo.com.co,dickinson@holo.com.co,julian@holo.com.co"
service_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../contact-service" && pwd)"
package_file="$(mktemp)"
trap 'rm -f "$package_file"' EXIT

stack_status="$(aws --profile "$profile" --region "$region" cloudformation describe-stacks \
  --stack-name "$stack_name" --query 'Stacks[0].StackStatus' --output text 2>/dev/null || true)"
if [[ "$stack_status" == "ROLLBACK_COMPLETE" ]]; then
  aws --profile "$profile" --region "$region" cloudformation delete-stack --stack-name "$stack_name"
  while aws --profile "$profile" --region "$region" cloudformation describe-stacks --stack-name "$stack_name" >/dev/null 2>&1; do
    sleep 5
  done
fi

aws --profile "$profile" --region "$region" cloudformation package \
  --template-file "$service_dir/template.yaml" \
  --s3-bucket "$artifact_bucket" \
  --output-template-file "$package_file"

aws --profile "$profile" --region "$region" cloudformation deploy \
  --template-file "$package_file" \
  --stack-name "$stack_name" \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --parameter-overrides \
    "AllowedOrigins=$origins" \
    "SmtpSecretArn=$secret_arn" \
    "RecipientEmails=$recipients" \
    WafRateLimit=300

aws --profile "$profile" --region "$region" cloudformation describe-stacks \
  --stack-name "$stack_name" \
  --query "Stacks[0].Outputs[?OutputKey=='ContactApiUrl'].OutputValue" \
  --output text
