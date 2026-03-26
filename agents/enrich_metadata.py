from openai import OpenAI
import json
from config import OPENAI_API_KEY, MODEL

client = OpenAI(api_key=OPENAI_API_KEY)

def enrich_metadata(input_json, output_json):

    with open(input_json, "r", encoding="utf-8") as f:
        data = json.load(f)

# 🔥 FIX CLAVE
    if isinstance(data, dict): 
        data = data.get("files", [])

    enriched = []

    for i, item in enumerate(data[:50]):  # 🔥 limita para no romper API
        prompt = f"""
        Eres un arquitecto de datos experto.

        Analiza esta metadata:

        {item}

        Devuelve en JSON:
        - descripcion_funcional
        - tipo_tabla (transaccional, dimensional, log, etc)
        - nivel_riesgo (alto, medio, bajo)
        - problemas_detectados
        - recomendacion
        """

        response = client.chat.completions.create(
            model=MODEL,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.2
        )

        try:
            item["ai_analysis"] = response.choices[0].message.content
        except:
            item["ai_analysis"] = "error"

        enriched.append(item)

        print(f"Enriched {i+1}/{len(data)}")

    with open(output_json, "w", encoding="utf-8") as f:
        json.dump(enriched, f, indent=2)