import os
import json
import re
from pathlib import Path
import pandas as pd

# ================================
# CONFIG
# ================================

BASE_DIR = Path(r"C:\data\workspace\mep_workflow")
INPUT_DIR = BASE_DIR / "Output_MEPs_Integratel"
OUTPUT_DIR = BASE_DIR / "out2"

OUTPUT_DIR.mkdir(exist_ok=True)

# ================================
# UTILS
# ================================

def find_files(base_path, extensions):
    files = []
    for ext in extensions:
        files.extend(base_path.rglob(f"*{ext}"))
    return files

def infer_type(col_name):
    col = col_name.lower()
    if "id" in col:
        return "INT"
    elif "date" in col:
        return "DATETIME"
    elif "amount" in col or "value" in col:
        return "DECIMAL(18,2)"
    else:
        return "VARCHAR"

def normalize_dtype(dtype):
    # Para OpenMetadata (simplificado)
    d = dtype.upper()
    if "INT" in d:
        return "INT"
    if "DATE" in d or "TIME" in d:
        return "DATETIME"
    if "DECIMAL" in d or "NUMERIC" in d:
        return "DECIMAL"
    return "STRING"

def infer_db_from_filename(path: Path):
    # BD_CONTROL.sql -> CONTROL
    name = path.stem.upper()
    if name.startswith("BD_"):
        return name.replace("BD_", "")
    return "DEFAULT_DB"

# ================================
# PARSER SQL
# ================================

CREATE_RE = re.compile(
    r'CREATE\s+TABLE\s+([\[\]\w\.]+)\s*\((.*?)\)\s*;',
    re.IGNORECASE | re.DOTALL
)

COL_RE = re.compile(
    r'^\s*\[?(\w+)\]?\s+([A-Za-z0-9\(\),]+)',
    re.IGNORECASE
)

def parse_sql_file(sql_file):
    tables = []

    with open(sql_file, encoding="utf-8", errors="ignore") as f:
        content = f.read()

    matches = CREATE_RE.findall(content)

    for table_name, cols_block in matches:
        clean_table = (
            table_name.replace("[", "")
                      .replace("]", "")
                      .replace("dbo.", "")
        )

        columns = []
        for line in cols_block.split(","):
            line = line.strip()
            m = COL_RE.match(line)
            if m:
                col_name = m.group(1)
                col_type = m.group(2)
                columns.append({
                    "name": col_name,
                    "type": col_type
                })

        tables.append({
            "name": clean_table,
            "columns": columns
        })

    return tables

# ================================
# CORE
# ================================

def process_server(server_path):
    server_name = server_path.name
    print(f"\n🔥 Procesando servidor: {server_name}")

    server_out = OUTPUT_DIR / server_name
    mermaid_dir = server_out / "mermaid"

    server_out.mkdir(exist_ok=True)
    mermaid_dir.mkdir(exist_ok=True)

    db_map = {}  # {db_name: [tables]}

    # ================================
    # 1. LEER SQL
    # ================================

    sql_files = find_files(server_path, [".sql"])

    for sf in sql_files:
        db_name = infer_db_from_filename(sf)

        parsed_tables = parse_sql_file(sf)

        if db_name not in db_map:
            db_map[db_name] = []

        db_map[db_name].extend(parsed_tables)

    # ================================
    # 2. GENERAR OUTPUTS
    # ================================

    all_rows = []
    ddl_output = ""

    openmetadata_payload = {
        "service": f"{server_name}_service",
        "databases": []
    }

    for db_name, tables in db_map.items():

        # ---------- INVENTARIO ----------
        for t in tables:
            all_rows.append({
                "database": db_name,
                "table": t["name"],
                "columns": len(t["columns"])
            })

        # ---------- DDL ----------
        for t in tables:
            ddl_output += f"\nCREATE TABLE {db_name}.{t['name']} (\n"
            for col in t["columns"]:
                ddl_output += f"  {col['name']} {col['type']},\n"
            ddl_output = ddl_output.rstrip(",\n") + "\n);\n"

        # ---------- MERMAID POR DB ----------
        mermaid = "erDiagram\n"
        for t in tables:
            mermaid += f"  {t['name']} {{\n"
            for col in t["columns"][:6]:  # limitamos columnas
                mermaid += f"    {col['name']} {infer_type(col['name'])}\n"
            mermaid += "  }\n"

        with open(mermaid_dir / f"{db_name}.mmd", "w", encoding="utf-8") as f:
            f.write(mermaid)

        # ---------- OPENMETADATA ----------
        db_entry = {
            "name": db_name,
            "schemas": [
                {
                    "name": "dbo",
                    "tables": []
                }
            ]
        }

        for t in tables:
            db_entry["schemas"][0]["tables"].append({
                "name": t["name"],
                "columns": [
                    {
                        "name": c["name"],
                        "dataType": normalize_dtype(c["type"])
                    }
                    for c in t["columns"]
                ]
            })

        openmetadata_payload["databases"].append(db_entry)

    # ---------- GUARDAR ARCHIVOS ----------

    # CSV
    df = pd.DataFrame(all_rows)
    df.to_csv(server_out / f"inventory_{server_name}.csv", index=False)

    # SQL
    with open(server_out / "schema.sql", "w", encoding="utf-8") as f:
        f.write(ddl_output)

    # JSON OpenMetadata
    with open(server_out / f"openmetadata_{server_name}.json", "w", encoding="utf-8") as f:
        json.dump(openmetadata_payload, f, indent=2)

    print(f"✅ {server_name} listo ({len(all_rows)} tablas)")


# ================================
# MAIN
# ================================

def main():
    servers = [p for p in INPUT_DIR.iterdir() if p.is_dir()]

    for srv in servers:
        process_server(srv)

    print("\n🚀 PROCESO COMPLETO")


if __name__ == "__main__":
    main()