"""Safe CSV reader with auto-detection of encoding and delimiter."""

import csv
import io
from pathlib import Path
from typing import Optional


def detect_encoding(file_path: Path, sample_size: int = 8192) -> str:
    """Detect file encoding. Tries BOM first, then chardet, fallback UTF-8."""
    raw = file_path.read_bytes()[:sample_size]

    # Check BOM
    if raw.startswith(b"\xef\xbb\xbf"):
        return "utf-8-sig"
    if raw.startswith(b"\xff\xfe"):
        return "utf-16-le"
    if raw.startswith(b"\xfe\xff"):
        return "utf-16-be"

    try:
        import chardet
        result = chardet.detect(raw)
        if result and result["confidence"] > 0.7:
            return result["encoding"]
    except ImportError:
        pass

    # Try UTF-8
    try:
        raw.decode("utf-8")
        return "utf-8"
    except UnicodeDecodeError:
        pass

    return "latin-1"


def detect_delimiter(file_path: Path, encoding: str, sample_lines: int = 5) -> str:
    """Detect CSV delimiter by counting occurrences in first lines."""
    with open(file_path, "r", encoding=encoding, errors="replace") as f:
        lines = []
        for _ in range(sample_lines):
            line = f.readline()
            if not line:
                break
            lines.append(line)

    if not lines:
        return ","

    # Count candidates
    candidates = {",": 0, "\t": 0, ";": 0, "|": 0}
    for line in lines:
        for delim in candidates:
            candidates[delim] += line.count(delim)

    best = max(candidates, key=candidates.get)
    return best if candidates[best] > 0 else ","


def read_csv_headers(file_path: Path) -> dict:
    """Read CSV headers and basic stats without loading entire file."""
    encoding = detect_encoding(file_path)
    delimiter = detect_delimiter(file_path, encoding)

    result = {
        "file": str(file_path),
        "encoding": encoding,
        "delimiter": repr(delimiter),
        "headers": [],
        "row_count": 0,
        "sample_rows": [],
        "empty_columns": [],
        "errors": [],
    }

    try:
        with open(file_path, "r", encoding=encoding, errors="replace") as f:
            reader = csv.reader(f, delimiter=delimiter)
            headers = next(reader, None)
            if headers:
                result["headers"] = [h.strip() for h in headers]

            # Count rows and sample first 5
            row_count = 0
            empty_tracker = [0] * len(result["headers"]) if result["headers"] else []
            for row in reader:
                row_count += 1
                if row_count <= 5:
                    result["sample_rows"].append(row[:10])  # limit columns in sample
                # Track empty columns
                for i, val in enumerate(row):
                    if i < len(empty_tracker) and val and val.strip():
                        empty_tracker[i] += 1

            result["row_count"] = row_count
            # Columns where 0 rows have data
            if result["headers"] and row_count > 0:
                result["empty_columns"] = [
                    result["headers"][i]
                    for i in range(len(empty_tracker))
                    if empty_tracker[i] == 0
                ]
    except Exception as e:
        result["errors"].append(str(e))

    return result


def read_csv_stats_chunked(file_path: Path, chunk_size: int = 10000) -> dict:
    """Read large CSV in chunks, return statistics without loading all into memory."""
    encoding = detect_encoding(file_path)
    delimiter = detect_delimiter(file_path, encoding)

    stats = {
        "file": str(file_path),
        "file_size_mb": round(file_path.stat().st_size / (1024 * 1024), 2),
        "encoding": encoding,
        "delimiter": repr(delimiter),
        "headers": [],
        "total_rows": 0,
        "column_count": 0,
        "empty_columns": [],
        "errors": [],
    }

    try:
        import pandas as pd
        chunks = pd.read_csv(
            file_path,
            encoding=encoding,
            sep=delimiter if delimiter != repr(delimiter) else delimiter,
            chunksize=chunk_size,
            low_memory=False,
            on_bad_lines="warn",
        )
        total_rows = 0
        null_counts = None
        for chunk in chunks:
            if not stats["headers"]:
                stats["headers"] = list(chunk.columns)
                stats["column_count"] = len(chunk.columns)
                null_counts = chunk.isnull().sum()
            else:
                null_counts += chunk.isnull().sum()
            total_rows += len(chunk)

        stats["total_rows"] = total_rows
        if null_counts is not None and total_rows > 0:
            stats["empty_columns"] = [
                col for col, cnt in null_counts.items()
                if cnt == total_rows
            ]
    except ImportError:
        # Fallback without pandas
        return read_csv_headers(file_path)
    except Exception as e:
        stats["errors"].append(str(e))

    return stats
