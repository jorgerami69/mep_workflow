import os
import re
import time
import json
import shutil
import subprocess
import psutil
import sys

sys.stdout.reconfigure(line_buffering=True)

VERSION = "PBIX_META_AUTO_V7_TOM_NO_TABULAR_EDITOR"
print(f"\n🚀 EJECUTANDO VERSION: {VERSION}\n")

PBIX_FOLDER = r"C:\data\workspace\Data_Artifacts\PbixLake"
OUTPUT_FOLDER = r"C:\data\workspace\PbixMetadataOut"

PBI_PATH = r"C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"

WORKSPACE_ROOT = os.path.join(
    os.environ["LOCALAPPDATA"],
    "Microsoft",
    "Power BI Desktop",
    "AnalysisServicesWorkspaces"
)

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

print("========== VALIDANDO RUTAS ==========")
for label, path in [
    ("PBIX_FOLDER", PBIX_FOLDER),
    ("OUTPUT_FOLDER", OUTPUT_FOLDER),
    ("PBI_PATH", PBI_PATH),
    ("WORKSPACE_ROOT", WORKSPACE_ROOT),
]:
    print(f"{label}: {path}")
    print(f"Existe: {os.path.exists(path)}\n")


def kill_processes(name):
    for p in psutil.process_iter(["name"]):
        try:
            if p.info["name"] and name.lower() in p.info["name"].lower():
                print(f"🔴 Cerrando proceso: {p.info['name']}")
                p.kill()
        except Exception:
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


def clean_old_workspaces():
    if not os.path.exists(WORKSPACE_ROOT):
        return

    for d in os.listdir(WORKSPACE_ROOT):
        path = os.path.join(WORKSPACE_ROOT, d)
        if d.startswith("AnalysisServicesWorkspace"):
            print(f"🧹 Eliminando workspace viejo: {path}")
            shutil.rmtree(path, ignore_errors=True)


def open_pbix(pbix_path):
    print(f"\n🟢 Abriendo PBIX:\n{pbix_path}")
    return subprocess.Popen([PBI_PATH, pbix_path])


def decode_port_file(port_file):
    with open(port_file, "rb") as f:
        raw = f.read()

    for enc in ["utf-16", "utf-8", "latin-1"]:
        try:
            text = raw.decode(enc, errors="ignore")
            port = "".join(filter(str.isdigit, text))
            if port:
                return port
        except Exception:
            pass

    return None


def wait_for_port(start_time, timeout=240):
    print("\n🔍 Buscando puerto del workspace NUEVO...\n")

    end_time = time.time() + timeout

    while time.time() < end_time:

        if not os.path.exists(WORKSPACE_ROOT):
            print("❌ No existe carpeta de workspaces")
            time.sleep(5)
            continue

        candidates = []

        for d in os.listdir(WORKSPACE_ROOT):
            ws_path = os.path.join(WORKSPACE_ROOT, d)

            if not d.startswith("AnalysisServicesWorkspace"):
                continue

            try:
                if os.path.getmtime(ws_path) >= start_time:
                    candidates.append(ws_path)
            except Exception:
                pass

        candidates = sorted(candidates, key=os.path.getmtime, reverse=True)

        print(f"📁 Workspaces nuevos encontrados: {len(candidates)}")

        for ws in candidates:
            port_file = os.path.join(ws, "Data", "msmdsrv.port.txt")

            print(f"🔹 Revisando: {port_file}")

            if not os.path.exists(port_file):
                print("   ❌ Aún no existe msmdsrv.port.txt")
                continue

            port = decode_port_file(port_file)

            print(f"   🎯 Puerto limpio: {port}")

            if port and port.isdigit():
                print(f"\n✅ PUERTO FINAL DETECTADO: {port}\n")
                return port

        print("⏳ Esperando 5 segundos...\n")
        time.sleep(5)

    print("❌ TIMEOUT esperando puerto")
    return None


def find_tom_dll():

    tabular = r"C:\data\workspace\dlls\Microsoft.AnalysisServices.Tabular.dll"

    core = r"C:\data\workspace\dlls\Microsoft.AnalysisServices.Core.dll"

    print(f"✅ TOM DLL: {tabular}")
    print(f"✅ CORE DLL: {core}")

    if not os.path.exists(tabular):

        raise FileNotFoundError(
            f"No existe DLL TOM: {tabular}"
        )

    return core, tabular


