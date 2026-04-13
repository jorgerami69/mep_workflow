import gzip
import shutil

with gzip.open('Ambari_Databases.sql.gz_07032026-022805', 'rb') as f_in:
    with open('Ambari_Databases.sql', 'wb') as f_out:
        shutil.copyfileobj(f_in, f_out)