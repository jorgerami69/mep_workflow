from openai import OpenAI
import json
from config import OPENAI_API_KEY, MODEL

client = OpenAI(api_key=OPENAI_API_KEY)


def extract_items(data):
    """
    Normaliza distintas estructuras posibles del JSON del scanner
    y devuelve una lista de items enriquecibles.
    """

    if isinstance(data, list):
        return data

    if not isinstance(data, dict):
        return []

    print("KEYS JSON:", data.keys())

    # Caso 1: el scanner devuelve csv_analysis como objeto con files[]
    if "csv_analysis" in data:
        csv_analysis = data["csv_analysis"]

        if isinstance(csv_analysis, dict):
            if "files" in csv_analysis and isinstance(csv_analysis["files"], list):
                print("📊 Usando csv_analysis.files")
                return csv_analysis["files"]

            # fallback por si csv_analysis ya viniera como lista
            if isinstance(csv_analysis, list):
                print("📊 Usando csv_analysis (lista)")
                return csv_analysis

    # Caso 2: otras estructuras posibles
    if "files" in data and isinstance(data["files"], list):
        print("📁 Usando files")
        return data["files"]

    if "tables" in data and isinstance(data["tables"], list):
        print("🗂️ Usando tables")
        return data["tables"]

    if "csvs" in data and isinstance(data["csvs"], list):
        print("🧾 Usando csvs")
        return data["csvs"]

    print("⚠️ No se encontró lista procesable en el JSON")
    return []


def enrich_metadata(input_json, output_json):
    with open(input_json, "r", encoding="utf-8") as f:
        data = json.load(f)

    print("TIPO DATA:", type(data))

    items = extract_items(data)

    print("TOTAL ITEMS A ENRICH:", len(items))

    if not items:
        print("❌ No hay datos para enriquecer")
        with open(output_json, "w", encoding="utf-8") as f:
            json.dump([], f, indent=2, ensure_ascii=False)
        return

    enriched = []

    # Limita para controlar costo
    max_items = min(len(items), 10)

    for i, item in enumerate(items[:max_items], start=1):
        prompt = f"""
Eres un arquitecto de datos experto.

Analiza esta metadata técnica y devuelve SOLO JSON válido con esta estructura:

{{
  "descripcion_funcional": "...",
  "tipo_tabla": "...",
  "nivel_riesgo": "alto|medio|bajo",
  "problemas_detectados": ["..."],
  "recomendacion": "..."
}}

Metadata:
{json.dumps(item, ensure_ascii=False)}
"""

        try:
            response = client.responses.create(
                model=MODEL,
                input=prompt
            )

            result_text = response.output[0].content[0].text
        except Exception as e:
            print(f"❌ Error en OpenAI en item {i}: {e}")
            result_text = json.dumps({
                "descripcion_funcional": "error",
                "tipo_tabla": "error",
                "nivel_riesgo": "alto",
                "problemas_detectados": [str(e)],
                "recomendacion": "Revisar configuración del modelo o credenciales."
            }, ensure_ascii=False)

        try:
            ai_analysis = json.loads(result_text)
        except Exception:
            ai_analysis = {
                "descripcion_funcional": result_text,
                "tipo_tabla": "indeterminado",
                "nivel_riesgo": "medio",
                "problemas_detectados": ["La respuesta no vino en JSON puro"],
                "recomendacion": "Ajustar prompt o parseo."
            }

        enriched_item = dict(item)
        enriched_item["ai_analysis"] = ai_analysis
        enriched.append(enriched_item)

        print(f"Enriched {i}/{max_items}")

    with open(output_json, "w", encoding="utf-8") as f:
        json.dump(enriched, f, indent=2, ensure_ascii=False)

    print("✅ Enriched JSON generado:", output_json)