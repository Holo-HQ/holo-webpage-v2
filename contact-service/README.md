# Formulario de contacto en AWS

Este servicio reemplaza Netlify Forms por una API REST regional de API Gateway, AWS WAF y una Lambda. La Lambda obtiene sus credenciales SMTP desde AWS Secrets Manager y envía la solicitud a una lista de destinatarios. Las credenciales no se incluyen en el repositorio, en parámetros de CloudFormation ni en el navegador. La guía completa de hosting, permisos, certificado y DNS está en [docs/aws-deployment.md](../docs/aws-deployment.md).

## Prerrequisitos

- AWS CLI instalado.
- Perfil AWS local llamado `holo`, con permisos para CloudFormation, Lambda, API Gateway, IAM, CloudWatch Logs, X-Ray, Secrets Manager y S3 para los artefactos de despliegue.
- Datos SMTP de salida: host, puerto, usuario, contraseña, email remitente y si usa STARTTLS.

Todos los comandos siguientes usan explícitamente `--profile holo`. Seleccione una región antes de iniciar; los ejemplos usan `us-east-1`.

## Acceso de despliegue (IAM)

No use la cuenta raíz para desplegar. Antes de crear el usuario, cree en S3 el bucket privado `holo-deployment-artifacts-121470661386-us-east-1`: región `us-east-1`, **Block all public access** activado, versionado activado y cifrado por defecto activado. No tendrá contenido público ni contendrá datos de usuarios.

Después, desde la cuenta raíz, cree en **IAM → Users → Create user** el usuario `holo-deployer`, sin acceso a la consola. Después de crearlo, abra **Security credentials → Access keys → Create access key → Command Line Interface (CLI)** y guarde el `Access key ID` y el `Secret access key` en un gestor de contraseñas. El secreto de la clave solo se muestra una vez.

Adjunte una política en línea llamada `HoloContactDeployment`. Antes de pegarla, reemplace `HOLO_ARTIFACT_BUCKET` por `holo-deployment-artifacts-121470661386-us-east-1`. Esta política permite desplegar únicamente el stack y los roles/funciones con el prefijo `holo-contact-service`; no permite leer el valor del secreto SMTP.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ManageContactStack",
      "Effect": "Allow",
      "Action": [
        "cloudformation:CreateStack",
        "cloudformation:UpdateStack",
        "cloudformation:DeleteStack",
        "cloudformation:CreateChangeSet",
        "cloudformation:ExecuteChangeSet",
        "cloudformation:DeleteChangeSet",
        "cloudformation:Describe*",
        "cloudformation:GetTemplate",
        "cloudformation:ValidateTemplate"
      ],
      "Resource": "*"
    },
    {
      "Sid": "PackageLambdaArtifacts",
      "Effect": "Allow",
      "Action": ["s3:GetBucketLocation", "s3:ListBucket"],
      "Resource": "arn:aws:s3:::HOLO_ARTIFACT_BUCKET"
    },
    {
      "Sid": "ManageLambdaArtifacts",
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "arn:aws:s3:::HOLO_ARTIFACT_BUCKET/*"
    },
    {
      "Sid": "ManageStackRolesOnly",
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole", "iam:DeleteRole", "iam:GetRole", "iam:PassRole",
        "iam:TagRole", "iam:UntagRole", "iam:PutRolePolicy", "iam:GetRolePolicy",
        "iam:DeleteRolePolicy", "iam:AttachRolePolicy", "iam:DetachRolePolicy"
      ],
      "Resource": "arn:aws:iam::121470661386:role/holo-contact-service-*"
    },
    {
      "Sid": "ManageContactLambdaOnly",
      "Effect": "Allow",
      "Action": "lambda:*",
      "Resource": "arn:aws:lambda:us-east-1:121470661386:function:holo-contact-service-*"
    },
    {
      "Sid": "ManageContactApiOnly",
      "Effect": "Allow",
      "Action": "apigateway:*",
      "Resource": [
        "arn:aws:apigateway:us-east-1::/apis/*",
        "arn:aws:apigateway:us-east-1::/tags/*"
      ]
    },
    {
      "Sid": "ManageContactLogsOnly",
      "Effect": "Allow",
      "Action": "logs:*",
      "Resource": "arn:aws:logs:us-east-1:121470661386:log-group:/aws/lambda/holo-contact-service-*"
    },
    {
      "Sid": "WriteTracingData",
      "Effect": "Allow",
      "Action": ["xray:PutTraceSegments", "xray:PutTelemetryRecords"],
      "Resource": "*"
    }
  ]
}
```

Configure las claves localmente sin exponerlas en el repositorio:

```bash
aws configure --profile holo
aws --profile holo sts get-caller-identity
```

La segunda orden debe mostrar un ARN de `user/holo-deployer`, no de `root`. El perfil actual basado en raíz puede conservarse temporalmente con otro nombre hasta completar la comprobación.

## 1. Crear el secreto SMTP

No pegue la contraseña en la terminal, el repositorio ni el archivo de parámetros. Cree el secreto en la consola de AWS Secrets Manager con tipo **Other type of secret** y un JSON con esta estructura:

```json
{
  "host": "smtp.proveedor.com",
  "port": 587,
  "username": "usuario-smtp",
  "password": "CONTRASENA_SMTP",
  "from_email": "contacto@holo.com.co",
  "starttls": true
}
```

Anote el ARN del secreto. Para SMTPS implícito (usualmente puerto 465), esta primera versión requiere un ajuste pequeño en `src/app.py`; no configure `starttls: false` como sustituto porque el canal no quedaría cifrado.

## 2. Desplegar con AWS CLI

SAM no es necesario. Se requiere un bucket S3 existente para que CloudFormation almacene el paquete de la Lambda. Use un bucket privado de artefactos; no aloje allí el sitio ni información de usuarios. En los comandos, sustituya `HOLO_ARTIFACT_BUCKET` por su nombre real.

Desde `contact-service/`, empaquete y despliegue:

```bash
aws cloudformation package \
  --template-file template.yaml \
  --s3-bucket HOLO_ARTIFACT_BUCKET \
  --output-template-file packaged.yaml \
  --profile holo \
  --region us-east-1

