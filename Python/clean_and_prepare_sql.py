import re

input_file = "Ambari_Databases.sql"
output_file = "Ambari_metadata_final.sql"

def is_system_or_problematic(name):
    name = name.lower()
    return (
        name.startswith("mysql.") or
        "innodb" in name or
        name.endswith("_stats") or
        "index_stats" in name or
        "table_stats" in name
    )

def extract_table_name(line):
    match = re.search(r'`([^`]+)`', line)
    return match.group(1) if match else None

skip_block = False

with open(input_file, "r", encoding="utf-8", errors="ignore") as f_in, \
     open(output_file, "w", encoding="utf-8") as f_out:

    for line in f_in:

        line_lower = line.lower().strip()

        # ❌ eliminar INSERTS (no sirven para metadata)
        if line_lower.startswith("insert into"):
            continue

        # ❌ eliminar locks
        if "lock tables" in line_lower or "unlock tables" in line_lower:
            continue

        # 🔥 detectar inicio de bloque problemático
        if "table structure for table" in line_lower:
            table_name = extract_table_name(line)
            if table_name and is_system_or_problematic(table_name):
                skip_block = True
                continue

        # 🔥 salir del bloque cuando termina
        if skip_block:
            if "unlock tables" in line_lower:
                skip_block = False
            continue

        # 🔥 manejar CREATE TABLE
        if "create table" in line_lower:
            table_name = extract_table_name(line)

            if table_name:
                if is_system_or_problematic(table_name):
                    # 👉 renombrar tabla conflictiva
                    new_name = f"AMB_{table_name}"
                    print(f"[WARN] Renombrando tabla problemática: {table_name} → {new_name}")
                    line = line.replace(f"`{table_name}`", f"`{new_name}`")

        # 🔥 manejar DROP TABLE
        if "drop table" in line_lower:
            table_name = extract_table_name(line)

            if table_name:
                if is_system_or_problematic(table_name):
                    new_name = f"AMB_{table_name}"
                    line = line.replace(f"`{table_name}`", f"`{new_name}`")

        # ❌ eliminar referencias directas a mysql schema
        if "mysql." in line_lower:
            continue

        f_out.write(line)

print("\n🔥 Archivo limpio generado:", output_file)
print("👉 Listo para cargar sin romper nada")