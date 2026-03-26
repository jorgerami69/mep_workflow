from metadata.ingestion.ometa.ometa_api import OpenMetadata
from metadata.generated.schema.security.client.openMetadataJWTClientConfig import OpenMetadataJWTClientConfig

from metadata.generated.schema.entity.services.database_service import DatabaseService
from metadata.generated.schema.api.services.createDatabaseService import CreateDatabaseServiceRequest

from metadata.generated.schema.entity.data.database import Database
from metadata.generated.schema.entity.data.table import Table

from metadata.generated.schema.type.entityReference import EntityReference
from metadata.generated.schema.type.basic import DataType

import json

# =========================
# 🔧 CONFIGURACIÓN LOCAL
# =========================

OPENMETADATA_SERVER = "http://localhost:8585/api"

JWT_TOKEN = "PEGA_AQUI_TU_TOKEN"  # 🔴 REEMPLAZAR

SERVICE_NAME = "mep_local_service"
DATABASE_NAME = "mep_database"

INPUT_JSON = "C:/data/output/qa_enriched.json"


# =========================
# 🔌 CONEXIÓN
# =========================

metadata = OpenMetadata(
    OpenMetadataJWTClientConfig(
        apiEndpoint=OPENMETADATA_SERVER,
        authProvider="openmetadata",
        securityConfig={
            "jwtToken": JWT_TOKEN
        }
    )
)

print("🔍 Probando conexión...")
print("Health:", metadata.health_check())


# =========================
# 🧱 CREAR SERVICE
# =========================

def create_service():

    service_request = CreateDatabaseServiceRequest(
        name=SERVICE_NAME,
        serviceType="Mssql",  # puedes cambiar a CustomDatabase si quieres
        connection=None
    )

    service = metadata.create_or_update(service_request)

    print(f"✔ Service listo: {SERVICE_NAME}")

    return service


# =========================
# 🗄️ CREAR DATABASE
# =========================

def create_database(service):

    database = Database(
        name=DATABASE_NAME,
        service=EntityReference(
            id=service.id,
            type="databaseService"
        )
    )

    db = metadata.create_or_update(database)

    print(f"✔ Database listo: {DATABASE_NAME}")

    return db


# =========================
# 📊 CREAR TABLAS
# =========================

def create_table(database, item):

    table_name = item.get("file_name", "unknown_table")

    columns_data = item.get("columns", [])

    columns = []

    for col in columns_data:
        columns.append({
            "name": col,
            "dataType": DataType.STRING
        })

    description = item.get("ai_analysis", {}).get("descripcion_funcional", "")

    table = Table(
        name=table_name,
        database=EntityReference(
            id=database.id,
            type="database"
        ),
        columns=columns,
        description=description
    )

    metadata.create_or_update(table)

    print(f"✔ Tabla creada: {table_name}")


# =========================
# 🚀 CARGA PRINCIPAL
# =========================

def load():

    with open(INPUT_JSON, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not data:
        print("❌ No hay datos enriquecidos")
        return

    service = create_service()
    database = create_database(service)

    for i, item in enumerate(data[:50]):  # limita para pruebas
        try:
            create_table(database, item)
        except Exception as e:
            print(f"❌ Error en tabla {i}: {e}")

    print("🚀 Carga completa a OpenMetadata")


# =========================
# ▶️ EJECUCIÓN
# =========================

if __name__ == "__main__":
    load()