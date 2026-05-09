import os
import re
import json
import time
import shutil
import zipfile
import subprocess
import psutil
import sys

# =========================================================
# PBIX FORENSICS ENTERPRISE
# Thin / Embedded / Modern PBIX Detector
# Metadata + Lineage + TOM
# =========================================================

sys.stdout.reconfigure(line_buffering=True)

VERSION = "PBIX_FORENSICS_ENTERPRISE_V1"

print(f"\n🚀 VERSION: {VERSION}\n")

# =========================================================
# CONFIG
# =========================================================

PBIX_FOLDER = r"C:\Users\jorge\OneDrive - Stefanini\01-PbixLake2"

OUTPUT_FOLDER = r"C:\data\workspace\PbixMetadataOut"

TEMP_FOLDER = r"C:\data\workspace\PbixTemp"

PBI_PATH = r"C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"

WORKSPACE_ROOT = os.path.join(
    os.environ["LOCALAPPDATA"],
    "Microsoft",
    "Power BI Desktop",
    "AnalysisServicesWorkspaces"
)

# =========================================================
# DLL TOM
# =========================================================

TABULAR_DLL = r"C:\data\workspace\dlls\Microsoft.AnalysisServices.Tabular.dll"

CORE_DLL = r"C:\data\workspace\dlls\Microsoft.AnalysisServices.Core.dll"

# =========================================================
# INIT
# =========================================================

os.makedirs(OUTPUT_FOLDER, exist_ok=True)
os.makedirs(TEMP_FOLDER, exist_ok=True)

# =========================================================
# HELPERS
# =========================================================

def safe_name(name):

    return re.sub(r'[<>:"/\\|?*]', '_', name)


def kill_processes(name):

    for p in psutil.process_iter(["name"]):

        try:

            if p.info["name"] and name.lower() in p.info["name"].lower():

                print(f"🔴 Cerrando: {p.info['name']}")

                p.kill()

        except:
            pass


def wait_until_closed(name, timeout=60):

    start = time.time()

    while time.time() - start < timeout:

        running = any(
            p.info["name"] and name.lower() in p.info["name"].lower()
            for p in psutil.process_iter(["name"])
        )

        if not running:
            return True

        time.sleep(2)

    return False


# =========================================================
# EXTRAER PBIX
# =========================================================

def extract_pbix(pbix_path, extract_dir):

    os.makedirs(extract_dir, exist_ok=True)

    temp_zip = os.path.join(
        TEMP_FOLDER,
        os.path.basename(pbix_path) + ".zip"
    )

    shutil.copy(pbix_path, temp_zip)

    with zipfile.ZipFile(temp_zip, 'r') as zip_ref:

        zip_ref.extractall(extract_dir)

    os.remove(temp_zip)


# =========================================================
# DETECTAR TIPO PBIX
# =========================================================

def detect_pbix_type(extract_dir):

    connections_file = os.path.join(
        extract_dir,
        "Connections"
    )

    datamashup = os.path.join(
        extract_dir,
        "DataMashup"
    )

    if os.path.exists(datamashup):

        return "EMBEDDED"

    if os.path.exists(connections_file):

        try:

            with open(
                connections_file,
                "r",
                encoding="utf-8",
                errors="ignore"
            ) as f:

                txt = f.read()

            if "RemoteArtifacts" in txt:

                return "THIN_REPORT"

        except:
            pass

    return "UNKNOWN"


# =========================================================
# EXTRAER CONNECTIONS
# =========================================================

def parse_connections(extract_dir):

    connections_file = os.path.join(
        extract_dir,
        "Connections"
    )

    result = {}

    if not os.path.exists(connections_file):

        return result

    try:

        with open(
            connections_file,
            "r",
            encoding="utf-8",
            errors="ignore"
        ) as f:

            txt = f.read()

        result["raw"] = txt

        try:

            j = json.loads(txt)

            result["json"] = j

            if "RemoteArtifacts" in j:

                result["datasetId"] = []

                result["reportId"] = []

                for x in j["RemoteArtifacts"]:

                    result["datasetId"].append(
                        x.get("DatasetId")
                    )

                    result["reportId"].append(
                        x.get("ReportId")
                    )

        except:
            pass

    except Exception as e:

        result["error"] = str(e)

    return result


