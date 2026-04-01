import json
import os
from pathlib import Path
import requests

# =========================================================
# CONFIG
# =========================================================

BASE_URL = os.getenv("BASE_URL", "http://localhost:8585/api/v1").rstrip("/")
TOKEN = os.getenv("OM_TOKEN")

if not TOKEN:
    raise ValueError(
        "❌ OM_TOKEN no definido.\n"
        'PowerShell: $env:OM_TOKEN="tu_token_aqui"'
    )

JSON_PATH = os.getenv(
    "OM_JSON_PATH",
    r"C:\data\workspace\mep_workflow\out\TU_ARCHIVO.json"
)

DOMAIN_NAME = os.getenv("OM_DOMAIN", "Customer Care")
TIMEOUT = 60

# =========================================================
# UTILS
# =========================================================

def log(msg):
    print(msg)

def clean_name(name: str):
    return name.replace(" ", "_").replace("(", "").replace(")", "")

def headers():
    return {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {TOKEN.strip()}",
    }

def request_api(method, path, payload=None):
    url = f"{BASE_URL}{path}"

    try:
        r = requests.request(
            method=method,
            url=url,
            headers=headers(),
            json=payload,
            timeout=TIMEOUT
        )

        log(f"{method} {url} → {r.status_code}")

        try:
            body = r.json()
        except:
            body = r.text

        if r.status_code in (200, 201):
            return body

        log(f"❌ ERROR: {body}")
        return None

    except Exception as e:
        log(f"💥 ERROR HTTP: {e}")
        return None

# =========================================================
# VALIDACIÓN
# =========================================================

def validate():
    if not request_api("GET", "/system/version"):
        raise RuntimeError("❌ OpenMetadata no responde")

    if not request_api("GET", "/users"):
        raise RuntimeError("❌ Token inválido")

    log("✅ OpenMetadata OK")
    log("✅ Token OK")

# =========================================================
# GENERIC CREATE OR GET
# =========================================================

def get_or_create(get_path, post_path, payload):
    obj = request_api("GET", get_path)
    if obj:
        return obj

    return request_api("POST", post_path, payload)

# =========================================================
# COLUMNAS SEGURAS
# =========================================================

def build_safe_columns(columns_json):
    seen = {}
    safe_columns = []

    for col in columns_json:
        name = clean_name(col["name"])

        if name in seen:
            seen[name] += 1
            new_name = f"{name}_{seen[name]}"
            log(f"⚠️ Columna duplicada: {name} → {new_name}")
            name = new_name
        else:
            seen[name] = 0

        safe_columns.append({
            "name": name,
            "dataType": col.get("dataType", "STRING")
        })

    return safe_columns

# =========================================================
# MAIN
# =========================================================

def main():
    log("🚀 INICIANDO CARGA")

    validate()

    path = Path(JSON_PATH)

    if not path.exists():
        raise FileNotFoundError(path)

    with path.open(encoding="utf-8") as f:
        data = json.load(f)

    # =========================
    # SERVICE
    # =========================

    service_name = clean_name(data["service"])
    log(f"\n🔎 Service: {service_name}")

    service = get_or_create(
        f"/services/databaseServices/name/{service_name}",
        "/services/databaseServices",
        {
            "name": service_name,
            "serviceType": "CustomDatabase",
            "connection": {"config": {}}
        }
    )

    if not service:
        raise RuntimeError("❌ No se pudo crear service")

    service_id = service["id"]

    # =========================
    # DATABASES
    # =========================

    for db in data["databases"]:
        db_name = clean_name(db["name"])
        log(f"\n📦 DB: {db_name}")

        db_obj = get_or_create(
            f"/databases/name/{service_name}.{db_name}",
            "/databases",
            {
                "name": db_name,
                "service": service_id
            }
        )

        if not db_obj:
            log(f"❌ DB falló: {db_name}")
            continue

        db_id = db_obj["id"]

        # =========================
        # SCHEMAS
        # =========================

        for schema in db["schemas"]:
            schema_name = clean_name(schema["name"])
            log(f"📁 Schema: {schema_name}")

            schema_obj = get_or_create(
                f"/databaseSchemas/name/{service_name}.{db_name}.{schema_name}",
                "/databaseSchemas",
                {
                    "name": schema_name,
                    "database": db_id
                }
            )

            if not schema_obj:
                log(f"❌ Schema falló: {schema_name}")
                continue

            schema_fqn = schema_obj["fullyQualifiedName"]

            # =========================
            # TABLES
            # =========================

            for table in schema["tables"]:
                table_name = clean_name(table["name"])
                log(f"🧾 Tabla: {table_name}")

                try:
                    columns = build_safe_columns(table["columns"])

                    payload = {
                        "name": table_name,
                        "columns": columns,
                        "databaseSchema": schema_fqn
                    }

                    table_obj = request_api("POST", "/tables", payload)

                    if not table_obj:
                        log(f"❌ Falló tabla: {table_name}")
                        continue

                    # Assign domain
                    request_api(
                        "PATCH",
                        f"/tables/{table_obj['id']}",
                        {"domains": [{"name": DOMAIN_NAME}]}
                    )

                    log(f"✅ OK tabla: {table_name}")

                except Exception as e:
                    log(f"💥 ERROR tabla {table_name}: {e}")
                    continue

    log("\n🎯 CARGA COMPLETA (con tolerancia a errores) 🚀")

# =========================================================

if __name__ == "__main__":
    main()