aws cloudformation deploy \
  --template-file packaged.yaml \
  --stack-name holo-contact-service \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --parameter-overrides \
    AllowedOrigins=https://holo.com.co,https://www.holo.com.co,https://web2.holo.com.co \
    SmtpSecretArn=ARN_DEL_SECRETO \
    RecipientEmails=andres@holo.com.co,dickinson@holo.com.co,julian@holo.com.co \
  --profile holo \
  --region us-east-1
```

Obtenga la URL después del despliegue:

```bash
aws cloudformation describe-stacks \
  --stack-name holo-contact-service \
  --query "Stacks[0].Outputs[?OutputKey=='ContactApiUrl'].OutputValue" \
  --output text \
  --profile holo \
  --region us-east-1
```

Copie [contact-config.example.js](../contact-config.example.js) sobre `contact-config.js`, reemplace la URL de ejemplo por ese output y publique el sitio estático. `contact-config.js` contiene únicamente una URL pública.

## Operación y administración

- Cambiar destinatarios: repita los dos comandos de despliegue y actualice `RecipientEmails`. No requiere cambio de código.
- Rotar credenciales SMTP: actualice el valor del mismo secreto. La Lambda lo reutiliza mientras está caliente; un nuevo contenedor leerá el valor actualizado. Para aplicarlo de inmediato, despliegue de nuevo o espere un nuevo inicio de Lambda.
- Consultar errores: CloudWatch Logs, grupo `/aws/lambda/<ContactFunctionName>`. Las respuestas al navegador no revelan información del proveedor SMTP.
- Ver trazas: X-Ray está habilitado en la función.
- Cambiar dominio: actualice `AllowedOrigins`, vuelva a desplegar y publique la nueva URL/configuración si cambia la API.

## Seguridad y límites

La API acepta solo `POST /contact`, restringe CORS al origen configurado, valida tamaños/campos y descarta el honeypot existente. AWS WAF limita por defecto a 300 solicitudes por IP cada cinco minutos. No se guardan las solicitudes en AWS; el contenido viaja a los destinatarios por SMTP.

## Prueba operativa

Después de publicar `contact-config.js`, envíe una solicitud desde el dominio autorizado y confirme tanto el mensaje de éxito como la llegada del correo. Si falla, consulte CloudWatch; las causas más comunes son host/puerto bloqueado, credenciales SMTP o una dirección remitente no autorizada por el proveedor.