# =========================================================
# EXTRAER DATAMASHUP
# =========================================================

def extract_datamashup(extract_dir):

    datamashup = os.path.join(
        extract_dir,
        "DataMashup"
    )

    result = []

    if not os.path.exists(datamashup):

        return result

    mashup_dir = os.path.join(
        extract_dir,
        "DataMashup_Extracted"
    )

    os.makedirs(mashup_dir, exist_ok=True)

    temp_zip = datamashup + ".zip"

    shutil.copy(datamashup, temp_zip)

    try:

        with zipfile.ZipFile(temp_zip, 'r') as zip_ref:

            zip_ref.extractall(mashup_dir)

    except Exception as e:

        print(f"❌ Error DataMashup: {e}")

        return result

    finally:

        if os.path.exists(temp_zip):

            os.remove(temp_zip)

    # =====================================================
    # M FILES
    # =====================================================

    m_files = []

    for r, d, files in os.walk(mashup_dir):

        for f in files:

            if f.endswith(".m"):

                m_files.append(
                    os.path.join(r, f)
                )

    # =====================================================
    # PARSE M
    # =====================================================

    for mf in m_files:

        try:

            with open(
                mf,
                "r",
                encoding="utf-8",
                errors="ignore"
            ) as f:

                content = f.read()

            item = {

                "file": mf,
                "servers": [],
                "databases": [],
                "schemas": [],
                "tables": [],
                "sql": [],
                "raw_m": content
            }

            sql_matches = re.findall(
                r'Sql\.Database\("([^"]+)",\s*"([^"]+)"',
                content
            )

            for srv, db in sql_matches:

                item["servers"].append(srv)
                item["databases"].append(db)

            item["schemas"] = re.findall(
                r'Schema="([^"]+)"',
                content
            )

            item["tables"] = re.findall(
                r'Item="([^"]+)"',
                content
            )

            item["sql"] = re.findall(
                r'Query="([^"]+)"',
                content,
                re.DOTALL
            )

            result.append(item)

        except Exception as e:

            print(f"❌ Error parse M: {e}")

    return result


# =========================================================
# TOM EXTRACTION
# =========================================================

def open_pbix(pbix_path):

    print(f"\n🟢 Abriendo PBIX:")
    print(pbix_path)

    subprocess.Popen([PBI_PATH, pbix_path])


def decode_port_file(port_file):

    with open(port_file, "rb") as f:

        raw = f.read()

    for enc in ["utf-16", "utf-8", "latin-1"]:

        try:

            text = raw.decode(enc, errors="ignore")

            port = "".join(
                filter(str.isdigit, text)
            )

            if port:

                return port

        except:
            pass

    return None


def wait_for_port(start_time, timeout=300):

    print("\n🔍 Buscando puerto...\n")

    end = time.time() + timeout

    while time.time() < end:

        if not os.path.exists(WORKSPACE_ROOT):

            time.sleep(5)

            continue

        workspaces = []

        for d in os.listdir(WORKSPACE_ROOT):

            ws = os.path.join(
                WORKSPACE_ROOT,
                d
            )

            if not d.startswith("AnalysisServicesWorkspace"):

                continue

            try:

                if os.path.getmtime(ws) >= start_time:

                    workspaces.append(ws)

            except:
                pass

        workspaces = sorted(
            workspaces,
            key=os.path.getmtime,
            reverse=True
        )

        for ws in workspaces:

            port_file = os.path.join(
                ws,
                "Data",
                "msmdsrv.port.txt"
            )

            if not os.path.exists(port_file):

                continue

            port = decode_port_file(port_file)

            if port:

                print(f"\n✅ Puerto detectado: {port}")

                return port

        time.sleep(5)

    return None


