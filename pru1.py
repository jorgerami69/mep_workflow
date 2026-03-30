import requests

BASE_URL = "http://localhost:8585/api"

r = requests.get(BASE_URL)

print(r.status_code)
print(r.text[:200])