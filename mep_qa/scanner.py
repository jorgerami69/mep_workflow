#!/usr/bin/env python3
"""
MEP QA Scanner — Recolector de hechos crudos.

Recorre un MEP y produce un JSON con toda la información estructural,
estadísticas de archivos, análisis de CSVs, inventario de ZIPs, y
detección de credenciales. NO emite juicios — eso lo hace Claude
a través del skill /qa-mep.

Uso:
    python3 mep_qa/scanner.py --mep-path <ruta> [--output <archivo.json>]
    python3 mep_qa/scanner.py --scan-all --input-dir <directorio> [--output-dir <dir>]
"""

import argparse
import json
import sys
import tempfile
from datetime import datetime
from pathlib import Path

# Add parent to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from mep_qa.utils.csv_reader import read_csv_headers, detect_encoding, detect_delimiter
from mep_qa.utils.zip_utils import inventory_zip, extract_zip_to_temp
from mep_qa.utils.security_scan import scan_directory

# --- MEP subcarpeta definitions ---
SUBCARPETAS = ["A", "B", "C", "D", "E", "F", "G", "H"]
SUBCARPETA_NAMES = {
    "A": "Ficha_Funcional",
    "B": "Software_Servicios",
    "C": "Diccionario_BD",
    "D": "Jobs_ETL_ELT",
    "E": "Interfaces_IO",
    "F": "BI_Artefactos",
    "G": "Lineage_Documentacion",
    "H": "Seguridad_Accesos",
}

# --- Engine detection patterns ---
ENGINE_PATTERNS = {
    "mssql": [
        "gather_sqlserver", "export_etl.ps1", "S01_tables_columns",
        "agent_jobs", "sqlserver", "mssql", "SSIS", "_instance",
    ],
    "oracle": [
        "gather_oracle", "plsql", "oracle", "ALDM", "dbms_scheduler",
        "db_links", "tablespaces", "ODS", "OMS", "ABP", "CRM", "MCSS",
    ],
    "postgres": [
        "gather_postgres", "pg_cron", "wal_settings", "replication_slots",
        "tables_no_pk", "materialized_views", "postgresql", "pgsql",
    ],
    "mysql": [
        "gather_mysql", "mep_mysql", "mysqldump", "mysql",
    ],
    "mongodb": [
        "mongodb", "mongosh", "cosmodb", "cosmos", "mongo",
    ],
    "teradata": [
        "teradata", "bteq",
    ],
    "nifi": [
        "nifi", "dump_nifi", "process_group",
    ],
    "mediador": [
        "mediador", "CDR", "EDR", "mediacion",
    ],
}

# --- Expected CSV files per engine gatherer ---
EXPECTED_FILES = {
    "mssql": {
        "instance_level": [
            "00_server_info.csv", "01_databases.csv", "02_logins.csv",
            "03_agent_jobs.csv", "04_linked_servers.csv", "05_server_config.csv",
        ],
        "schema_level_prefix": [
            "S01_tables_columns", "S02_views", "S03_stored_procedures",
            "S04_triggers", "S05_functions", "S06_indexes",
            "S07_table_stats", "S08_schemas", "S09_db_settings",
            "S10_roles", "S11_users", "S12_permissions",
            "S13_fulltext", "S14_user_types",
        ],
    },
    "oracle": {
        "file_patterns": [
            "schemas", "tables", "columns", "constraints", "indexes",
            "views", "plsql", "triggers", "sequences", "db_links",
            "tablespaces", "jobs", "grants", "synonyms",
        ],
    },
    "postgres": {
        "expected_count": 41,
        "critical_files": [
            "00_instance_info", "01_databases", "03_data_dictionary",
            "05_tables_no_pk", "20_cdc_wal_settings",
            "21_replication_slots", "30_table_stats", "31_table_sizes",
        ],
    },
    "mysql": {
        "per_db_files": [
            "tables", "columns", "constraints", "routines", "triggers", "views",
        ],
    },
}


def detect_engine(mep_path: Path) -> str:
    """Detect database engine from file/directory names."""
    all_names = []
    for f in mep_path.rglob("*"):
        all_names.append(f.name.lower())
        all_names.append(f.parent.name.lower())

    # Also check directory name
    all_names.append(mep_path.name.lower())

    all_text = " ".join(all_names)
    scores = {}
    for engine, patterns in ENGINE_PATTERNS.items():
        scores[engine] = sum(1 for p in patterns if p.lower() in all_text)

    if not scores or max(scores.values()) == 0:
        return "unknown"

    return max(scores, key=scores.get)


