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

PBIX_FOLDER = r"C:\data\workspace\Data_Artifacts\PbixLake"

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
        "measures": []
    }

    try:

        import clr

        clr.AddReference(CORE_DLL)
        clr.AddReference(TABULAR_DLL)

        from Microsoft.AnalysisServices.Tabular import Server

        conn = f"localhost:{port}"

        print(f"\n🔌 TOM connect:")
        print(conn)

        server = Server()

        server.Connect(conn)

        # =================================================
        # ESPERAR MODELO
        # =================================================

        max_wait = 300

        start = time.time()

        while time.time() - start < max_wait:

            if server.Databases.Count > 0:

                break

            print("⏳ Esperando modelo tabular...")

            time.sleep(10)

        if server.Databases.Count == 0:

            result["warning"] = "No databases found"

            return result

        db = server.Databases[0]

        model = db.Model

        # =================================================
        # TABLES
        # =================================================

        for t in model.Tables:

            tbl = {

                "name": t.Name,
                "columns": [],
                "partitions": []
            }

            for c in t.Columns:

                tbl["columns"].append({

                    "name": c.Name,
                    "datatype": str(c.DataType),
                    "hidden": bool(c.IsHidden)
                })

            for p in t.Partitions:

                try:

                    src = str(p.Source)

                except:

                    src = None

                tbl["partitions"].append({

                    "name": p.Name,
                    "source": src
                })

            result["tables"].append(tbl)

        # =================================================
        # RELATIONSHIPS
        # =================================================

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

        for t in model.Tables:

            for m in t.Measures:

                result["measures"].append({

                    "table": t.Name,
                    "name": m.Name,
                    "expression": m.Expression
                })

        server.Disconnect()

    except Exception as e:

        result["error"] = str(e)

    return result


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
        "tom": {}
    }

    # =====================================================
    # CONNECTIONS
    # =====================================================

    result["connections"] = parse_connections(extract_dir)

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

        time.sleep(90)

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