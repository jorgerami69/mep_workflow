import pandas as pd
from fpdf import FPDF
import json


def generate_excel(input_json, output_excel):
    with open(input_json, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not data:
        print("❌ No hay datos para Excel")
        return

    rows = []

    for item in data:
        ai = item.get("ai_analysis", {})

        row = {
            "archivo": item.get("file_name", ""),
            "ruta": item.get("path", ""),
            "columnas": item.get("columns_count", ""),
            "filas": item.get("row_count", ""),

            "tipo_tabla": ai.get("tipo_tabla", ""),
            "riesgo": ai.get("nivel_riesgo", ""),
            "descripcion": ai.get("descripcion_funcional", ""),
            "recomendacion": ai.get("recomendacion", ""),
        }

        rows.append(row)

    df = pd.DataFrame(rows)
    df.to_excel(output_excel, index=False)

    print("📊 Excel generado:", output_excel)


def generate_pdf(input_json, output_pdf):
    with open(input_json, "r", encoding="utf-8") as f:
        data = json.load(f)

    pdf = FPDF()
    pdf.set_auto_page_break(auto=True, margin=10)

    for item in data[:20]:  # limitamos para no hacer PDF gigante
        ai = item.get("ai_analysis", {})

        pdf.add_page()
        pdf.set_font("Arial", size=10)

        pdf.multi_cell(0, 5, f"""
Archivo: {item.get("file_name", "")}
Ruta: {item.get("path", "")}

Tipo: {ai.get("tipo_tabla", "")}
Riesgo: {ai.get("nivel_riesgo", "")}

Descripción:
{ai.get("descripcion_funcional", "")}

Problemas:
{ai.get("problemas_detectados", "")}

Recomendación:
{ai.get("recomendacion", "")}
""")

    pdf.output(output_pdf)

    print("📄 PDF generado:", output_pdf)