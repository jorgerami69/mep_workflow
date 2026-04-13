import teradatasql
import pandas as pd
import json

# ==========================================
# CONFIGURACIÓN
# ==========================================
HOST = "tu_host_teradata_INTEGRATEL"
USER = "usuario_PRIV_dba"
PASSWORD = "revisar acceso""

# ==========================================
# CONEXIÓN
# ==========================================
conn = teradatasql.connect(
    host=HOST,
    user=USER,
    password=PASSWORD
)

# ==========================================
# QUERIES
# ==========================================
queries = {
    "schemas": """
        SELECT DatabaseName, OwnerName, CreateTimeStamp
        FROM DBC.DatabasesV
    """,
    "tables": """
        SELECT DatabaseName, TableName, TableKind, CreateTimeStamp
        FROM DBC.TablesV
        WHERE TableKind = 'T'
    """,
    "columns": """
        SELECT DatabaseName, TableName, ColumnName, ColumnType, ColumnLength, Nullable
        FROM DBC.ColumnsV
    """
}

# ==========================================
# EXTRACCIÓN
# ==========================================
data = {}

for key, query in queries.items():
    df = pd.read_sql(query, conn)
    data[key] = df.to_dict(orient="records")
    print(f"✔ Extraído: {key} ({len(df)} registros)")

conn.close()

# ==========================================
# EXPORTAR JSON (para OpenMetadata)
# ==========================================
with open("teradata_metadata.json", "w") as f:
    json.dump(data, f, indent=4)

print("🔥 Metadata exportada a teradata_metadata.json")