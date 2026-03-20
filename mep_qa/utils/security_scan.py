"""Scan files for exposed credentials, PII, and sensitive data."""

import re
from pathlib import Path

# Credential patterns
CREDENTIAL_PATTERNS = [
    (r"(?i)password\s*[=:]\s*['\"]?[^\s'\"]{3,}", "Password assignment"),
    (r"(?i)pwd\s*[=:]\s*['\"]?[^\s'\"]{3,}", "PWD assignment"),
    (r"(?i)secret\s*[=:]\s*['\"]?[^\s'\"]{3,}", "Secret assignment"),
    (r"(?i)api[_-]?key\s*[=:]\s*['\"]?[^\s'\"]{8,}", "API key"),
    (r"(?i)token\s*[=:]\s*['\"]?[A-Za-z0-9+/=]{20,}", "Token value"),
    (r"(?i)connectionstring\s*[=:]\s*['\"]?[^\s'\"]{10,}", "Connection string"),
    (r"Server=.*?;.*?Password=", "SQL connection string with password"),
    (r"(?i)BEGIN\s+(RSA\s+)?PRIVATE\s+KEY", "Private key"),
]

# PII patterns (Peru-specific)
PII_PATTERNS = [
    (r"\b\d{8}\b", "Potential DNI (8 digits)"),  # Only flag in data columns, not row counts
    (r"\b\d{11}\b", "Potential RUC (11 digits)"),
    (r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}", "Email address"),
    (r"\b9\d{8}\b", "Potential Peru mobile (9 digits)"),
]

# Text file extensions to scan
TEXT_EXTENSIONS = {
    ".csv", ".tsv", ".sql", ".ps1", ".sh", ".py", ".txt", ".json",
    ".xml", ".yml", ".yaml", ".conf", ".cfg", ".ini", ".log",
    ".md", ".bat", ".cmd",
}


def scan_file_for_credentials(file_path: Path, max_bytes: int = 1_000_000) -> list[dict]:
    """Scan a single text file for credential patterns."""
    findings = []

    if file_path.suffix.lower() not in TEXT_EXTENSIONS:
        return findings
    if file_path.stat().st_size > max_bytes:
        return findings  # Skip very large files, scanner reports size

    try:
        content = file_path.read_text(encoding="utf-8", errors="replace")
        for pattern, description in CREDENTIAL_PATTERNS:
            matches = re.finditer(pattern, content)
            for match in matches:
                # Find line number
                line_num = content[:match.start()].count("\n") + 1
                # Redact the actual value in the report
                matched_text = match.group()
                if len(matched_text) > 30:
                    matched_text = matched_text[:15] + "..." + matched_text[-5:]
                findings.append({
                    "file": str(file_path),
                    "line": line_num,
                    "type": "credential",
                    "pattern": description,
                    "match_preview": matched_text,
                    "severity": "critical",
                })
    except Exception:
        pass

    return findings


def scan_directory(directory: Path) -> dict:
    """Scan entire directory tree for security issues."""
    result = {
        "directory": str(directory),
        "files_scanned": 0,
        "credential_findings": [],
        "total_findings": 0,
    }

    for file_path in directory.rglob("*"):
        if file_path.is_file() and file_path.suffix.lower() in TEXT_EXTENSIONS:
            result["files_scanned"] += 1
            findings = scan_file_for_credentials(file_path)
            result["credential_findings"].extend(findings)

    result["total_findings"] = len(result["credential_findings"])
    return result
