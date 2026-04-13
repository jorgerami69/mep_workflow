import os
import zipfile
import re
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


def read_binary(path):
    with open(path, "rb") as f:
        return f.read()


def extract_strings(binary):
    # Extrae strings legibles
    return re.findall(rb"[ -~]{20,}", binary)


def extract_m_queries(strings):
    results = []

    for s in strings:
        text = s.decode("utf-8", errors="ignore")

        if "Sql.Database" in text or "Oracle.Database" in text:
            results.append(text)

    return results


def process_all():
    for file in os.listdir(INPUT_FOLDER):
        if file.endswith(".pbix"):
            name = file.replace(".pbix", "")
            pbix_path = os.path.join(INPUT_FOLDER, file)

            print(f"\n🚀 Procesando: {file}")

            temp = extract_pbix(pbix_path, name)

            datamodel_path = os.path.join(temp, "DataModel")

            if not os.path.exists(datamodel_path):
                print("⚠️ No DataModel")
                continue

            binary = read_binary(datamodel_path)
            strings = extract_strings(binary)

            queries = extract_m_queries(strings)

            metadata = {
                "pbix": file,
                "possible_queries_found": len(queries),
                "sample_queries": queries[:5]
            }

            output_file = os.path.join(
                OUTPUT_FOLDER,
                f"{name}_deep_metadata.json"
            )

            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(metadata, f, indent=4)

            print(f"✅ Deep metadata generado: {output_file}")


if __name__ == "__main__":
    process_all()