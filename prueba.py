import requests

BASE_URL = "http://localhost:8585/api"

HEADERS = {
    "Authorization": "Bearer TU_TOKEN_AQUI"
}

print("🔍 Probando conexión...")

test = requests.get(f"{BASE_URL}/services/databaseServices", headers=HEADERS)

print("STATUS:", test.status_code)
print("RESPONSE:", test.text[:300])