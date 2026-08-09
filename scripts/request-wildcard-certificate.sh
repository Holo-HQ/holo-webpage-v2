#!/usr/bin/env bash
set -euo pipefail

profile="${AWS_PROFILE:-holo}"
region="${AWS_REGION:-us-east-1}"
domain="holo.com.co"
wildcard="*.holo.com.co"

existing_arn="$(aws --profile "$profile" --region "$region" acm list-certificates \
  --certificate-statuses ISSUED PENDING_VALIDATION \
  --query "CertificateSummaryList[?DomainName=='${domain}'] | [0].CertificateArn" \
  --output text)"

if [[ "$existing_arn" == "None" || -z "$existing_arn" ]]; then
  existing_arn="$(aws --profile "$profile" --region "$region" acm request-certificate \
    --domain-name "$domain" \
    --subject-alternative-names "$wildcard" \
    --validation-method DNS \
    --idempotency-token holoWildcard2026 \
    --options CertificateTransparencyLoggingPreference=ENABLED \
    --query CertificateArn --output text)"
fi

echo "CertificateArn: $existing_arn"
echo "Crea en Hostinger los CNAME de validacion que se muestran a continuacion:"
aws --profile "$profile" --region "$region" acm describe-certificate \
  --certificate-arn "$existing_arn" \
  --query 'Certificate.DomainValidationOptions[].{Domain:DomainName,Name:ResourceRecord.Name,Type:ResourceRecord.Type,Value:ResourceRecord.Value,Status:ValidationStatus}' \
  --output table
