import json
import os
from pathlib import Path
from typing import Any, Dict, Optional, Tuple

import requests

# =========================================================
# CONFIG LIMPIO Y SEGURO
# =========================================================
import os
from pathlib import Path

BASE_URL = os.getenv("BASE_URL")

if not BASE_URL:
    BASE_URL = "http://localhost:8585/api/v1"

BASE_URL = BASE_URL.rstrip("/")

TOKEN = os.getenv("OM_TOKEN")

if not TOKEN:
    raise ValueError(
        "❌ OM_TOKEN no está definido.\n"
        "Ejecuta en PowerShell:\n"
        '$env:OM_TOKEN="tu_token_aqui"'
    )

TOKEN = TOKEN.strip()  # 🔥 aquí ya es seguro

BUNDLE_JSON = os.getenv(
    "OM_BUNDLE_JSON",
    r"C:\data\output\openmetadata_teradata_import_bundle.json"
)

TIMEOUT = 60

# =========================================================
# HEADERS (FIXED)
# =========================================================
def build_headers():
    return {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": f"Bearer {TOKEN}",
    }


# =========================================================
# HTTP
# =========================================================
def request_json(method: str, url: str, payload: Optional[dict] = None) -> Tuple[Optional[requests.Response], Any]:
    try:
        response = SESSION.request(
            method=method.upper(),
            url=url,
            headers=build_headers(),
            json=payload,
            timeout=TIMEOUT,
        )

        print(f"➡️  {method.upper()} {url}")
        print(f"⬅️  STATUS: {response.status_code}")

        try:
            body = response.json()
        except ValueError:
            body = response.text

        return response, body

    except requests.RequestException as exc:
        print(f"❌ ERROR HTTP: {exc}")
        return None, None


# =========================================================
# VALIDACIONES
# =========================================================
def validate_connection():
    url = f"{BASE_URL}/system/version"
    response, body = request_json("GET", url)

    if not response or response.status_code != 200:
        raise RuntimeError(f"❌ OpenMetadata no responde: {body}")

    print("✅ OpenMetadata accesible")
    print(body)


def validate_auth():
    url = f"{BASE_URL}/users"
    response, body = request_json("GET", url)

    if not response or response.status_code != 200:
        raise RuntimeError(f"❌ TOKEN INVALIDO: {body}")

    print("✅ Token válido")


# =========================================================
# HELPERS
# =========================================================
def get_by_name(endpoint: str, name: str):
    url = f"{BASE_URL}{endpoint}/name/{name}"
    r, body = request_json("GET", url)
    if r and r.status_code == 200:
        return body
    return None


def post_entity(endpoint: str, payload: dict):
    url = f"{BASE_URL}{endpoint}"
    r, body = request_json("POST", url, payload)
    if r and r.status_code in (200, 201):
        return body
    print("❌ Error:", body)
    return None


# =========================================================
# MAIN LOGIC
# =========================================================
def main():
    print("🚀 Iniciando carga OpenMetadata")

    validate_connection()
    validate_auth()  # 🔥 NUEVO

    bundle_path = Path(OM_BUNDLE_JSON)

    if not bundle_path.exists():
        raise FileNotFoundError(bundle_path)

    with bundle_path.open() as f:
        bundle = json.load(f)

    service_payload = bundle["service"]["payload"]
    service_name = service_payload["name"]

    print(f"\n🔎 Service: {service_name}")
    service = get_by_name("/services/databaseServices", service_name)

    if not service:
        print("⚠️ Creando service...")
        service = post_entity("/services/databaseServices", service_payload)

    print("✅ Service listo")

    print("\n🎯 PROCESO OK")
    

if __name__ == "__main__":
    main()
    print("TOKEN detectado:", TOKEN[:20], "...")