def export_tom_metadata(port):

    result = {

        "tables": [],
        "relationships": [],
        "measures": [],
        "datasources": []
    }

    try:

        import clr

        print("\n📦 Cargando DLL TOM...")

        clr.AddReference(CORE_DLL)
        clr.AddReference(TABULAR_DLL)

        from Microsoft.AnalysisServices.Tabular import Server

        conn = f"DataSource=localhost:{port}"

        print(f"\n🔌 TOM connect:")
        print(conn)

        server = Server()

        # =================================================
        # CONNECT
        # =================================================

        server.Connect(conn)

        print("\n⏳ Esperando catálogo TOM...\n")

        max_wait = 300
        start = time.time()

        db = None

        while time.time() - start < max_wait:

            try:

                print(f"📦 Databases detectadas: {server.Databases.Count}")

                if server.Databases.Count > 0:

                    db = server.Databases[0]

                    print(f"\n✅ Modelo detectado:")
                    print(db.Name)

                    break

            except Exception as e:

                print(f"⚠️ Esperando modelo: {e}")

            time.sleep(10)

        # =================================================
        # VALIDAR
        # =================================================

        if db is None:

            result["warning"] = "No databases found"

            try:

                server.Disconnect()

            except:
                pass

            return result

        # =================================================
        # MODEL
        # =================================================

        model = db.Model

        print("\n📦 Extrayendo tablas...\n")

        # =================================================
        # TABLES
        # =================================================

        for t in model.Tables:

            tbl = {

                "name": t.Name,
                "columns": [],
                "partitions": []
            }

            # =============================================
            # COLUMNS
            # =============================================

            for c in t.Columns:

                tbl["columns"].append({

                    "name": c.Name,
                    "datatype": str(c.DataType),
                    "hidden": bool(c.IsHidden)
                })

            # =============================================
            # PARTITIONS / DATASOURCE
            # =============================================

            for p in t.Partitions:

                src = None

                try:

                    src = str(p.Source)

                except:
                    pass

                tbl["partitions"].append({

                    "name": p.Name,
                    "source": src
                })

            result["tables"].append(tbl)

        # =================================================
        # RELATIONSHIPS
        # =================================================

        print("\n🔗 Extrayendo relaciones...\n")

        for r in model.Relationships:

            result["relationships"].append({

                "name": r.Name,
                "fromTable": r.FromTable.Name if r.FromTable else None,
                "toTable": r.ToTable.Name if r.ToTable else None,
                "active": bool(r.IsActive)
            })

        # =================================================
        # MEASURES
        # =================================================

        print("\n🧮 Extrayendo medidas...\n")

        for t in model.Tables:

            for m in t.Measures:

                result["measures"].append({

                    "table": t.Name,
                    "name": m.Name,
                    "expression": m.Expression
                })

        # =================================================
        # DATASOURCES
        # =================================================

        print("\n🌐 Extrayendo datasources...\n")

        try:

            for ds in model.DataSources:

                result["datasources"].append({

                    "name": ds.Name,
                    "type": str(ds.Type),
                    "description": str(ds.Description)
                })

        except Exception as e:

            result["datasource_warning"] = str(e)

        # =================================================
        # DISCONNECT
        # =================================================

        server.Disconnect()

        print("\n✅ TOM extraction OK\n")

    except Exception as e:

        result["error"] = str(e)

    return result

# =========================================================
# FORENSICS STRINGS
# =========================================================

