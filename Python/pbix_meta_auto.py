import os
import time
import subprocess
import psutil

PBIX_FOLDER = r"C:\data\workspace\Data_Artiifacts\PbixLake"
OUTPUT_FOLDER = r"C:\data\workspace\Data_Artiifacts\PbixMetadataOut"

PBI_PATH = r"C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
TABULAR_EDITOR = r"C:\Program Files (x86)\Tabular Editor\TabularEditor.exe"

os.makedirs(OUTPUT_FOLDER, exist_ok=True)


def get_analysis_services_port():
    for proc in psutil.process_iter(['name', 'cmdline']):
        try:
            if "msmdsrv.exe" in proc.info['name']:
                cmd = " ".join(proc.info['cmdline'])
                if "localhost:" in cmd:
                    return cmd.split("localhost:")[1].split()[0]
        except:
            continue
    return None


def open_pbix(pbix_path):
    return subprocess.Popen([PBI_PATH, pbix_path])


def close_powerbi():
    for proc in psutil.process_iter(['name']):
        if "PBIDesktop.exe" in proc.info['name']:
            proc.kill()


def export_model(port, output_file):
    conn = f"localhost:{port}"

    cmd = [
        TABULAR_EDITOR,
        "-S", conn,
        "-EXPORT", output_file
    ]

    subprocess.run(cmd)


def process_all():
    for file in os.listdir(PBIX_FOLDER):
        if file.endswith(".pbix"):
            pbix_path = os.path.join(PBIX_FOLDER, file)
            name = file.replace(".pbix", "")

            print(f"\n🚀 Procesando: {file}")

            # abrir PBIX
            p = open_pbix(pbix_path)

            # esperar que cargue
            time.sleep(20)

            port = get_analysis_services_port()

            if not port:
                print("❌ No se encontró puerto")
                continue

            print(f"✅ Puerto detectado: {port}")

            output_file = os.path.join(OUTPUT_FOLDER, f"{name}.bim")

            export_model(port, output_file)

            print(f"✅ Exportado: {output_file}")

            # cerrar power bi
            close_powerbi()

            time.sleep(5)


if __name__ == "__main__":
    process_all()