#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "--certificate-arn" || -z "${2:-}" ]]; then
  echo "Uso: $0 --certificate-arn <ARN_DE_CERTIFICADO_ACM>" >&2
  exit 2
fi

profile="${AWS_PROFILE:-holo}"
region="${AWS_REGION:-us-east-1}"
certificate_arn="$2"
domain="web2.holo.com.co"
stack_name="holo-web2-hosting"
site_bucket="holo-web2-site-121470661386-us-east-1"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_file="$(mktemp)"
trap 'rm -f "$config_file"' EXIT

stack_status="$(aws --profile "$profile" --region "$region" cloudformation describe-stacks \
  --stack-name "$stack_name" --query 'Stacks[0].StackStatus' --output text 2>/dev/null || true)"
if [[ "$stack_status" == "ROLLBACK_COMPLETE" ]]; then
  aws --profile "$profile" --region "$region" cloudformation delete-stack --stack-name "$stack_name"
  while aws --profile "$profile" --region "$region" cloudformation describe-stacks --stack-name "$stack_name" >/dev/null 2>&1; do
    sleep 5
  done
fi

certificate_status="$(aws --profile "$profile" --region "$region" acm describe-certificate \
  --certificate-arn "$certificate_arn" --query 'Certificate.Status' --output text)"
if [[ "$certificate_status" != "ISSUED" ]]; then
  echo "El certificado aun no esta emitido (estado: $certificate_status)." >&2
  exit 1
fi

api_url="$(aws --profile "$profile" --region "$region" cloudformation describe-stacks \
  --stack-name holo-contact-service \
  --query "Stacks[0].Outputs[?OutputKey=='ContactApiUrl'].OutputValue" --output text)"
if [[ -z "$api_url" || "$api_url" == "None" ]]; then
  echo "No se encontro ContactApiUrl; despliega primero holo-contact-service." >&2
  exit 1
fi

aws --profile "$profile" --region "$region" cloudformation deploy \
  --template-file "$repo_root/web-hosting/template.yaml" \
  --stack-name "$stack_name" \
  --parameter-overrides "DomainName=$domain" "CertificateArn=$certificate_arn"

distribution_id="$(aws --profile "$profile" --region "$region" cloudformation describe-stacks \
  --stack-name "$stack_name" --query "Stacks[0].Outputs[?OutputKey=='DistributionId'].OutputValue" --output text)"

aws --profile "$profile" --region "$region" s3 sync "$repo_root" "s3://$site_bucket" --delete \
  --exclude '.git/*' --exclude '.github/*' --exclude '.DS_Store' \
  --exclude 'contact-service/*' --exclude 'web-hosting/*' --exclude 'scripts/*' \
  --exclude 'infra/*' --exclude 'docs/*' --exclude '*.md' --exclude '.gitignore' \
  --exclude 'netlify.toml' --exclude 'staticwebapp.config.json' \
  --exclude 'contact-config.js' --exclude 'contact-config.example.js' \
  --cache-control 'public, max-age=0, must-revalidate'
aws --profile "$profile" --region "$region" s3 sync "$repo_root/assets" "s3://$site_bucket/assets" \
  --delete --cache-control 'public, max-age=31536000, immutable'
printf "window.HOLO_CONTACT_API_URL = '%s';\n" "$api_url" > "$config_file"
aws --profile "$profile" --region "$region" s3 cp "$config_file" "s3://$site_bucket/contact-config.js" \
  --content-type 'application/javascript' --cache-control 'public, max-age=0, must-revalidate'
aws --profile "$profile" cloudfront create-invalidation --distribution-id "$distribution_id" --paths '/*' >/dev/null

aws --profile "$profile" --region "$region" cloudformation describe-stacks \
  --stack-name "$stack_name" \
  --query "Stacks[0].Outputs[?OutputKey=='DistributionDomainName'].OutputValue" \
  --output text
