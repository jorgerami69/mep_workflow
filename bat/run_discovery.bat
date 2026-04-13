@echo off

echo ==========================================
echo Cloudera Metadata Discovery Tool
echo ==========================================

echo.
echo Verificando Python...

python --version
if %errorlevel% neq 0 (
    echo Python no esta instalado
    pause
    exit
)

echo.
echo Instalando librerias necesarias...

pip install pyhive
pip install pandas
pip install thrift
pip install sasl
pip install thrift_sasl
pip install openpyxl

echo.
echo Ejecutando discovery...

python discovery_cloudera.py

echo.
echo ==========================================
echo Discovery terminado
echo Revisar archivo cloudera_metadata_inventory.xlsx
echo ==========================================

pause