def extract_raw_strings(extract_dir):

    findings = []

    patterns = [

        r'Sql\.Database\([^)]+\)',

        r'\d+\.\d+\.\d+\.\d+',

        r'VW_[A-Z0-9_]+',

        r'dbo\.[A-Z0-9_]+',

        r'FROM\s+[A-Z0-9_\.\[\]]+',

        r'SELECT\s+.+?FROM',
    ]

    target_files = [

        "Metadata",
        "DataModel",
        "Connections"
    ]

    for tf in target_files:

        path = os.path.join(extract_dir, tf)

        if not os.path.exists(path):

            continue

        try:

            with open(path, "rb") as f:

                raw = f.read()

            text = raw.decode(
                "latin-1",
                errors="ignore"
            )

            for p in patterns:

                matches = re.findall(
                    p,
                    text,
                    re.IGNORECASE | re.DOTALL
                )

                for m in matches:

                    findings.append({

                        "file": tf,
                        "pattern": p,
                        "match": m
                    })

        except Exception as e:

            findings.append({

                "file": tf,
                "error": str(e)
            })

    return findings

# =========================================================
# PROCESS PBIX
# =========================================================

def process_pbix(pbix_path):

    pbix_name = os.path.basename(pbix_path)

    pbix_base = os.path.splitext(pbix_name)[0]

    pbix_base = safe_name(pbix_base)

    print("\n================================================")
    print(f"🚀 {pbix_name}")
    print("================================================")

    out_dir = os.path.join(
        OUTPUT_FOLDER,
        pbix_base
    )

    os.makedirs(out_dir, exist_ok=True)

    extract_dir = os.path.join(
        out_dir,
        "Extracted"
    )

    # =====================================================
    # EXTRAER
    # =====================================================

    extract_pbix(pbix_path, extract_dir)

    # =====================================================
    # TIPO
    # =====================================================

    pbix_type = detect_pbix_type(extract_dir)

    print(f"\n🧠 Tipo detectado:")
    print(pbix_type)

    result = {

    "pbix": pbix_name,
    "type": pbix_type,
    "connections": {},
    "datamashup": [],
    "forensics_strings": [],
    "tom": {}
}

    # =====================================================
    # CONNECTIONS
    # =====================================================

    result["connections"] = parse_connections(extract_dir)

    # =====================================================
    # FORENSICS STRINGS
    # =====================================================

    print("\n🕵️ Ejecutando string forensics...\n")

    result["forensics_strings"] = extract_raw_strings(
        extract_dir
    )
    # =====================================================
    # DATAMASHUP
    # =====================================================

    if pbix_type == "EMBEDDED":

        print("\n📦 Procesando DataMashup...")

        result["datamashup"] = extract_datamashup(
            extract_dir
        )

    # =====================================================
    # TOM
    # =====================================================

    try:

        kill_processes("PBIDesktop.exe")
        kill_processes("msmdsrv.exe")

        wait_until_closed("PBIDesktop.exe")

        start_time = time.time()

        open_pbix(pbix_path)

        print("\n⏳ Esperando Power BI...\n")

        time.sleep(220)

        port = wait_for_port(start_time)

        if port:

            result["tom"] = export_tom_metadata(port)

    except Exception as e:

        result["tom_error"] = str(e)

    finally:

        kill_processes("PBIDesktop.exe")
        kill_processes("msmdsrv.exe")

    # =====================================================
    # EXPORT JSON
    # =====================================================

    out_json = os.path.join(
        out_dir,
        f"{pbix_base}_forensics.json"
    )

    with open(
        out_json,
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(
            result,
            f,
            indent=2,
            ensure_ascii=False
        )

    print(f"\n✅ JSON generado:")
    print(out_json)


# =========================================================
# MAIN
# =========================================================

files = [

    os.path.join(PBIX_FOLDER, f)

    for f in os.listdir(PBIX_FOLDER)

    if f.lower().endswith(".pbix")
]

print(f"\n🎯 TOTAL PBIX: {len(files)}\n")

for pbix in files:

    process_pbix(pbix)

print("\n🎯 PROCESO COMPLETADO\n")