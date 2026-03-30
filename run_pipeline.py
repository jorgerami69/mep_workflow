import os
import subprocess
from agents.enrich_metadata import enrich_metadata
from reports.report_generator import generate_excel, generate_pdf

BASE_OUTPUT = "C:/data/output"

RAW = f"{BASE_OUTPUT}/raw.json"
ENRICHED = f"{BASE_OUTPUT}/qa_enriched.json"

EXCEL = f"{BASE_OUTPUT}/qa_report.xlsx"
PDF = f"{BASE_OUTPUT}/qa_report.pdf"

os.makedirs(BASE_OUTPUT, exist_ok=True)

# 🔥 1. SCAN
subprocess.run([
    "python",
    "mep_qa/scanner.py",
    "--mep-path", "./Output_MEPs_Integratel",
    "--output", RAW
])

# 🔥 2. ENRICH (IA)
enrich_metadata(RAW, ENRICHED)

# 🔥 3. REPORTES
generate_excel(ENRICHED, EXCEL)
generate_pdf(ENRICHED, PDF)

print("🚀 Pipeline completo")