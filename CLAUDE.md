# Proyecto: Assessment 360° - Integratel Perú

## Contexto
Stefanini ejecuta la Fase 1 (Assessment 360°) del Proyecto de Transformación Data para Integratel Perú S.A.A. (telco).
No se implementa nada — solo diagnóstico, análisis, diseño de arquitectura To-Be y roadmap.

- **Cliente:** Integratel Perú S.A.A.
- **Ejecutor:** Stefanini
- **Duración:** 18 semanas (09-Mar-2026 → 10-Jul-2026)
- **Metodología:** Scrum (sprints de 2 semanas)
- **Alcance:** 45 activos tecnológicos, 15 gerencias, 10 dominios TM Forum SID, 6 familias de BD

## Fases
| Fase | Sprints | Peso | Entregable clave |
|------|---------|------|------------------|
| EPIC 0 – Movilización | S0 (4 sem) | 10% | MEPs + OpenMetadata operativo + Kickoff |
| Discovery 360° | S1-S3 | 40% | Inventario 360° + Lineage + Catálogo As-Is |
| Mutualización | S4-S5 | 20% | Matriz Mutualización + Procesos Críticos + NÚCLEO |
| To-Be + Roadmap | S6-S7 | 30% | Arquitectura Lakehouse + Sizing + Roadmap 12m |

## Dominios SID (prioridad)
D7 Billing (10 activos) → D2 Product (7) → D3 Customer Care (6) → D4 Service Assurance (4) → D10 Common/IT (5) → D1 Market & Sales (4) → D6 Mediation (3, crítica) → D5 Network (3, condicional) → D9 Risk/Fraud (2) → D8 Finance (1)

## Motores de BD
MSSQL (21), MySQL (8), Oracle (8), PostgreSQL (3), MongoDB (1), Teradata (1)

## Principios clave
1. **Evidence-First** — Todo se sustenta con MEPs (Minimum Evidence Pack, 8 carpetas A-H)
2. **Catalog-First** — OpenMetadata es la fuente de verdad
3. **Trazabilidad** — Fuente → MEP → OpenMetadata → Análisis → Entregable
4. **SAI** — Pipeline de análisis asistido con IA (bottom-up progresivo)

## Equipo Stefanini (operativo)
- PM: Jytte Mørk | DSM: Luz Espinoza | Arquitecto: Jorge Ramirez
- Pod 1 (SME_1 Fabio Iregui): D1, D3, D7, D8, D9 — 23 servidores
- Pod 2 (SME_2 Jacqueline Rodríguez): D2, D4, D5, D6, D10 — 22 servidores
- Transversal: 2 Mid Data Eng + 2 Mid BI + 1 Governance + 1 AI Specialist

## Equipo Integratel (clave)
- Sponsors: Wilfredo Espinoza, Javier Dietz
- PM/SPOC: Noemi Guerra, Hernán Ruiz
- 24 focales por dominio

## Estado Actual: Fase de Extracción (EPIC 0)
Estamos en la fase de recolección de MEPs. Los Gatherers (scripts de extracción) están casi listos y ya se comienza a recibir data extraída.

## Gatherers — Scripts de Extracción de Metadatos
Ubicación: `Gatherers/`

### MEP Packs por Motor (scripts principales)
| Pack | Versión | Script Principal | Motor(es) | Líneas |
|------|---------|-----------------|-----------|--------|
| `MEP_Pack_Integratel_MSSQL_ORACLE_v5.6/` | v5.6 | `gather_sqlserver.ps1` + `export_etl.ps1` + `gather_oracle_19c.sh` | MSSQL (2008R2-2022), Oracle 19c | 1248 + 1187 + ~900 |
| `MEP_Pack_Integratel_MYSQL_v5.8.2/` | v5.8.2 | `gather_mysql.ps1` + `mep_mysql_gather.sh` | MySQL 5.7/8.0 | 336 + 279 |
| `MEP_Pack_Integratel_PG_TD_v5.3/` | v5.3 | `gather_postgres.sh` + `gather_teradata_v17.sql` | PostgreSQL 13/16, Teradata v17 | 897 |
| `MEP_Pack_Integratel_Laptop_v1/` | v1 | (minimal) | PostgreSQL v13 local | — |

### Gatherers Especiales
| Directorio | Tipo | Script |
|------------|------|--------|
| `Cloudera NiFi & Hive/` | NiFi REST API + Hive DDL | `dump_nifi_flows.py` (605 ln) + `export_hive_ddl.sh` |
| `Gerencia_de_VPF_Mediador_CDRs_EDR/` | Middleware (no BD) | Manual/documental (Excel) |
| `MEP_Gerencia_de_Revenue_Cost Assurance.../` | Oracle (JAZZIT) | `gather_oracle_19c.sh` |
| `MEP_GPPESVLCLI225_C_Diccionario_BD/` | MSSQL standalone | `gather_sqlserver.ps1` + `export_etl.ps1` |

### Estructura de cada MEP Pack
Cada pack replica la estructura de 8 carpetas MEP por gerencia → servidor:
```
MEP_Pack_<Motor>/
  └── <Gerencia>/
      └── MEP_<Servidor>/
          ├── A_Ficha_Funcional/
          ├── B_Software_Servicios/
          ├── C_Diccionario_BD/        ← scripts aquí (gather_*.ps1|.sh)
          │   └── scripts/ o oracle/
          ├── D_Jobs_ETL_ELT/          ← export_etl.ps1 (SSIS)
          ├── E_Interfaces_IO/
          ├── F_BI_Artefactos/
          ├── G_Lineage_Documentacion/
          └── H_Seguridad_Accesos/
```

