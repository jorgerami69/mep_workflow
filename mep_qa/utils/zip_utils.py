"""Safe ZIP extraction and inventory utilities."""

import zipfile
import tarfile
from pathlib import Path
from typing import Optional


def inventory_zip(zip_path: Path) -> dict:
    """List contents of a ZIP file without extracting."""
    result = {
        "zip_file": str(zip_path),
        "zip_size_mb": round(zip_path.stat().st_size / (1024 * 1024), 2),
        "is_valid": False,
        "file_count": 0,
        "total_uncompressed_mb": 0,
        "entries": [],
        "has_mep_structure": False,
        "top_level_dirs": [],
        "errors": [],
    }

    try:
        with zipfile.ZipFile(zip_path, "r") as zf:
            result["is_valid"] = True
            result["file_count"] = len(zf.namelist())

            total_size = 0
            top_dirs = set()
            mep_dirs = {"A_", "B_", "C_", "D_", "E_", "F_", "G_", "H_"}

            for info in zf.infolist():
                total_size += info.file_size
                entry = {
                    "name": info.filename,
                    "size": info.file_size,
                    "is_dir": info.is_dir(),
                    "compressed_size": info.compress_size,
                }
                result["entries"].append(entry)

                # Track top-level directories
                parts = info.filename.split("/")
                if len(parts) > 1:
                    top_dirs.add(parts[0])

            result["total_uncompressed_mb"] = round(total_size / (1024 * 1024), 2)
            result["top_level_dirs"] = sorted(top_dirs)

            # Check if ZIP contains MEP structure (A-H subcarpetas)
            all_names = " ".join(zf.namelist())
            result["has_mep_structure"] = any(
                d in all_names for d in mep_dirs
            )

    except zipfile.BadZipFile:
        result["errors"].append("Corrupt ZIP file")
    except Exception as e:
        result["errors"].append(str(e))

    return result


def extract_zip_to_temp(zip_path: Path, dest: Path) -> dict:
    """Extract ZIP to destination, return extraction report."""
    result = {
        "zip_file": str(zip_path),
        "dest": str(dest),
        "extracted_count": 0,
        "errors": [],
    }

    try:
        dest.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(zip_path, "r") as zf:
            zf.extractall(dest)
            result["extracted_count"] = len(zf.namelist())
    except Exception as e:
        result["errors"].append(str(e))

    # Check for nested tar.gz
    for tgz in dest.rglob("*.tar.gz"):
        try:
            with tarfile.open(tgz, "r:gz") as tf:
                tf.extractall(tgz.parent, filter="data")
        except Exception as e:
            result["errors"].append(f"Failed to extract {tgz.name}: {e}")

    return result
