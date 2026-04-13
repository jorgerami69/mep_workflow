input_file = "Ambari_Databases.sql"
output_file = "Ambari_metadata_clean.sql"

skip_block = False

with open(input_file, "r", encoding="utf-8", errors="ignore") as f_in, \
     open(output_file, "w", encoding="utf-8") as f_out:

    for line in f_in:

        line_lower = line.lower()

        # 🔴 Detectar cualquier tabla *_stats o mysql system
        if any(x in line_lower for x in [
            "table structure for table",
            "innodb_",
            "_stats",
            "mysql."
        ]):
            skip_block = True

        # 🔴 Saltar bloque completo
        if skip_block:
            if "unlock tables" in line_lower:
                skip_block = False
            continue

        # ❌ eliminar inserts (no metadata)
        if line.strip().upper().startswith("INSERT INTO"):
            continue

        # ❌ eliminar locks
        if "lock tables" in line_lower or "unlock tables" in line_lower:
            continue

        # ✔ mantener lo útil
        f_out.write(line)

print("SQL limpio TOTAL generado 🔥")