def scan_structure(mep_path: Path) -> dict:
    """Scan MEP directory structure, map to A-H subcarpetas."""
    structure = {
        "mep_path": str(mep_path),
        "mep_name": mep_path.name,
        "subcarpetas_found": {},
        "subcarpetas_missing": [],
        "total_files": 0,
        "total_size_mb": 0,
        "file_types": {},
    }

    # Find subcarpetas
    for letter in SUBCARPETAS:
        name = SUBCARPETA_NAMES[letter]
        # Try common patterns
        found = None
        for d in mep_path.rglob("*"):
            if d.is_dir():
                dname = d.name
                if (dname.startswith(f"{letter}_") or
                    dname.startswith(f"{letter.lower()}_") or
                    dname == name or
                    dname == f"{letter}_{name}"):
                    found = d
                    break
        if found:
            files = list(found.rglob("*"))
            real_files = [f for f in files if f.is_file()]
            structure["subcarpetas_found"][letter] = {
                "path": str(found),
                "name": found.name,
                "file_count": len(real_files),
                "total_size_mb": round(
                    sum(f.stat().st_size for f in real_files) / (1024 * 1024), 2
                ),
                "files": [
                    {
                        "name": f.name,
                        "size": f.stat().st_size,
                        "extension": f.suffix.lower(),
                    }
                    for f in sorted(real_files)
                ],
            }
        else:
            structure["subcarpetas_missing"].append(letter)

    # Global stats
    all_files = [f for f in mep_path.rglob("*") if f.is_file()]
    structure["total_files"] = len(all_files)
    structure["total_size_mb"] = round(
        sum(f.stat().st_size for f in all_files) / (1024 * 1024), 2
    )

    # File type distribution
    for f in all_files:
        ext = f.suffix.lower() or "(no extension)"
        structure["file_types"][ext] = structure["file_types"].get(ext, 0) + 1

    return structure


def scan_csvs(mep_path: Path, max_large_file_mb: float = 50) -> list[dict]:
    """Analyze all CSV/TSV files in the MEP."""
    csv_results = []
    for f in sorted(mep_path.rglob("*")):
        if f.is_file() and f.suffix.lower() in {".csv", ".tsv"}:
            size_mb = f.stat().st_size / (1024 * 1024)
            if size_mb > max_large_file_mb:
                # For very large files, just report metadata
                csv_results.append({
                    "file": str(f.relative_to(mep_path)),
                    "size_mb": round(size_mb, 2),
                    "encoding": detect_encoding(f),
                    "delimiter": repr(detect_delimiter(f, detect_encoding(f))),
                    "note": f"File too large ({size_mb:.0f}MB), headers-only analysis",
                    "headers": read_csv_headers(f)["headers"][:30],
                    "row_count": "estimated_large",
                })
            else:
                result = read_csv_headers(f)
                result["file"] = str(Path(result["file"]).relative_to(mep_path))
                result["size_mb"] = round(size_mb, 2)
                csv_results.append(result)
    return csv_results


def scan_zips(mep_path: Path) -> list[dict]:
    """Inventory all ZIP files in the MEP."""
    zip_results = []
    for f in sorted(mep_path.rglob("*.zip")):
        result = inventory_zip(f)
        result["zip_file"] = str(Path(result["zip_file"]).relative_to(mep_path))
        # Limit entries to top 50 for JSON size
        if len(result["entries"]) > 50:
            result["entries_truncated"] = True
            result["entries"] = result["entries"][:50]
        zip_results.append(result)
    return zip_results


def scan_empty_files(mep_path: Path) -> list[dict]:
    """Find empty or suspiciously small files."""
    empties = []
    for f in mep_path.rglob("*"):
        if f.is_file():
            size = f.stat().st_size
            if size == 0:
                empties.append({
                    "file": str(f.relative_to(mep_path)),
                    "issue": "empty_file",
                })
            elif f.suffix.lower() in {".csv", ".tsv"} and size < 10:
                empties.append({
                    "file": str(f.relative_to(mep_path)),
                    "issue": "csv_too_small",
                    "size": size,
                })
    return empties


