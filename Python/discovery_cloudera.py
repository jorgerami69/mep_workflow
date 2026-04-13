from pyhive import hive
import pandas as pd

HOST = "hive-server"
PORT = 10000
USER = "hadoop"

print("Conectando a Hive...")

conn = hive.Connection(
    host=HOST,
    port=PORT,
    username=USER
)

cursor = conn.cursor()

cursor.execute("SHOW DATABASES")
databases = [d[0] for d in cursor.fetchall()]

metadata = []

for db in databases:

    print("Database:", db)

    cursor.execute(f"SHOW TABLES IN {db}")
    tables = [t[0] for t in cursor.fetchall()]

    for table in tables:

        print("Tabla:", table)

        cursor.execute(f"DESCRIBE {db}.{table}")
        cols = cursor.fetchall()

        for col in cols:

            column = col[0]
            dtype = col[1]

            if column and not column.startswith("#"):

                metadata.append({
                    "database": db,
                    "table": table,
                    "column": column,
                    "datatype": dtype
                })

df = pd.DataFrame(metadata)

df.to_excel("cloudera_metadata_inventory.xlsx", index=False)

print("Discovery terminado")
print("Archivo generado: cloudera_metadata_inventory.xlsx")