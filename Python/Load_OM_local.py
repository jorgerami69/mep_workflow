import json
import os
import requests

BASE_URL = "http://localhost:8585/api/v1"
TOKEN = os.getenv("OM_TOKEN")

HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json"
}

def req(method, url, payload=None):
    r = requests.request(method, url, headers=HEADERS, json=payload)
    print(f"{method} {url} → {r.status_code}")
    if r.status_code in [200, 201]:
        return r.json()
    return None

def safe_columns(cols):
    seen = {}
    out = []

    for c in cols:
        name = c["name"]

        if name in seen:
            seen[name] += 1
            name = f"{name}_{seen[name]}"
        else:
            seen[name] = 0

        out.append({
            "name": name,
            "dataType": c.get("dataType", "STRING")
        })

    return out

def main():

    with open(r"C:\data\workspace\mep_workflow\out\TU_ARCHIVO.json") as f:
        data = json.load(f)

    service = data["service"]

    # SERVICE
    req("POST", f"{BASE_URL}/services/databaseServices", {
        "name": service,
        "serviceType": "CustomDatabase",
        "connection": {"config": {}}
    })

    for db in data["databases"]:

        db_name = db["name"]

        # DB
        req("POST", f"{BASE_URL}/databases", {
            "name": db_name,
            "service": service
        })

        for schema in db["schemas"]:

            schema_name = schema["name"]

            # SCHEMA
            req("POST", f"{BASE_URL}/databaseSchemas", {
                "name": schema_name,
                "database": f"{service}.{db_name}"
            })

            for table in schema["tables"]:

                try:
                    req("POST", f"{BASE_URL}/tables", {
                        "name": table["name"],
                        "columns": safe_columns(table["columns"]),
                        "databaseSchema": f"{service}.{db_name}.{schema_name}"
                    })
                except:
                    print("skip tabla")

if __name__ == "__main__":
    main()