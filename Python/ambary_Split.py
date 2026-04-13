import gzip

input_file = 'Ambari_Databases.sql'
num_parts = 5

with open(input_file, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

total_lines = len(lines)
lines_per_part = total_lines // num_parts

for i in range(num_parts):
    part_lines = lines[i*lines_per_part:(i+1)*lines_per_part]
    
    gz_filename = f"Ambari_part_{i+1}.sql.gz"
    
    with gzip.open(gz_filename, 'wt', encoding='utf-8') as gz_file:
        gz_file.writelines(part_lines)

print("División lógica por líneas completada 🔥")