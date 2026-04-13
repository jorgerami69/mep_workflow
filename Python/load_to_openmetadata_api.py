import json
import requests

# =========================
# CONFIG
# =========================

BASE_URL = "http://localhost:8585/api/v1"

HEADERS = {
    "Authorization": "eyJraWQiOiJHYjM4OWEtOWY3Ni1nZGpzLWE5MmotMDI0MmJrOTQzNTYiLCJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJvcGVuLW1ldGFkYXRhLm9yZyIsInN1YiI6ImFkbWluIiwicm9sZXMiOlsiQWRtaW4iXSwiZW1haWwiOiJhZG1pbkBvcGVuLW1ldGFkYXRhLm9yZyIsImlzQm90IjpmYWxzZSwidG9rZW5UeXBlIjoiUEVSU09OQUxfQUNDRVNTIiwiaWF0IjoxNzc0NTYyNTI0LCJleHAiOjE3NzQ1NjYxMjR9.Pg2ngi-0zaWULilss86a3bJTHP9ODpeB1rPZrzgcz8cFVyaMbXALmaFkWhEz5XCrwvrXWeQwNDSSbahcLwHsE2VQ71b2YsYZy20jBFE6eMxzEMYbqxD6xa2T8w6EWijJFCIs92itoaT5L8Y1Ovk7L1s5GISihtkO42MAKz2Ob872xyOd_4TIIHmG5nItcKiUBtHQcGJT9KeevFgG-WJhsSvxHvfAme6MzAb3qaiSvXxTasd5jioupcqqjmZnWju2N4RUy74O6sfRwJ3bCe6y5gE0WykR-msj85HgCDoiEVuXSe2tPKiclRmGjUk4_mja9XBnTrJhJjUDn6AXXqjxLA",  # 🔐 pega tu token real
    "Content-Type": "application/json"
}

INPUT_JSON = "C:/data/output/qa_enriched.json"


# =========================
# UTIL API
# =========================

def api_request(method, url, payload=None):
    try:
        if method == "GET":
            r = requests.get(url, headers=HEADERS)

        elif method == "POST":
            r = requests.post(url, headers=HEADERS, json=payload)

        else:
            raise ValueError("Método no soportado")

        print(f"➡️ {method} {url}")
        print(f"⬅️ STATUS: {r.status_code}")

        if r.status_code not in [200, 201]:
            print("❌ ERROR RESPONSE:", r.text)
            return None

        return r.json()

    except Exception as e:
        print("❌ ERROR EN REQUEST:", str(e))
        return None


# =========================
# SERVICE
# =========================

def create_or_get_service():
    service_name = "mep_mssql_service"

    print("\n🔎 Buscando service...")

    url_get = f"{BASE_URL}/services/databaseServices/name/{service_name}"
    response = api_request("GET", url_get)

    if response:
        print("✅ Service ya existe")
        return response.get("id")

    print("⚠️ Service no existe, creándolo...")

    payload = {
        "name": service_name,
        "serviceType": "Mssql",
        "connection": {
            "config": {
                "type": "Mssql",
                "username": "fake",
                "password": "fake",
                "hostPort": "localhost:1433"
            }
        }
    }

    response = api_request(
        "POST",
        f"{BASE_URL}/services/databaseServices",
        payload
    )

    if not response:
        print("❌ No se pudo crear el service")
        return None

    print("🚀 Service creado correctamente")
    return response.get("id")


# =========================
# LOAD JSON
# =========================

def load_json():
    print("📂 Cargando JSON enriquecido...")

    try:
        with open(INPUT_JSON, "r", encoding="utf-8") as f:
            data = json.load(f)

        print("✅ JSON cargado")

        # 🔥 AQUÍ ESTÁ EL FIX CLAVE
        if isinstance(data, list):
            print(f"📊 JSON contiene {len(data)} elementos")
            if len(data) > 0:
                print("🔍 Ejemplo item:", data[0])

        elif isinstance(data, dict):
            print("📊 Keys:", list(data.keys()))

        return data

    except Exception as e:
        print("❌ Error leyendo JSON:", str(e))
        return None


# =========================
# MAIN LOAD
# =========================

def load():
    print("🚀 Iniciando carga a OpenMetadata...\n")

    data = load_json()

    # 🔥 FIX PARA LISTAS
    if not data or (isinstance(data, list) and len(data) == 0):
        print("❌ No hay datos para cargar")
        return

    service_id = create_or_get_service()

    if not service_id:
        print("❌ No se pudo obtener el service")
        return

    print(f"\n✅ Service listo con ID: {service_id}")

    print("\n🎯 Carga base completada (service OK)")
    print("📌 Siguiente paso: cargar tablas")


# =========================
# RUN
# =========================

if __name__ == "__main__":
    load()