"""
Maps the 23 manual checklist items (MEP_QA_Checklist.xlsx) to automated scanner checks.

Items marked 'auto' can be pre-filled by the scanner.
Items marked 'claude' require Claude's reasoned evaluation.
Items marked 'manual' require human judgment.
"""

CHECKLIST_MAP = {
    # --- 1. Completitud de artefactos ---
    "1.1": {
        "item": "Scripts de ejecución presentes",
        "mode": "auto",
        "scanner_field": "structure.subcarpetas_found.C",
        "logic": "Check if C_Diccionario_BD has script files (.ps1, .sh, .sql, .py)",
    },
    "1.2": {
        "item": "README de ejecución incluido",
        "mode": "auto",
        "scanner_field": "structure",
        "logic": "Check for README* files in MEP",
    },
    "1.3": {
        "item": "Checklist de validación adjunto",
        "mode": "auto",
        "scanner_field": "structure",
        "logic": "Check for checklist files in MEP",
    },
    "1.4": {
        "item": "Deadline del MEP declarado",
        "mode": "manual",
        "note": "Requires checking the MEP request communication",
    },
    "1.5": {
        "item": "Outputs del servidor adjuntos",
        "mode": "auto",
        "scanner_field": "csv_analysis.total_csvs",
        "logic": "Check if there are CSV/output files from gatherer execution",
    },

    # --- 2. Validez de scripts ---
    "2.1": {
        "item": "Motor de BD y versión identificados",
        "mode": "auto",
        "scanner_field": "engine_detection",
        "logic": "Engine detected by scanner",
    },
    "2.2": {
        "item": "Scripts sin errores de sintaxis",
        "mode": "claude",
        "note": "Claude reads script files and evaluates syntax",
    },
    "2.3": {
        "item": "Sin instrucciones destructivas no documentadas",
        "mode": "auto",
        "scanner_field": "security",
        "logic": "Scan for DROP, TRUNCATE, DELETE in scripts",
    },
    "2.4": {
        "item": "Parametrización correcta",
        "mode": "claude",
        "note": "Claude evaluates if scripts have hardcoded values",
    },

    # --- 3. Consistencia de schemas ---
    "3.1": {
        "item": "Nombres de schemas coinciden con inventario",
        "mode": "claude",
        "note": "Claude cross-references A_Ficha vs C_Diccionario schemas",
    },
    "3.2": {
        "item": "Convenciones de nomenclatura respetadas",
        "mode": "claude",
        "note": "Claude evaluates naming conventions in extracted metadata",
    },
    "3.3": {
        "item": "Sin duplicidad de objetos ya ingresados",
        "mode": "claude",
        "note": "Claude checks against known OM assets if available",
    },
    "3.4": {
        "item": "Tipos de datos coherentes y declarados",
        "mode": "auto",
        "scanner_field": "csv_analysis",
        "logic": "Check data type columns in tables CSVs are populated",
    },

    # --- 4. Coherencia de volumetrías ---
    "4.1": {
        "item": "Volumetrías declaradas en el paquete MEP",
        "mode": "auto",
        "scanner_field": "csv_analysis",
        "logic": "Check for row_count/table_size columns in CSVs",
    },
    "4.2": {
        "item": "Volumetrías consistentes con outputs del servidor",
        "mode": "claude",
        "note": "Claude evaluates if row counts are reasonable for a telco",
    },
    "4.3": {
        "item": "Cardinalidades de relaciones documentadas",
        "mode": "claude",
        "note": "Claude checks FK relationships and cardinality documentation",
    },

    # --- 5. Preparación para OpenMetadata ---
    "5.1": {
        "item": "Ownership del asset identificado",
        "mode": "claude",
        "note": "Claude checks if owner can be identified from A_Ficha + Tracker",
    },
    "5.2": {
        "item": "Tags y clasificaciones propuestos",
        "mode": "claude",
        "note": "Claude evaluates if enough info exists for SID domain tagging",
    },
    "5.3": {
        "item": "Lineage de origen documentado",
        "mode": "claude",
        "note": "Claude evaluates G_Lineage content and D_Jobs references",
    },
    "5.4": {
        "item": "Conectores necesarios identificados",
        "mode": "auto",
        "scanner_field": "engine_detection",
        "logic": "Engine detected -> connector known (MSSQL/MySQL/Oracle/PG/MongoDB)",
    },

    # --- 6. Coordinación y trazabilidad ---
    "6.1": {
        "item": "Activos VALTX gestionados por SPOC de Integratel",
        "mode": "manual",
        "note": "Requires checking coordination channel",
    },
    "6.2": {
        "item": "Fecha de recepción registrada en MEP Tracker",
        "mode": "auto",
        "scanner_field": "tracker_alignment",
        "logic": "Check MEP_00_Master_Tracker for this MEP entry",
    },
    "6.3": {
        "item": "Canal de entrega acordado respetado",
        "mode": "manual",
        "note": "Requires checking delivery channel (SharePoint)",
    },
}


def get_auto_items() -> list[str]:
    """Return checklist item IDs that can be auto-evaluated."""
    return [k for k, v in CHECKLIST_MAP.items() if v["mode"] == "auto"]


def get_claude_items() -> list[str]:
    """Return checklist item IDs that need Claude's evaluation."""
    return [k for k, v in CHECKLIST_MAP.items() if v["mode"] == "claude"]


def get_manual_items() -> list[str]:
    """Return checklist item IDs that require human judgment."""
    return [k for k, v in CHECKLIST_MAP.items() if v["mode"] == "manual"]
