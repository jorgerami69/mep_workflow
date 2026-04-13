import os
import zipfile
import json

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

INPUT_FOLDER = os.path.join(BASE_DIR, "pbix")
OUTPUT_FOLDER = os.path.join(BASE_DIR, "pbixMeta")

os.makedirs(OUTPUT_FOLDER, exist_ok=True)


def extract_pbix(pbix_path, name):
    temp_folder = os.path.join(OUTPUT_FOLDER, f"tmp_{name}")
    os.makedirs(temp_folder, exist_ok=True)

    with zipfile.ZipFile(pbix_path, 'r') as z:
        z.extractall(temp_folder)

    return temp_folder


def extract_connections(temp_folder):
    path = os.path.join(temp_folder, "Connections")

    if not os.path.exists(path):
        return None

    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    except:
        return "No readable (binario o protegido)"


def find_datamashup(temp_folder):
    for root, dirs, files in os.walk(temp_folder):
        for file in files:
            if file == "DataMashup":
                return os.path.join(root, file)
    return None


def process_all():
    for file in os.listdir(INPUT_FOLDER):
        if file.endswith(".pbix"):
            name = file.replace(".pbix", "")
            pbix_path = os.path.join(INPUT_FOLDER, file)

            print(f"\n🚀 Procesando: {file}")

            temp = extract_pbix(pbix_path, name)

            connections = extract_connections(temp)
            mashup = find_datamashup(temp)

            metadata = {
                "pbix": file,
                "has_connections": connections is not None,
                "connections_preview": connections[:500] if connections else None,
                "has_datamashup": mashup is not None
            }

            output_file = os.path.join(
                OUTPUT_FOLDER,
                f"{name}_metadata.json"
            )

            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(metadata, f, indent=4)

            print(f"✅ Metadata generada: {output_file}")


if __name__ == "__main__":
    process_all()