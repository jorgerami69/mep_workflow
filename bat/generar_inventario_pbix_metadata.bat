@echo off
setlocal

set "REPO=C:\data\workspace\mep_workflow"
set "INPUT=C:\data\workspace\PbixMetadataOut"
set "OUTPUT=C:\data\workspace\PbixMetadataOut\pbix_forensics_inventory.xlsx"
set "SCRIPT=%REPO%\Python\pbix_forensics_inventory_excel.ps1"

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" -InputFolder "%INPUT%" -OutputFile "%OUTPUT%"

if errorlevel 1 (
    echo ERROR: No se pudo generar el inventario PBIX.
    exit /b 1
)

echo OK: Inventario generado en "%OUTPUT%"
endlocal