def export_model_with_tom(port, output_file):
    import clr

    core_dll, tabular_dll = find_tom_dll()

    if os.path.exists(core_dll):
        clr.AddReference(core_dll)

    clr.AddReference(tabular_dll)

    from Microsoft.AnalysisServices.Tabular import Server

    conn = f"localhost:{port}"

    print(f"\n🔌 Conectando TOM a {conn}")

    server = Server()
    server.Connect(conn)

    if server.Databases.Count == 0:
        raise Exception("Conectó al servidor, pero no encontró bases/modelos.")

    db = server.Databases[0]

    print(f"✅ Modelo detectado: {db.Name}")

    model = db.Model

    metadata = {
        "database": db.Name,
        "compatibilityLevel": db.CompatibilityLevel,
        "tables": [],
        "relationships": [],
        "measures": []
    }

    for table in model.Tables:
        table_obj = {
            "name": table.Name,
            "columns": [],
            "measures": [],
            "partitions": []
        }

        for col in table.Columns:
            table_obj["columns"].append({
                "name": col.Name,
                "dataType": str(col.DataType),
                "isHidden": bool(col.IsHidden)
            })

        for measure in table.Measures:
            measure_obj = {
                "table": table.Name,
                "name": measure.Name,
                "expression": measure.Expression,
                "formatString": measure.FormatString,
                "isHidden": bool(measure.IsHidden)
            }
            table_obj["measures"].append(measure_obj)
            metadata["measures"].append(measure_obj)

        for part in table.Partitions:
            src = None
            try:
                src = str(part.Source)
            except Exception:
                src = None

            table_obj["partitions"].append({
                "name": part.Name,
                "mode": str(part.Mode),
                "source": src
            })

        metadata["tables"].append(table_obj)

    for rel in model.Relationships:
        metadata["relationships"].append({
            "name": rel.Name,
            "fromTable": rel.FromTable.Name if rel.FromTable else None,
            "fromColumn": rel.FromColumn.Name if rel.FromColumn else None,
            "toTable": rel.ToTable.Name if rel.ToTable else None,
            "toColumn": rel.ToColumn.Name if rel.ToColumn else None,
            "isActive": bool(rel.IsActive)
        })

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(metadata, f, ensure_ascii=False, indent=2)

    print(f"\n✅ JSON generado: {output_file}")
    print(f"📦 Tamaño: {os.path.getsize(output_file)} bytes")

    server.Disconnect()


def process_all():
    files = [f for f in os.listdir(PBIX_FOLDER) if f.lower().endswith(".pbix")]
    files.sort()

    print(f"\n🎯 TOTAL PBIX: {len(files)}\n")

    for i, file in enumerate(files, 1):
        name = file[:-5]
        pbix_path = os.path.join(PBIX_FOLDER, file)

        print("\n=================================================")
        print(f"[{i}/{len(files)}] 🚀 {file}")
        print("=================================================\n")

        kill_processes("PBIDesktop.exe")
        kill_processes("msmdsrv.exe")
        wait_until_closed("PBIDesktop.exe")
        clean_old_workspaces()

        start_time = time.time()
        open_pbix(pbix_path)

        print("\n⏳ Esperando carga inicial Power BI...\n")
        time.sleep(45)

        port = wait_for_port(start_time=start_time, timeout=240)

        if not port:
            print("\n❌ NO SE DETECTÓ PUERTO\n")
            kill_processes("PBIDesktop.exe")
            continue

        pbix_out_dir = os.path.join(OUTPUT_FOLDER, name)
        os.makedirs(pbix_out_dir, exist_ok=True)

        output_file = os.path.join(pbix_out_dir, f"{name}.json")

        try:
            export_model_with_tom(port, output_file)
        except Exception as e:
            print(f"\n❌ Error exportando con TOM: {e}")

        print("\n🔴 Cerrando Power BI...\n")
        kill_processes("PBIDesktop.exe")
        kill_processes("msmdsrv.exe")
        wait_until_closed("PBIDesktop.exe")

        print(f"\n✔ FINALIZADO: {file}\n")

    print("\n🎯 PROCESO COMPLETADO\n")


if __name__ == "__main__":
    process_all()