# Despliegue AWS de web2 y formulario

## Recursos y límites

La región es `us-east-1` y todos los comandos usan `--profile holo`. El dominio principal existente no se modifica. El sitio de pruebas se publica únicamente en `web2.holo.com.co`.

- `holo/contact-service/smtp`: secreto SMTP existente; la Lambda es el único recurso que puede leerlo.
- `holo-contact-service`: API Gateway REST regional, Lambda y WAF rate-limit de 300 solicitudes/IP cada cinco minutos.
- `holo-web2-hosting`: bucket privado y distribución CloudFront para el sitio estático.
- `holo.com.co` + `*.holo.com.co`: un único certificado ACM público en `us-east-1`.

## Permisos para `holo-deployer`

No use una política en línea: el límite agregado de esas políticas para un usuario es 2.048 caracteres. Desde una identidad administradora, cree una política administrada por el cliente llamada `HoloWeb2Deployment` pegando el contenido de [iam/holo-deployer-policy.json](../iam/holo-deployer-policy.json), adjúntela al usuario `holo-deployer` y elimine la política en línea anterior `HoloContactDeployment`.

La política permite operar solo los dos buckets de HOLO y los roles Lambda con prefijo `holo-contact-service-`. CloudFormation, API Gateway, WAF y CloudFront requieren permisos de servicio amplios para crear recursos administrados; el usuario no recibe acceso a `secretsmanager:GetSecretValue`.

## Certificado y DNS

```bash
chmod +x scripts/*.sh
scripts/request-wildcard-certificate.sh
```

El script muestra el ARN y los CNAME de validación. Cree todos los CNAME mostrados en Hostinger y no cambie el registro de `holo.com.co`. Cuando ACM muestre `ISSUED`, continúe.

## Desplegar y publicar

```bash
scripts/deploy-contact-service.sh
scripts/deploy-web2.sh --certificate-arn <ARN_EMITIDO_POR_ACM>
```

El segundo comando devuelve el dominio de CloudFront. En Hostinger cree el CNAME `web2` hacia ese dominio, sin protocolo ni ruta. Espere la propagación DNS y valide `https://web2.holo.com.co`.

El script de publicación no sube infraestructura, documentación, secretos ni archivos de configuración de otros hosts. Genera `contact-config.js` temporalmente con la URL pública de API Gateway y lo publica con caché deshabilitada. Los HTML, CSS y configuraciones también evitan caché; los assets se publican con caché de un año y cada publicación invalida CloudFront.

## Operación

- Cambiar destinatarios o WAF: ajuste los valores de `scripts/deploy-contact-service.sh` y vuelva a ejecutarlo.
- Rotar SMTP: cambie solamente el secreto existente; no lo incluya en scripts ni parámetros.
- Errores de correo: consulte `/aws/lambda/<ContactFunctionName>` en CloudWatch.
- Bloqueos: consulte las métricas del Web ACL `holo-contact-service-rate-limit`.
- Para retirar el entorno, elimine primero el CNAME `web2`; el bucket está marcado `Retain` para evitar pérdida de contenido accidental.
