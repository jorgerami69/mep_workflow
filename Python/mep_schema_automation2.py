import os
import json
import re
from pathlib import Path
import pandas as pd
from collections import defaultdict

# ================================
# CONFIG
# ================================
BASE_DIR = Path(r"C:\data\workspace\mep_workflow")
INPUT_DIR = BASE_DIR / "Output_MEPs_Integratel"
OUTPUT_DIR = BASE_DIR / "out"

# control de tamaño del diagrama (para que sea usable)
MAX_TABLES_PER_DB = 25          # top N tablas por BD
MAX_COLS_PER_TABLE = 6          # columnas por tabla en el diagrama

OUTPUT_DIR.mkdir(exist_ok=True)

# ================================
# UTILS
# ================================
def find_files(base_path, extensions):
    files = []
    for ext in extensions:
        files.extend(base_path.rglob(f"*{ext}"))
    return files

def normalize_dtype(dtype):
    d = (dtype or "").upper()
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

# columnas tipo: [COL] TYPE ...
COL_RE = re.compile(
    r'^\s*\[?(\w+)\]?\s+([A-Za-z0-9\(\),]+)',
    re.IGNORECASE
)

# FK explícitas: CONSTRAINT ... FOREIGN KEY ([col]) REFERENCES schema.table([col])
FK_RE = re.compile(
    r'FOREIGN\s+KEY\s*\(\s*\[?(\w+)\]?\s*\)\s*REFERENCES\s+([\[\]\w\.]+)\s*\(\s*\[?(\w+)\]?\s*\)',
    re.IGNORECASE
)

def clean_table_name(raw):
    return raw.replace("[","").replace("]","").replace("dbo.","")

def parse_sql_file(sql_file):
    tables = []
    fks = []  # (src_table, src_col, tgt_table, tgt_col)

    with open(sql_file, encoding="utf-8", errors="ignore") as f:
        content = f.read()

    # CREATE TABLE
    matches = CREATE_RE.findall(content)
    for table_name, cols_block in matches:
        tname = clean_table_name(table_name)

        cols = []
        for line in cols_block.split(","):
            line = line.strip()
            m = COL_RE.match(line)
            if m:
                col_name = m.group(1)
                col_type = m.group(2)
                cols.append({"name": col_name, "type": col_type})

        tables.append({"name": tname, "columns": cols})

    # FK explícitas
    fk_matches = FK_RE.findall(content)
    for col, tgt_table_raw, tgt_col in fk_matches:
        tgt_table = clean_table_name(tgt_table_raw)
        # OJO: el src_table lo resolvemos después por contexto
        fks.append({"src_col": col, "tgt_table": tgt_table, "tgt_col": tgt_col})

    return tables, fks

# ================================
# RELACIONES (explícitas + inferidas)
# ================================
def build_relations(tables, explicit_fks):
    relations = []  # (src_table, src_col, tgt_table, tgt_col, type)

    # índice de tablas por nombre
    table_map = {t["name"]: t for t in tables}

    # 1) explícitas (si el SQL las trae)
    # Nota: no siempre sabemos src_table de la FK por el regex simple,
    # así que hacemos match por columna en tablas
    for fk in explicit_fks:
        tgt = fk["tgt_table"]
        tgt_col = fk["tgt_col"]
        src_col = fk["src_col"]

        for t in tables:
            if any(c["name"].lower() == src_col.lower() for c in t["columns"]):
                relations.append({
                    "src_table": t["name"],
                    "src_col": src_col,
                    "tgt_table": tgt,
                    "tgt_col": tgt_col,
                    "type": "explicit"
                })

    # 2) inferidas por convención *_ID
    # si una tabla tiene CLIENTE_ID y existe tabla CLIENTE → relación
    names_upper = {t["name"].upper(): t["name"] for t in tables}

    for t in tables:
        for c in t["columns"]:
            cname = c["name"].upper()
            if cname.endswith("_ID"):
                base = cname[:-3]  # quita _ID
                if base in names_upper:
                    relations.append({
                        "src_table": t["name"],
                        "src_col": c["name"],
                        "tgt_table": names_upper[base],
                        "tgt_col": "ID",
                        "type": "inferred"
                    })

    return relations