### Qué extrae cada Gatherer
| Gatherer | Extrae |
|----------|--------|
| `gather_sqlserver.ps1` | Schemas, SPs, functions, triggers, indexes, table stats, SQL Agent jobs, linked servers, permisos, volumetrías. 14 categorías por schema. Auto-detecta versión (2008R2-2022) |
| `export_etl.ps1` | Paquetes SSIS (.dtsx): SSISDB + msdb legacy + Agent jobs + file system. Extrae SQL embebido, conexiones, dataflows. Redacta passwords |
| `gather_oracle_19c.sh` | Schemas, PL/SQL (packages, procedures, functions, triggers), DBMS_SCHEDULER jobs, DB links, tablespaces, stats |
| `gather_mysql.ps1` / `mep_mysql_gather.sh` | Schemas, columnas, constraints, routines, triggers, views. DDL vía mysqldump --no-data |
| `gather_postgres.sh` | 41 CSVs: diccionario completo, CDC readiness (WAL, replication slots, publications), materialized views, FDW, particiones, pg_cron, estadísticas de cambio |
| `gather_teradata_v17.sql` | Metadata Teradata v17 |
| `dump_nifi_flows.py` | NiFi: process groups, processors, connections, templates, controller services, variables. Output JSON |
| `export_hive_ddl.sh` | DDL de todas las tablas Hive (CREATE TABLE) |

### Output de Gatherers
- **CSV/TSV** — Tablas de metadatos (todos los motores)
- **JSON** — NiFi flows, manifests
- **XML** — SSIS packages (.dtsx)
- **SQL** — DDL statements
- **XLSX** — Documentación manual (interfaces, BI, accesos)

## MEP Master Tracker
Archivo: `MEP_00_Master_Tracker 1.xlsx` (hoja: "MEP Tracker")
- **36 MEPs registrados** (Nro 1-36, falta #33)
- Columnas de seguimiento por carpeta: A01 Ficha, B Servicios, C Orquestador, D ETL/Jobs, E Interfaces, F BI, H Accesos
- Status General y Notas por MEP
- 3 MEPs con servidor "Por identificar" (#23, #34, #35-36)
- 3 MEPs con gerencia "Por identificar" (#30, #31, #32)

## Sistema de QA Automatizado
- **Skill:** `/qa-mep <ruta>` o `/qa-mep all` o `/qa-mep dashboard`
- **Scanner Python:** `mep_qa/scanner.py` — recoge hechos crudos (estructura, CSVs, ZIPs, seguridad) → JSON
- **Claude razona** sobre el JSON + lee archivos clave directamente para evaluación cualitativa
- **Reportes:** `qa_reports/<MEP_NAME>/qa_report.md` + `findings.json` + dashboard consolidado
- **Checklist mapping:** `mep_qa/config/checklist_mapping.py` — mapea 23 ítems manuales a checks auto/claude/manual

### Flujo del Skill /qa-mep
1. Detecta MEP y motor de BD
2. Corre `python3 mep_qa/scanner.py` → JSON con hechos
3. Claude lee el JSON + archivos clave (ficha funcional, CSVs, interfaces, jobs)
4. Claude evalúa cualitativamente (coherencia semántica, adecuación al dominio, cross-references)
5. Claude genera reporte Markdown con score (A-F) y recomendaciones
6. Opcionalmente pre-llena el Excel del checklist QA

## Sistema de Reconstrucción
- **Skill:** `/reconstruct-mep <ruta>` — reconstruye esquemas, lineage, diagramas ER, inventario de lógica de negocio
- **Scanner Python:** `mep_reconstruct/scanner.py` — parsea CSVs, SSIS .dtsx, agent jobs → DDL + ER + lineage graph
- **Reportes:** `reconstruct_reports/<MEP_NAME>/` → reconstruct_scan.json + reconstructed_ddl.sql + er_diagram.mmd + reconstruct_report.md
- **Flujo:** Se ejecuta DESPUÉS de `/qa-mep` (requiere C_Diccionario_BD con datos válidos)

## Output de MEPs Recibidos
Directorio: `Output_MEPs_Integratel/`
- 11 MEPs recibidos en 7 categorías (Departamentales, Mediador, ALDM, RED, DITO, VISOR, Hortonworks)
- 192 MB total, generados entre 2026-02-20 y 2026-03-17

## Reglas para Claude
- El documento de referencia completo está en `PROJECT_INIT.md`
- El PDF original está en `FPE-001-LAT Project Governance Integratel_Oficial 12032026.pdf`
- Todo el trabajo que se desarrolle en este repo debe alinearse con los entregables, dominios SID, estructura MEP y cronograma del proyecto
- Usar terminología del proyecto: MEP, dominio SID, NÚCLEO, OpenMetadata (OM), RAID log, Decision Log
- Los entregables siguen versionamiento progresivo: v0.3 → v0.5 → v0.8 → v1.0
- Los Gatherers están en `Gatherers/` — cada motor tiene su propio script de extracción
- El tracking de MEPs está en `MEP_00_Master_Tracker 1.xlsx`
- QA de MEPs: usar skill `/qa-mep` que combina scanner Python + razonamiento Claude
