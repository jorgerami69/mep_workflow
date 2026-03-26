import os
import subprocess
from agents.enrich_metadata import enrich_metadata
from reports.report_generator import generate_excel, generate_pdf

BASE_OUTPUT = "C:/data/output/qa"

RAW = os.path.join(BASE_OUTPUT, "raw.json")
ENRICHED = os.path.join(BASE_OUTPUT, "enriched.json")
EXCEL = os.path.join(BASE_OUTPUT, "report.xlsx")
PDF = os.path.join(BASE_OUTPUT, "report.pdf")

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
from reports.report_generator import generate_excel, generate_pdf

EXCEL = "C:/data/output/qa_report.xlsx"
PDF = "C:/data/output/qa_report.pdf"

generate_excel(ENRICHED, EXCEL)
generate_pdf(ENRICHED, PDF)

# 🔥 3. REPORTES
generate_excel(ENRICHED, EXCEL)
generate_pdf(ENRICHED, PDF)

print("🚀 Pipeline completo")