def check_engine_specific(mep_path: Path, engine: str) -> dict:
    """Check engine-specific expected files/patterns."""
    result = {
        "engine": engine,
        "expected_files_found": [],
        "expected_files_missing": [],
        "extra_observations": [],
    }

    if engine not in EXPECTED_FILES:
        result["extra_observations"].append(
            f"No expected file manifest for engine '{engine}'"
        )
        return result

    profile = EXPECTED_FILES[engine]
    all_names = [f.name.lower() for f in mep_path.rglob("*") if f.is_file()]
    all_text = " ".join(all_names)

    if engine == "mssql":
        for f in profile.get("instance_level", []):
            if any(f.lower() in n for n in all_names):
                result["expected_files_found"].append(f)
            else:
                result["expected_files_missing"].append(f)
        for prefix in profile.get("schema_level_prefix", []):
            if prefix.lower() in all_text:
                result["expected_files_found"].append(f"{prefix}*.csv")
            else:
                result["expected_files_missing"].append(f"{prefix}*.csv")

    elif engine == "postgres":
        csv_count = sum(1 for n in all_names if n.endswith(".csv"))
        result["extra_observations"].append(
            f"CSV count: {csv_count} (expected ~{profile['expected_count']})"
        )
        for f in profile.get("critical_files", []):
            if f.lower() in all_text:
                result["expected_files_found"].append(f)
            else:
                result["expected_files_missing"].append(f)

    elif engine == "mysql":
        for f in profile.get("per_db_files", []):
            if f.lower() in all_text:
                result["expected_files_found"].append(f)
            else:
                result["expected_files_missing"].append(f)

    elif engine == "oracle":
        for pattern in profile.get("file_patterns", []):
            if pattern.lower() in all_text:
                result["expected_files_found"].append(pattern)
            else:
                result["expected_files_missing"].append(pattern)

    return result


def scan_mep(mep_path: Path, extract_zips: bool = True) -> dict:
    """Full scan of a single MEP. Returns structured facts as dict."""
    mep_path = Path(mep_path).resolve()

    if not mep_path.exists():
        return {"error": f"Path does not exist: {mep_path}"}

    print(f"[SCAN] Scanning MEP: {mep_path.name}", file=sys.stderr)

    # Phase 1: Extract ZIPs if needed
    temp_dir = None
    scan_path = mep_path
    if extract_zips:
        zips = list(mep_path.rglob("*.zip"))
        if zips:
            temp_dir = Path(tempfile.mkdtemp(prefix="mep_qa_"))
            print(f"[SCAN] Extracting {len(zips)} ZIP(s) to {temp_dir}", file=sys.stderr)
            for z in zips:
                dest = temp_dir / z.stem
                extract_zip_to_temp(z, dest)

    # Phase 2: Detect engine
    engine = detect_engine(mep_path)
    # Also check extracted content
    if temp_dir:
        engine_from_extracted = detect_engine(temp_dir)
        if engine == "unknown" and engine_from_extracted != "unknown":
            engine = engine_from_extracted

    print(f"[SCAN] Detected engine: {engine}", file=sys.stderr)

    # Phase 3: Structure scan
    structure = scan_structure(mep_path)

    # Phase 4: CSV analysis (both original and extracted)
    csv_analysis = scan_csvs(mep_path)
    if temp_dir:
        extracted_csvs = scan_csvs(temp_dir)
        for c in extracted_csvs:
            c["source"] = "extracted_from_zip"
        csv_analysis.extend(extracted_csvs)

    # Phase 5: ZIP inventory
    zip_inventory = scan_zips(mep_path)

    # Phase 6: Empty/corrupt files
    empty_files = scan_empty_files(mep_path)
    if temp_dir:
        empty_files.extend(scan_empty_files(temp_dir))

    # Phase 7: Engine-specific checks
    engine_checks = check_engine_specific(mep_path, engine)
    if temp_dir:
        engine_checks_extracted = check_engine_specific(temp_dir, engine)
        # Merge: add found from extracted
        for f in engine_checks_extracted["expected_files_found"]:
            if f not in engine_checks["expected_files_found"]:
                engine_checks["expected_files_found"].append(f)
        # Remove from missing if found in extracted
        engine_checks["expected_files_missing"] = [
            f for f in engine_checks["expected_files_missing"]
            if f not in engine_checks_extracted["expected_files_found"]
        ]

    # Phase 8: Security scan
    security = scan_directory(mep_path)
    if temp_dir:
        security_extracted = scan_directory(temp_dir)
        security["credential_findings"].extend(security_extracted["credential_findings"])
        security["files_scanned"] += security_extracted["files_scanned"]
        security["total_findings"] = len(security["credential_findings"])

    # Assemble result
    result = {
        "scan_metadata": {
            "scanner_version": "1.0.0",
            "scan_date": datetime.now().isoformat(),
            "mep_path": str(mep_path),
            "mep_name": mep_path.name,
            "temp_extraction_dir": str(temp_dir) if temp_dir else None,
        },
        "engine_detection": {
            "detected_engine": engine,
            "confidence": "high" if engine != "unknown" else "none",
        },
        "structure": structure,
        "csv_analysis": {
            "total_csvs": len(csv_analysis),
            "files": csv_analysis,
        },
        "zip_inventory": {
            "total_zips": len(zip_inventory),
            "files": zip_inventory,
        },
        "empty_files": empty_files,
        "engine_specific": engine_checks,
        "security": security,
        "summary": {
            "subcarpetas_present": len(structure["subcarpetas_found"]),
            "subcarpetas_missing": structure["subcarpetas_missing"],
            "total_files": structure["total_files"],
            "total_size_mb": structure["total_size_mb"],
            "total_csvs": len(csv_analysis),
            "total_csv_rows": sum(
                c.get("row_count", 0)
                for c in csv_analysis
                if isinstance(c.get("row_count"), int)
            ),
            "total_zips": len(zip_inventory),
            "empty_files_count": len(empty_files),
            "security_findings": security["total_findings"],
            "engine": engine,
        },
    }

    print(f"[SCAN] Done. {result['summary']}", file=sys.stderr)
    return result


