import os
import json
import re
from pathlib import Path
import pandas as pd

# ================================
# CONFIG (TU PROYECTO)
# ================================

BASE_DIR = Path(r"C:\data\workspace\mep_workflow")
INPUT_DIR = BASE_DIR / "Output_MEPs_Integratel"
RECONSTRUCT_DIR = BASE_DIR / "reconstruct_reports"
OUTPUT_DIR = BASE_DIR / "out"

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
        return "VARCHAR(255)"


# ================================
# 🔥 NUEVO: PARSEAR SQL (CLAVE)
# ================================

def parse_sql_file(sql_file):
    tables = []

    with open(sql_file, encoding="utf-8", errors="ignore") as f:
        content = f.read()

    pattern = r'CREATE TABLE\s+([\[\]\w\.]+)\s*\((.*?)\);'
    matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)

    for table_name, cols_block in matches:
        columns = []

        cols = cols_block.split(",")

        for col in cols:
            col = col.strip()

            if col.startswith("["):
                col_name = col.split("]")[0].replace("[", "")
                columns.append(col_name)

        tables.append({
            "name": table_name.replace("dbo.", "").replace("[", "").replace("]", ""),
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

    all_tables = []
    sql_output = ""

    # ================================
    # 1. RECONSTRUCT (SI EXISTE)
    # ================================

    reconstruct_path = RECONSTRUCT_DIR / server_name

    if reconstruct_path.exists():
        json_files = find_files(reconstruct_path, [".json"])

        for jf in json_files:
            try:
                data = json.load(open(jf, encoding="utf-8"))

                if "tables" in data:
                    for table in data["tables"]:
                        table_name = table.get("name", "unknown_table")
                        columns = table.get("columns", [])

                        sql_output += f"\nCREATE TABLE {table_name} (\n"

                        for col in columns:
                            col_name = col.get("name", "col")
                            col_type = col.get("type", infer_type(col_name))
                            sql_output += f"  {col_name} {col_type},\n"

                        sql_output = sql_output.rstrip(",\n") + "\n);\n"

                        all_tables.append({
                            "table": table_name,
                            "columns": len(columns)
                        })

            except Exception as e:
                print(f"⚠️ Error JSON {jf}: {e}")

    # ================================
    # 2. 🔥 PARSEAR SQL (ESTA ES LA CLAVE)
    # ================================

    sql_files = find_files(server_path, [".sql"])

    for sf in sql_files:
        try:
            parsed_tables = parse_sql_file(sf)

            for table in parsed_tables:
                table_name = table["name"]
                columns = table["columns"]

                sql_output += f"\nCREATE TABLE {table_name} (\n"

                for col in columns:
                    sql_output += f"  {col} {infer_type(col)},\n"

                sql_output = sql_output.rstrip(",\n") + "\n);\n"

                all_tables.append({
                    "table": table_name,
                    "columns": len(columns)
                })

        except Exception as e:
            print(f"⚠️ Error SQL {sf}: {e}")

    # ================================
    # 3. CSV (SI EXISTEN)
    # ================================

    csv_files = find_files(server_path, [".csv"])

    for cf in csv_files:
        try:
            df = pd.read_csv(cf)

            table_name = cf.stem

            sql_output += f"\nCREATE TABLE {table_name} (\n"

            for col in df.columns:
                sql_output += f"  {col} {infer_type(col)},\n"

            sql_output = sql_output.rstrip(",\n") + "\n);\n"

            all_tables.append({
                "table": table_name,
                "columns": len(df.columns)
            })

        except:
            continue

    # ================================
    # 💾 OUTPUTS
    # ================================

    with open(server_out / "schema.sql", "w", encoding="utf-8") as f:
        f.write(sql_output)

    with open(server_out / "server_inventory.json", "w", encoding="utf-8") as f:
        json.dump(all_tables, f, indent=2)

    df_summary = pd.DataFrame(all_tables)
    df_summary.to_csv(server_out / "inventory.csv", index=False)

    # ================================
    # MERMAID REAL
    # ================================

    mermaid = "erDiagram\n"

    if len(all_tables) == 0:
        mermaid += "  EMPTY_TABLE {\n    INT id\n  }\n"
    else:
        for t in all_tables:
            mermaid += f"  {t['table']} {{\n"
            mermaid += f"    INT id\n"
            mermaid += f"    VARCHAR sample\n"
            mermaid += f"  }}\n"

    with open(mermaid_dir / "er_diagram.mmd", "w", encoding="utf-8") as f:
        f.write(mermaid)

    print(f"✅ {server_name} listo ({len(all_tables)} tablas)")


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