# ================================
# GRAPHVIZ (PNG)
# ================================
def build_graphviz_png(db_name, tables, relations, out_dir):
    dot_path = out_dir / f"er_{db_name}.dot"
    png_path = out_dir / f"er_{db_name}.png"

    # limitar tamaño
    tables_limited = tables[:MAX_TABLES_PER_DB]
    allowed = set(t["name"] for t in tables_limited)

    # filtrar relaciones a tablas visibles
    rels = [r for r in relations if r["src_table"] in allowed and r["tgt_table"] in allowed]

    # DOT
    dot = []
    dot.append("digraph ER {")
    dot.append('  graph [rankdir=LR, fontname="Helvetica"];')
    dot.append('  node [shape=plaintext, fontname="Helvetica"];')
    dot.append('  edge [fontname="Helvetica"];')

    # nodos (tablas como tablas HTML)
    for t in tables_limited:
        rows = []
        rows.append(f'<TR><TD BGCOLOR="#2F4F4F"><FONT COLOR="white"><B>{t["name"]}</B></FONT></TD></TR>')
        for col in t["columns"][:MAX_COLS_PER_TABLE]:
            rows.append(f'<TR><TD ALIGN="LEFT">{col["name"]} : {normalize_dtype(col["type"])}</TD></TR>')
        label = f'<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">{"".join(rows)}</TABLE>>'
        dot.append(f'  "{t["name"]}" [label={label}];')

    # aristas
    for r in rels:
        color = "#1E90FF" if r["type"] == "explicit" else "#A9A9A9"
        dot.append(f'  "{r["src_table"]}" -> "{r["tgt_table"]}" [label="{r["src_col"]}", color="{color}"];')

    dot.append("}")

    # escribir DOT
    with open(dot_path, "w", encoding="utf-8") as f:
        f.write("\n".join(dot))

    # render PNG (requiere Graphviz)
    try:
        os.system(f'dot -Tpng "{dot_path}" -o "{png_path}"')
    except Exception as e:
        print(f"⚠️ No se pudo generar PNG para {db_name}: {e}")

    return dot_path, png_path, rels

# ================================
# CORE
# ================================
def process_server(server_path):
    server_name = server_path.name
    print(f"\n🔥 Procesando servidor: {server_name}")

    server_out = OUTPUT_DIR / server_name
    server_out.mkdir(exist_ok=True)

    db_map = defaultdict(list)
    fk_map = defaultdict(list)

    # 1) leer SQL y agrupar por BD
    sql_files = find_files(server_path, [".sql"])
    for sf in sql_files:
        db = infer_db_from_filename(sf)
        tables, fks = parse_sql_file(sf)
        db_map[db].extend(tables)
        fk_map[db].extend(fks)

    # 2) outputs por BD
    inventory_rows = []

    for db_name, tables in db_map.items():
        if not tables:
            continue

        db_out = server_out / db_name
        db_out.mkdir(exist_ok=True)

        # relaciones
        relations = build_relations(tables, fk_map[db_name])

        # inventory
        for t in tables:
            inventory_rows.append({
                "server": server_name,
                "database": db_name,
                "table": t["name"],
                "columns": len(t["columns"])
            })

        # Graphviz → PNG
        dot_path, png_path, rels = build_graphviz_png(db_name, tables, relations, db_out)

        # dump relaciones (auditoría)
        pd.DataFrame(rels).to_csv(db_out / f"relations_{db_name}.csv", index=False)

        print(f"   🧩 {db_name}: {len(tables)} tablas | PNG: {png_path.name}")

    # 3) inventory global por servidor
    if inventory_rows:
        pd.DataFrame(inventory_rows).to_csv(server_out / f"inventory_{server_name}.csv", index=False)

    print(f"✅ {server_name} listo")


# ================================
# MAIN
# ================================
def main():
    servers = [p for p in INPUT_DIR.iterdir() if p.is_dir()]
    for srv in servers:
        process_server(srv)
    print("\n🚀 PROCESO COMPLETO (PNG + relaciones)")

if __name__ == "__main__":
    main()