def main():
    parser = argparse.ArgumentParser(
        description="MEP QA Scanner — Collect raw facts from MEP outputs"
    )
    parser.add_argument(
        "--mep-path",
        type=str,
        help="Path to a single MEP directory to scan",
    )
    parser.add_argument(
        "--scan-all",
        action="store_true",
        help="Scan all MEPs in --input-dir",
    )
    parser.add_argument(
        "--input-dir",
        type=str,
        default="Output_MEPs_Integratel",
        help="Directory containing MEP outputs (for --scan-all)",
    )
    parser.add_argument(
        "--output",
        type=str,
        help="Output JSON file path (default: stdout)",
    )
    parser.add_argument(
        "--output-dir",
        type=str,
        default="qa_reports",
        help="Output directory for --scan-all results",
    )
    parser.add_argument(
        "--no-extract",
        action="store_true",
        help="Skip ZIP extraction (faster, less thorough)",
    )

    args = parser.parse_args()

    if args.mep_path:
        result = scan_mep(Path(args.mep_path), extract_zips=not args.no_extract)
        output_json = json.dumps(result, indent=2, ensure_ascii=False, default=str)
        if args.output:
            Path(args.output).parent.mkdir(parents=True, exist_ok=True)
            Path(args.output).write_text(output_json, encoding="utf-8")
            print(f"[SCAN] Results written to {args.output}", file=sys.stderr)
        else:
            print(output_json)

    elif args.scan_all:
        input_dir = Path(args.input_dir)
        output_dir = Path(args.output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        # Find all MEP directories (look for dirs with A-H structure or known patterns)
        mep_dirs = []
        for d in sorted(input_dir.rglob("*")):
            if d.is_dir() and d.name.startswith("MEP_"):
                mep_dirs.append(d)

        if not mep_dirs:
            # Try top-level numbered dirs
            for d in sorted(input_dir.iterdir()):
                if d.is_dir():
                    for sub in sorted(d.iterdir()):
                        if sub.is_dir() and sub.name.startswith("MEP_"):
                            mep_dirs.append(sub)

        print(f"[SCAN] Found {len(mep_dirs)} MEPs to scan", file=sys.stderr)

        all_results = []
        for mep_dir in mep_dirs:
            result = scan_mep(mep_dir, extract_zips=not args.no_extract)
            out_file = output_dir / f"{mep_dir.name}_scan.json"
            out_file.write_text(
                json.dumps(result, indent=2, ensure_ascii=False, default=str),
                encoding="utf-8",
            )
            all_results.append(result["summary"])

        # Write consolidated summary
        summary_file = output_dir / "scan_summary.json"
        summary_file.write_text(
            json.dumps(all_results, indent=2, ensure_ascii=False, default=str),
            encoding="utf-8",
        )
        print(f"[SCAN] All results in {output_dir}/", file=sys.stderr)

    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
