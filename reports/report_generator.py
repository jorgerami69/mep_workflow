import pandas as pd
import json
from fpdf import FPDF

def generate_excel(input_json, output_excel):

    with open(input_json, "r", encoding="utf-8") as f:
        data = json.load(f)

    df = pd.json_normalize(data)

    df.to_excel(output_excel, index=False)


def generate_pdf(input_json, output_pdf):

    with open(input_json, "r", encoding="utf-8") as f:
        data = json.load(f)

    pdf = FPDF()
    pdf.add_page()

    pdf.set_font("Arial", size=8)

    for item in data[:30]:
        text = f"""
Archivo: {item.get('file')}
Filas: {item.get('row_count')}
Errores: {item.get('errors')}
AI: {item.get('ai_analysis')}
"""
        pdf.multi_cell(0, 5, text)
        pdf.ln()

    pdf.output(output_pdf)