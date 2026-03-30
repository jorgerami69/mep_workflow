import requests

BASE_URL = "http://localhost:8585/api/v1"

HEADERS = {
    "Authorization": "Bearer TU_TOKEN_AQUI",
    "Content-Type": "application/json"
}

print("🔍 Probando endpoint...")

r = requests.get(f"{BASE_URL}/services/databaseServices", headers=HEADERS)

print("STATUS:", r.status_code)
print("RESPONSE:", r.text[:300])