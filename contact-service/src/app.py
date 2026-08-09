"""Lambda handler for the public HOLO demo-request form."""
import json
import logging
import os
import re
import smtplib
import ssl
from email.message import EmailMessage

import boto3

_secrets = boto3.client("secretsmanager")
_smtp_config = None
logger = logging.getLogger()
logger.setLevel(logging.INFO)
EMAIL_RE = re.compile(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")
MAX_LENGTHS = {
    "nombre": 160, "cargo": 160, "email": 254, "organizacion": 160,
    "modulo": 200, "mensaje": 4000, "bot-field": 0,
}
REQUIRED_FIELDS = ("nombre", "cargo", "email", "organizacion")


def origin_from_event(event):
    headers = event.get("headers") or {}
    origin = next((value for key, value in headers.items() if key.lower() == "origin"), None)
    allowed = {item.strip() for item in os.environ["ALLOWED_ORIGINS"].split(",")}
    return origin if origin in allowed else None


def response(status_code, body, origin=None):
    headers = {"content-type": "application/json"}
    if origin:
        headers.update({
            "access-control-allow-origin": origin,
            "access-control-allow-methods": "POST,OPTIONS",
            "access-control-allow-headers": "Content-Type",
            "vary": "Origin",
        })
    return {"statusCode": status_code, "headers": headers,
            "body": json.dumps(body)}


def get_smtp_config():
    global _smtp_config
    if _smtp_config is None:
        result = _secrets.get_secret_value(SecretId=os.environ["SMTP_SECRET_ARN"])
        _smtp_config = json.loads(result["SecretString"])
        required = {"host", "port", "username", "password", "from_email"}
        missing = required - _smtp_config.keys()
        if missing:
            raise ValueError("El secreto SMTP no tiene los campos requeridos")
    return _smtp_config


def validate(payload):
    if not isinstance(payload, dict):
        return "Cuerpo de solicitud invalido"
    if payload.get("bot-field"):
        return "Solicitud invalida"
    for field, limit in MAX_LENGTHS.items():
        value = payload.get(field, "")
        if not isinstance(value, str) or len(value.strip()) > limit:
            return "Solicitud invalida"
    if any(not payload.get(field, "").strip() for field in REQUIRED_FIELDS):
        return "Faltan campos obligatorios"
    if not EMAIL_RE.fullmatch(payload["email"].strip()):
        return "Correo invalido"
    return None


def lambda_handler(event, _context):
    origin = origin_from_event(event)
    if event.get("httpMethod") == "OPTIONS":
        return response(204, {}, origin)

    try:
        payload = json.loads(event.get("body") or "{}")
    except json.JSONDecodeError:
        return response(400, {"message": "JSON invalido"}, origin)

    error = validate(payload)
    if error:
        return response(400, {"message": error}, origin)

    try:
        config = get_smtp_config()
        recipients = [email.strip() for email in os.environ["RECIPIENT_EMAILS"].split(",") if email.strip()]
        if not recipients:
            raise ValueError("No hay destinatarios configurados")
        starttls = str(config.get("starttls", "true")).lower() == "true"
        if not starttls:
            raise ValueError("SMTP sin STARTTLS no esta permitido")

        message = EmailMessage()
        message["Subject"] = f'{os.environ["MAIL_SUBJECT_PREFIX"]}: {payload["nombre"].strip()}'
        message["From"] = config["from_email"]
        message["To"] = ", ".join(recipients)
        message["Reply-To"] = payload["email"].strip()
        message.set_content("\n".join([
            "Nueva solicitud de demostracion desde holo.com.co", "",
            f'Nombre: {payload["nombre"].strip()}', f'Cargo / rango: {payload["cargo"].strip()}',
            f'Correo: {payload["email"].strip()}', f'Organizacion: {payload["organizacion"].strip()}',
            f'Modulo: {payload.get("modulo", "").strip() or "No especificado"}', "",
            "Requerimiento operacional:", payload.get("mensaje", "").strip() or "No especificado",
        ]))

        with smtplib.SMTP(config["host"], int(config["port"]), timeout=10) as smtp:
            smtp.ehlo()
            smtp.starttls(context=ssl.create_default_context())
            smtp.ehlo()
            smtp.login(config["username"], config["password"])
            smtp.send_message(message)
    except Exception:
        # No revelar detalles de SMTP ni de configuracion al navegador.
        logger.exception("No fue posible enviar la solicitud de demostracion")
        return response(500, {"message": "No fue posible enviar la solicitud"}, origin)

    return response(202, {"message": "Solicitud recibida"}, origin)
