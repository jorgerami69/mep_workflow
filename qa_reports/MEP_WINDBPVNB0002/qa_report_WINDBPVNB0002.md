# QA Report - MEP_WINDBPVNB0002

## 1. Informacion General

| Campo | Valor |
|-------|-------|
| **Servidor** | WINDBPVNB0002\PRODTDPPLANICO |
| **IP** | 172.30.249.167 |
| **Motor** | Microsoft SQL Server 2014 SP3 (12.0.6024.0) |
| **Edicion** | Enterprise Edition (64-bit) |
| **SO** | Windows NT 6.3 (Build 14393) (Hypervisor) |
| **Gerencia** | Gerencia de Atencion (D3 Customer Care) |
| **Focal** | B.Quispe / R.Smith |
| **Tracker** | #13 |
| **SME** | SME_1 |
| **Clasificacion** | LARGEST |
| **Bases de Datos** | 32 user databases |
| **Tamano Total BD** | 8,012.6 GB (7,882.4 GB datos + 130.2 GB log) |
| **Archivos MEP** | 1,424 archivos, 231 MB |
| **Fecha Extraccion** | 2026-03-16 |
| **Fecha QA** | 2026-03-20 |
| **RAM** | 128 GB (131,071 MB) |
| **CPUs** | 16 |
| **Cluster/HADR** | No / No |
| **Collation** | SQL_Latin1_General_CP1_CI_AS |

## 2. Resumen Ejecutivo

El servidor WINDBPVNB0002 es una instancia Enterprise de SQL Server 2014 SP3 que soporta la operacion de la Gerencia de Atencion al Cliente (D3 Customer Care). Con 32 bases de datos de usuario, 8 TB de datos, 3,931 tablas, 1,138 stored procedures y 690 vistas, constituye uno de los servidores de mayor escala en el inventario de postventa. La instancia nombrada PRODTDPPLANICO concentra repositorios funcionales de Contact Center, Retenciones, Demanda, Ventas, Planta, Regulatoria y multiples areas de negocio, alimentados por 78 proyectos SSIS y 177 Agent Jobs.

La extraccion MEP es sustancialmente completa y de buena calidad. Se obtuvieron las 8 subcarpetas (A-H), 788 CSVs con 187,287 filas de metadata, 276 paquetes SSIS exportados de SSISDB/MSDB, y archivos de instancia con configuracion del servidor, logins, linked servers y agent jobs. El diccionario de datos cubre las 32 bases de datos con sus respectivos esquemas (dbo, STAGE, DIM, FACT, catalog, internal). La extraccion de ETL fue exitosa con cobertura completa de los 78 proyectos SSISDB. Las subcarpetas B (Software/Servicios), D (Jobs/ETL), E (Interfaces), F (BI) y H (Seguridad) contienen sus respectivos archivos de documentacion.

Los hallazgos criticos se concentran en seguridad: se detectaron 3 passwords literales en stored procedures de produccion y 1 password en un paquete SSIS, lo que representa un riesgo critico que debe remediarse antes de la migracion. Adicionalmente, la subcarpeta G (Lineage/Documentacion) esta marcada como "no aplica" lo cual es injustificable para un servidor de esta escala. El score final de 66/100 (Grado C) resulta en APROBADO CON OBSERVACIONES, condicionado a la remediacion de los hallazgos de seguridad y la entrega de documentacion de lineage.

## 3. Scores

### Scores por Subcarpeta

| Subcarpeta | Nombre | Score | Justificacion |
|------------|--------|-------|---------------|
| A | Ficha Funcional | 75/100 | Ficha A01 presente (17 KB DOCX). No verificable automaticamente. Contenido no validado. |
| B | Software y Servicios | 85/100 | 7 archivos completos: sc_query, services, processes, tasklist, installed_programs, netstat, README. Cobertura excelente. |
| C | Diccionario BD | 90/100 | 1,406 archivos, 230.3 MB. 32 BDs documentadas con S01-S14. 788 CSVs. Extraccion exitosa y completa. 276 paquetes SSIS. |
| D | Jobs ETL/ELT | 80/100 | D40_scheduled_tasks.csv (259 tareas). Agent Jobs en C (177 jobs, 465 steps). Cobertura buena. |
| E | Interfaces I/O | 70/100 | E01_E02 presente (9.3 KB). Pendiente validacion cruzada con 8 linked servers y conexiones SSIS. |
| F | BI Artefactos | 70/100 | F01_Reportes_BI presente (9.3 KB). Artefactos BI basados en Excel/scheduled tasks. |
| G | Lineage/Documentacion | 25/100 | Solo contiene 'no aplica.txt' (vacio). Injustificable para 32 BDs, 78 proyectos SSIS, 8 linked servers. |
| H | Seguridad/Accesos | 70/100 | H01_Accesos presente (9 KB). Logins y permisos documentados en CSVs. Pero passwords literales en SPs/SSIS. |

### Penalizaciones

| Penalizacion | Puntos | Detalle |
|--------------|--------|---------|
| Credenciales hardcodeadas | -5 | Passwords en texto plano en stored procedures y paquetes SSIS |

### Score Final

| Metrica | Valor |
|---------|-------|
| **Promedio Raw** | 70.6 |
| **Penalizaciones** | -5 |
| **Score Overall** | 66 |
| **Grado** | C |
| **Veredicto** | APROBADO CON OBSERVACIONES |

## 4. Evaluacion por Subcarpeta

### 4.1 A (75/100)

**Archivos:**
- `A01_Ficha_Funcional_WINDBPVNB0002.docx` (17,723 bytes)

**Evaluacion:**
La ficha funcional existe en formato DOCX y tiene un tamano razonable. No se puede validar automaticamente el contenido del documento Word. Se asume que contiene la descripcion funcional del servidor, responsables y dependencias, pero esto debe verificarse manualmente por el equipo QA. No existe una ficha de infraestructura dedicada adicional.

### 4.2 B (85/100)

**Archivos:**
- `B10_sc_query.txt` (166 KB) - Consulta de servicios Windows (sc query)
- `B10_services_ps.txt` (53 KB) - Servicios via PowerShell
- `B11_process_cmdline.csv` (42 KB) - Procesos con linea de comandos (345 registros)
- `B11_tasklist_svc.txt` (30 KB) - Tasklist con servicios
- `B12_installed_programs.csv` (40 KB) - Programas instalados (431 registros)
- `B13_netstat.txt` (63 KB) - Conexiones de red
- `README_Instrucciones.md` (702 bytes)

**Evaluacion:**
Cobertura excelente de la capa de software y servicios. Se confirman los servicios SQL activos (MSSQL$PRODTDPPLANICO, SQLAgent$PRODTDPPLANICO, SSIS). Puerto SQL 1433 abierto con conexiones ESTABLISHED desde 10.4.40.227 y 10.226.32.31. Se identifican 431 programas instalados y 345 procesos activos. El netstat muestra conectividad activa con los linked servers documentados.

### 4.3 C (90/100)

**Archivos:**
- Directorio `mep_sqlserver_WINDBPVNB0002_20260316_095359/` con 32 bases de datos documentadas
- Directorio `mep_etl_WINDBPVNB0002_20260316_095734/` con 276 paquetes SSIS
- `_instance/`: 00_version.txt, 01_server_config.csv, 02_linked_servers.csv, 03_agent_jobs.csv, 04_logins.csv, 05_databases.csv
- Por cada BD: `_database/` (01_principals, 02_role_members, 03_permissions, 04_object_summary) + schemas con S01-S14
- ETL: all_job_steps.csv (1,294 filas), ssis_job_steps.csv (110 filas), cmdexec_powershell_steps.csv (16 filas)
- SSIS: 78 proyectos SSISDB, 9 paquetes MSDB, inventory.csv, execution_history.csv, environments.csv
- Scripts: gather_sqlserver.ps1, export_etl.ps1, MEP_Gatherer.bat
- 1 ZIP: scripts.zip
- Total: 1,406 archivos, 230.3 MB

**Evaluacion:**
Extraccion excepcional para un servidor de esta escala. Los 32 bases de datos tienen documentacion completa con archivos S01 (tables/columns), S02 (PKs), S03 (tables sin PK), S04 (FKs), S05 (indexes), S06 (check constraints), S07 (SP code), S08 (function code), S09 (trigger code), S10 (view code), S11 (table sizes), S12 (extended properties), S13 (dependencies), S14 (user types). Los 788 CSVs suman 187,287 filas de metadata. La extraccion de ETL con 276 paquetes SSIS es completa. Se descuenta por la ausencia de algunos archivos del formato esperado por el scanner (00_server_info.csv con nombre exacto) aunque los datos equivalentes existen en el formato nuevo.

### 4.4 D (80/100)

**Archivos:**
- `D40_scheduled_tasks.csv` (259 tareas programadas de Windows)
- Agent Jobs en C: `03_agent_jobs.csv` (177 jobs, 465 steps)
- `README_Instrucciones.md`

**Evaluacion:**
Buena cobertura de ETL/Jobs. Los 177 Agent Jobs (152 habilitados) estan documentados con detalle de steps, subsistemas (354 TSQL, 109 SSIS, 2 CmdExec/PS), schedules y bases de datos destino. Las 259 tareas programadas de Windows complementan el Agent con procesos de actualizacion de Excel desde rutas en disco K:\\. La nomenclatura de jobs sigue un patron estructurado con prefijos de fecha y responsable (GPR_, JCO_, GMC_, KCS_).

### 4.5 E (70/100)

**Archivos:**
- `E01_E02_Interfaces_WINDBPVNB0002.xlsx` (9,282 bytes)
- `README_Instrucciones.md`

**Evaluacion:**
Las interfaces estan documentadas en un unico archivo Excel. El servidor tiene 8 linked servers activos (7 SQL Server + 1 Teradata) y multiples conexiones SFTP/FTP detectadas en paquetes SSIS. No se puede verificar automaticamente que el Excel E01 cubra exhaustivamente todas las interfaces. Pendiente validacion manual contra los 8 linked servers, las connection strings de SSIS y las conexiones detectadas en netstat.

### 4.6 F (70/100)

**Archivos:**
- `F01_Reportes_BI_WINDBPVNB0002.xlsx` (9,282 bytes, aprox.)
- `README_Instrucciones.md`

**Evaluacion:**
Los artefactos BI estan documentados en un archivo Excel. El servidor no tiene SSAS ni SSRS instalados; los reportes se generan mediante procesos que actualizan archivos Excel automaticamente via scheduled tasks de Windows (259 tareas que ejecutan scripts .bat desde K:\\ActulizacionExcel\\ y K:\\Inteligencia_de_Clientes\\). Este modelo de BI basado en Excel automatizado debe documentarse con mayor detalle para la migracion.

### 4.7 G (25/100)

**Archivos:**
- `no aplica.txt` (0 bytes - vacio)
- `README_Instrucciones.md`

**Evaluacion:**
La subcarpeta G esta marcada como "no aplica" con un archivo vacio. Esto es completamente injustificable para un servidor de esta magnitud: 32 bases de datos interrelacionadas, 78 proyectos SSIS que mueven datos entre bases, 8 linked servers que conectan con otros 7 servidores SQL y Teradata, 276 paquetes DTSX con transformaciones complejas, y 177 Agent Jobs orquestando el flujo de datos. La falta de documentacion de lineage es el hallazgo mas grave del MEP desde el punto de vista de completitud.

### 4.8 H (70/100)

**Archivos:**
- `H01_Accesos_WINDBPVNB0002.xlsx` (8,989 bytes)
- `README_Instrucciones.md`

**Evaluacion:**
Los accesos estan documentados en Excel H01. Los datos de seguridad del servidor muestran 40 logins (31 habilitados, 9 deshabilitados), con 22 SQL logins y 18 Windows logins. Los principals, roles y permisos estan documentados en CSVs por cada BD. Sin embargo, se detectaron 3 passwords literales en stored procedures y 1 en un paquete SSIS, lo que constituye un hallazgo critico de seguridad. El cruce entre H01 y los CSVs de logins/permisos debe validarse manualmente.

## 5. Hallazgos

### 5.1 Criticos (FAIL)

| ID | Categoria | Titulo | Impacto |
|----|-----------|--------|---------|
| F-001 | H_Seguridad | Credenciales hardcodeadas en stored procedures (passwords en texto plano) | Passwords visibles: 'q1w2e3r4', '70863013' en Repo_Contact_Center y '%T3l3f0n1c4$1' en Repo_Contactos. Acceso no autorizado a sistemas externos. |
| F-002 | H_Seguridad | Password expuesta en paquete SSIS de Multiconsulta (Telefonica.2021) | Credencial SFTP para 10.4.40.38:22 visible en XML del paquete. Acceso no autorizado al servidor remoto. |
| F-003 | G_Lineage | Subcarpeta G sin documentacion de lineage - marcada 'no aplica' | Imposible trazar flujos de datos entre 32 BDs, 8 linked servers, 78 proyectos SSIS. Bloquea assessment de dependencias. |
| F-004 | C_Diccionario | 97.3% de tablas sin primary key (3,825 de 3,931) | Patron de DW/staging. No requiere correccion pero debe documentarse para el equipo de migracion. |

### 5.2 Advertencias (WARN)

| ID | Categoria | Titulo | Impacto |
|----|-----------|--------|---------|
| F-005 | A_Ficha | Ficha funcional DOCX no verificable automaticamente | Contenido no validable sin revision manual. |
| F-006 | E_Interfaces | Interfaces documentadas sin validacion cruzada completa | 8 linked servers y conexiones SSIS pendientes de cruce con E01. |
| F-007 | H_Seguridad | Referencias a password en scripts de recoleccion | Falsos positivos: variables PowerShell, no credenciales literales. |
| F-008 | C_Diccionario | Connection strings en archivos SSIS | Bajo riesgo: apuntan a archivos locales CSV/TXT, no a BDs. |
| F-009 | C_Diccionario | Esquema anomalo '172.30.249.166' en Repo_Regulatoria | Schema con nombre de IP. Posible error de configuracion. Investigar para migracion. |
| F-010 | C_Diccionario | BD_BACKUP_2022/2023 ocupan 800 GB | Datos historicos que pueden no requerir migracion. Confirmar con equipo funcional. |

### 5.3 Informativos (INFO)

| ID | Categoria | Titulo | Impacto |
|----|-----------|--------|---------|
| F-011 | General | SQL Server 2014 SP3 - End of Extended Support | EOL julio 2024. Sin parches de seguridad. Documentar como riesgo. |
| F-012 | B_Software | Servidor de gran escala: 128 GB RAM, 16 CPUs, 8 TB en BD | Informativo - alta capacidad con workload de produccion. |
| F-013 | B_Software | Servicios activos: Motor, Agent, SSIS - instancia PRODTDPPLANICO | Instancia de produccion completa. |
| F-014 | D_Jobs | 177 Agent Jobs + 259 tareas Windows | Alto volumen de automatizacion con dependencias en disco K:\\. |
| F-015 | C_Diccionario | 78 proyectos SSISDB con 276 paquetes exportados | Extraccion ETL completa y exitosa. |
| F-016 | C_Diccionario | 8 linked servers incluyendo Teradata | Dependencias criticas con 7 SQL Servers y 1 Teradata. |
| F-017 | F_BI | Reportes BI documentados en Excel | BI basado en actualizacion automatica de Excel. |

## 6. Cross-References

| Fuente | Destino | Tipo | Validacion |
|--------|---------|------|------------|
| 02_linked_servers.csv (8 servers) | E01_E02_Interfaces.xlsx | Linked Servers vs Interfaces declaradas | Pendiente cruce manual |
| 04_logins.csv (40 logins) | H01_Accesos.xlsx | Logins del servidor vs accesos documentados | Pendiente cruce manual |
| 03_agent_jobs.csv (177 jobs) | D40_scheduled_tasks.csv (259 tareas) | Agent Jobs vs Scheduled Tasks Windows | Complementarios, no redundantes |
| S07_sp_code.csv (por BD) | SSIS packages (.dtsx) | Stored Procs vs ETL | SPs referenciadas en TSQL steps de Agent Jobs |
| SSIS connection managers | 02_linked_servers.csv | Conexiones SSIS vs Linked Servers | Parcialmente validado |
| 05_databases.csv (32 BDs) | 04_object_summary.csv (por BD) | Inventario BDs vs Objetos por BD | Consistente - todas las BDs documentadas |
| S13_dependencies.csv (por BD) | Lineage G | Dependencias intra-BD vs Lineage | G no documentado - imposible cruzar |
| B13_netstat.txt | 02_linked_servers.csv | Conexiones activas vs Linked Servers | Conexiones activas a 10.4.40.227 confirmadas |

## 7. Estadisticas del Servidor

### 7.1 Bases de Datos

| Base de Datos | Data (MB) | Log (MB) | Recovery | Estado | Tablas | SPs | Vistas |
|---------------|-----------|----------|----------|--------|--------|-----|--------|
| BD_BACKUP_2022 | 595,105 | 200 | FULL | ONLINE | 93 | 0 | 0 |
| BD_BACKUP_2023 | 204,544 | 25 | FULL | ONLINE | 5 | 0 | 0 |
| BD_CONTROL | 1,545 | 4 | FULL | ONLINE | 12 | 7 | 2 |
| Repo_Bolsa | 99,118 | 6,624 | FULL | ONLINE | 34 | 46 | 9 |
| Repo_Canales_Digitales | 91,935 | 4 | FULL | ONLINE | 71 | 26 | 6 |
| Repo_Canales_Escritos | 556,534 | 11,851 | FULL | ONLINE | 115 | 32 | 11 |
| Repo_Clientes | 313,689 | 1,921 | FULL | ONLINE | 68 | 14 | 3 |
| Repo_COC | 492,932 | 3,399 | FULL | ONLINE | 55 | 38 | 32 |
| Repo_Contact_Center | 277,858 | 2,056 | FULL | ONLINE | 95 | 32 | 5 |
| Repo_Contactos | 225,239 | 501 | FULL | ONLINE | 117 | 6 | 21 |
| Repo_Cross | 70,567 | 4 | FULL | ONLINE | 30 | 29 | 1 |
| Repo_Dashboard | 81,794 | 1,585 | FULL | ONLINE | 169 | 56 | 34 |
| Repo_Demanda | 242,224 | 6,621 | FULL | ONLINE | 489 | 156 | 101 |
| Repo_Hispam | 135,000 | 4 | FULL | ONLINE | 174 | 38 | 58 |
| Repo_Incidencias | 16 | 2 | FULL | ONLINE | 11 | 7 | 0 |
| Repo_Indicadores | 209,873 | 2,554 | FULL | ONLINE | 170 | 28 | 7 |
| Repo_Inteligencia | 5,000 | 1 | FULL | ONLINE | 64 | 9 | 4 |
| Repo_Layout | 1,224,482 | 30,437 | FULL | ONLINE | 181 | 93 | 42 |
| Repo_Layout_0 | 197,687 | 4 | FULL | ONLINE | 35 | 0 | 4 |
| Repo_Origen_Matrix | 6,391 | 142 | FULL | ONLINE | 78 | 6 | 1 |
| Repo_Planta | 208,949 | 12,908 | FULL | ONLINE | 126 | 37 | 23 |
| Repo_Planta_Maestras | 499,999 | 10,668 | FULL | ONLINE | 110 | 16 | 12 |
| Repo_Regulatoria | 229,900 | 1,862 | FULL | ONLINE | 352 | 3 | 1 |
| Repo_Reiterada_VCliente | 353,742 | 1,692 | FULL | ONLINE | 165 | 15 | 7 |
| Repo_Retenciones | 186,629 | 16 | FULL | ONLINE | 97 | 39 | 43 |
| Repo_STC | 22,310 | 1 | FULL | ONLINE | 37 | 2 | 6 |
| Repo_Soluciones | 194,026 | 4,113 | FULL | ONLINE | 98 | 24 | 10 |
| Repo_Trazabilidad | 300,000 | 16,503 | FULL | ONLINE | 176 | 121 | 94 |
| Repo_Ventas | 838,773 | 214 | FULL | ONLINE | 582 | 109 | 106 |
| Repo_Web | 177,147 | 1,404 | FULL | ONLINE | 68 | 37 | 7 |
| SSISDB | 8,446 | 15,619 | FULL | ONLINE | 30 | 96 | 33 |
| TP_Inteligencia_Clientes | 20,108 | 379 | FULL | ONLINE | 24 | 26 | 7 |
| **TOTAL** | **7,882,383** | **133,317** | | | **3,931** | **1,138** | **690** |

### 7.2 Objetos

| Tipo de Objeto | Cantidad |
|----------------|----------|
| USER_TABLE | 3,931 |
| VIEW | 690 |
| SQL_STORED_PROCEDURE | 1,138 |
| SQL_SCALAR_FUNCTION | 64 |
| SQL_TABLE_VALUED_FUNCTION | 3 |
| SQL_INLINE_TABLE_VALUED_FUNCTION | 1 |
| CLR_SCALAR_FUNCTION | 4 |
| CLR_STORED_PROCEDURE | 10 |
| CLR_TABLE_VALUED_FUNCTION | 2 |
| PRIMARY_KEY_CONSTRAINT | 106 |
| FOREIGN_KEY_CONSTRAINT | 170 |
| DEFAULT_CONSTRAINT | 59 |
| UNIQUE_CONSTRAINT | 19 |
| CHECK_CONSTRAINT | 4 |
| SYNONYM | 5 |
| SEQUENCE_OBJECT | 1 |
| **Total objetos** | **6,207** |

### 7.3 ETL/Jobs

| Metrica | Valor |
|---------|-------|
| Agent Jobs (total) | 177 |
| Agent Jobs (habilitados) | 152 |
| Agent Job Steps (total) | 465 |
| Steps TSQL | 354 |
| Steps SSIS | 109 |
| Steps CmdExec/PowerShell | 2 |
| Proyectos SSISDB | 78 |
| Paquetes SSIS (.dtsx) exportados | 276 |
| Paquetes MSDB | 9 |
| Scheduled Tasks Windows | 259 |
| SSIS Environments | 1 |
| SSIS Execution History (registros) | 201 |

### 7.4 Seguridad

| Metrica | Valor |
|---------|-------|
| Logins totales | 40 |
| Logins habilitados | 31 |
| Logins deshabilitados | 9 |
| SQL Logins | 22 |
| Windows Logins | 18 |
| Tablas sin Primary Key | 3,825 (97.3%) |
| Hallazgos de seguridad (scanner) | 16 |
| Passwords literales en SPs | 3 |
| Passwords literales en SSIS | 1 |
| Falsos positivos (scripts) | 6 |
| Connection strings (bajo riesgo) | 6 |

### 7.5 Infraestructura

| Metrica | Valor |
|---------|-------|
| Hostname | WINDBPVNB0002 |
| Instancia | PRODTDPPLANICO |
| Version SQL | 12.0.6024.0 (SQL Server 2014 SP3) |
| Edicion | Enterprise Edition (64-bit) |
| Engine Edition | 3 (Enterprise) |
| RAM | 131,071 MB (128 GB) |
| CPUs | 16 |
| Cluster | No |
| HADR (AlwaysOn) | No |
| FullText | Habilitado |
| User Databases | 32 |
| Collation | SQL_Latin1_General_CP1_CI_AS |
| Start Time | 2026-02-06 00:16:58 |
| Linked Servers | 8 (7 SQL Server + 1 Teradata) |
| Puerto SQL | 1433 (LISTENING) |
| Espacio total datos | 7,882 GB (7.7 TB) |
| Espacio total logs | 130 GB |

## 8. Hallazgos de Seguridad

Se investigaron los 16 hallazgos de seguridad reportados por el scanner. A continuacion el desglose completo:

**CRITICOS - Passwords literales en codigo (4 hallazgos reales):**

1. **Repo_Contact_Center - SP con password 'q1w2e3r4'** (S07_sp_code.csv, linea 3433): Stored procedure con `SET @password ='q1w2e3r4'`. Password de acceso a sistema externo hardcodeada en codigo SQL de produccion. Una version anterior comentada usaba el usuario 'tmpadmin'.

2. **Repo_Contact_Center - SP con password '70863013'** (S07_sp_code.csv, linea 3436): En el mismo stored procedure, `SET @password ='70863013'` asignada al usuario 'rperezram'. Password activa en produccion.

3. **Repo_Contactos - SP con PWD FTP '%T3l3f0n1c4$1'** (S07_sp_code.csv, linea 294): Stored procedure que configura acceso FTP con `SET @FTPPWD = '%T3l3f0n1c4$1'` para el usuario 'Contador'. Credencial de acceso FTP expuesta.

4. **SSIS Multiconsulta - Password 'Telefonica.2021'** (Arbol_Decisiones_sql_tasks.sql, linea 342): Anotacion en paquete SSIS con texto: "10.4.40.38 y puerto 22. Usuario: mconsultasusr. Password: Telefonica.2021". Credencial SFTP en texto plano en XML del paquete.

**BAJO RIESGO - Falsos positivos en scripts de recoleccion (6 hallazgos):**

5-6. **export_etl.ps1** (lineas 110, 518, 682, 723): Variables PowerShell `$PASSWORD = $null` y `$PASSWORD = $script:_credPass`. Son asignaciones de variables que reciben credenciales interactivamente, no passwords literales.

7-8. **gather_sqlserver.ps1** (lineas 126, 396): Mismo patron que export_etl.ps1. Variables de credenciales del toolkit MEP, no passwords expuestas.

**BAJO RIESGO - Connection strings a archivos (6 hallazgos):**

9-14. **Arbol_Decisiones_connections.txt** (3 registros) y **New Package_connections.txt** (1 registro): Connection strings que apuntan a archivos CSV/TXT locales como fuentes de datos SSIS. No contienen credenciales de base de datos.

**Resumen:** De los 16 hallazgos del scanner, 4 son criticos reales (passwords literales que deben remediarse), 6 son falsos positivos en scripts del toolkit, y 6 son connection strings de bajo riesgo.

## 9. Checklist QA

| Item | Descripcion | Estado | Observacion |
|------|-------------|--------|-------------|
| 1.1 | Subcarpetas A-H presentes | CUMPLE | Las 8 subcarpetas (A-H) estan presentes. Estructura completa. |
| 1.2 | Archivos completos y tamano coherente | CUMPLE | 1,424 archivos, 231 MB total. Escala LARGEST con 32 BDs documentadas. |
| 1.3 | Nomenclatura de archivos correcta | CUMPLE | Nomenclatura correcta en archivos A01, B10-B13, D40, E01, F01, H01. |
| 1.4 | Archivos legibles y encoding correcto | CUMPLE | CSVs con encoding UTF-8-sig y UTF-16-LE. 788 CSVs parseados correctamente. |
| 1.5 | Fichas funcionales completas | CUMPLE PARCIAL | A01 presente (DOCX, 17 KB) pero no verificable automaticamente. Falta ficha de infraestructura dedicada. |
| 2.1 | Motor de BD identificado correctamente | CUMPLE | MSSQL detectado con alta confianza. SQL Server 2014 SP3 Enterprise, instancia PRODTDPPLANICO. |
| 2.2 | Software y servicios capturados | CUMPLE | B10, B11, B12, B13 completos. Servicios SQL, procesos, programas instalados y netstat documentados. |
| 2.3 | Diccionario de datos extraido | CUMPLE | Diccionario completo para 32 BDs con S01-S14 por schema. 788 CSVs, 187,287 filas. |
| 2.4 | Archivos de instancia presentes | CUMPLE PARCIAL | 00_version, 01_server_config, 02_linked_servers, 03_agent_jobs, 04_logins, 05_databases presentes. Scanner reporta ausencia de formato antiguo (00_server_info) pero datos equivalentes existen. |
| 3.1 | CSVs parseables y coherentes | CUMPLE | 788 CSVs parseados. Headers y delimitadores correctos. |
| 3.2 | Datos coherentes entre archivos | CUMPLE | 32 BDs consistentes entre 05_databases, object_summary y archivos S01-S14. |
| 3.3 | Cross-references validadas | CUMPLE PARCIAL | Linked servers vs interfaces y logins vs accesos requieren cruce manual. |
| 3.4 | Sin credenciales expuestas | NO CUMPLE | 4 passwords literales: q1w2e3r4, 70863013, %T3l3f0n1c4$1, Telefonica.2021. |
| 4.1 | ETL/Jobs documentados | CUMPLE | 177 Agent Jobs (465 steps), 276 paquetes SSIS, 259 scheduled tasks. Cobertura completa. |
| 4.2 | Paquetes SSIS exportados y parseables | CUMPLE | 276 paquetes exportados de 78 proyectos SSISDB + 9 MSDB. Parseados correctamente. |
| 4.3 | Connection managers y SQL tasks extraidos | CUMPLE | Connection managers, SQL tasks y dataflows disponibles en archivos _extracted. |
| 5.1 | Interfaces y artefactos BI documentados | CUMPLE | E01_E02_Interfaces y F01_Reportes_BI presentes. |
| 5.2 | Interfaces cruzadas con linked servers | CUMPLE PARCIAL | 8 linked servers documentados en CSV. Pendiente cruce exhaustivo con E01. |
| 5.3 | Lineage documentado | NO CUMPLE | G marcada 'no aplica'. INJUSTIFICABLE para 32 BDs, 78 proyectos SSIS, 8 linked servers. |
| 5.4 | Dependencias entre BDs documentadas | CUMPLE PARCIAL | S13_dependencies.csv por BD. Falta lineage inter-BD y documentacion en G. |
| 6.1 | Accesos documentados | CUMPLE | H01_Accesos presente (9 KB). |
| 6.2 | Logins cruzados con accesos declarados | CUMPLE PARCIAL | 40 logins en CSV. Principals/roles/permissions por BD. Pendiente cruce con H01. |
| 6.3 | Sin credenciales en archivos de seguridad | NO CUMPLE | 3 passwords en SPs + 1 en SSIS. Riesgo critico. |

**Resumen Checklist:**

| Estado | Cantidad |
|--------|----------|
| CUMPLE | 13 |
| CUMPLE PARCIAL | 7 |
| NO CUMPLE | 3 |
| **Total** | **23** |

## 10. Recomendaciones

### 10.1 Bloqueantes

#### Acciones Integratel

1. **Remediar credenciales hardcodeadas en stored procedures** (F-001): Reemplazar las 3 passwords literales (q1w2e3r4, 70863013, %T3l3f0n1c4$1) en Repo_Contact_Center y Repo_Contactos por mecanismos seguros (SQL Server Credentials, parametros cifrados). Rotar las passwords expuestas inmediatamente.

2. **Remediar credencial en paquete SSIS** (F-002): Eliminar la anotacion con usuario/password de Multiconsulta/Arbol_Decisiones. Configurar credenciales via SSIS Environment Variables. Rotar la password 'Telefonica.2021' del servidor 10.4.40.38.

#### Acciones Stefanini

1. **Entregar documentacion de lineage en subcarpeta G** (F-003): Generar documentacion que cubra los flujos de datos principales entre las 32 BDs, los 8 linked servers (incluyendo Teradata), las fuentes SFTP/FTP, y los 78 proyectos SSIS. El "no aplica" debe reemplazarse por documentacion real.

### 10.2 Importantes

#### Acciones Integratel

1. **Validar interfaces E01 contra linked servers** (F-006): Cruzar manualmente el Excel E01 contra los 8 linked servers documentados y las connection strings detectadas en los paquetes SSIS. Asegurar cobertura completa.

2. **Verificar ficha funcional A01** (F-005): Revision manual del contenido del DOCX para confirmar que incluye descripcion funcional, responsables, SLAs y dependencias del servidor.

3. **Investigar esquema anomalo** (F-009): Determinar el proposito del schema '172.30.249.166' en Repo_Regulatoria y documentar para la migracion.

#### Acciones Stefanini

1. **Confirmar necesidad de migracion de BD_BACKUP** (F-010): Consultar con B.Quispe/R.Smith si BD_BACKUP_2022 (595 GB) y BD_BACKUP_2023 (205 GB) requieren migracion o pueden archivarse.

2. **Cruzar H01 contra logins del servidor** (Checklist 6.2): Verificar que los 40 logins documentados en CSV coinciden con los accesos declarados en H01_Accesos.xlsx.

### 10.3 Observaciones para el Assessment

1. **Escala del servidor**: Con 32 BDs, 8 TB de datos, 3,931 tablas, 1,138 SPs y 276 paquetes SSIS, este es un servidor de escala LARGEST que requerira un plan de migracion por fases. La base Repo_Layout sola tiene 1.2 TB.

2. **SQL Server 2014 SP3 EOL** (F-011): End of Extended Support julio 2024. Documentar como riesgo informativo sin recomendar upgrade (fuera del alcance del MEP).

3. **Patron DW/Staging** (F-004): El 97.3% de tablas sin PK es tipico de un Data Warehouse con carga truncate+insert. No es un defecto sino un patron arquitectonico a documentar.

4. **Dependencias externas criticas** (F-016): 8 linked servers activos incluyendo Teradata. Los Agent Jobs ejecutan queries cross-server (INSERT INTO... SELECT FROM [172.30.251.85]...). Cualquier migracion debe coordinar las dependencias con los 7 servidores SQL y Teradata.

5. **BI basado en Excel** (F-017): 259 tareas Windows actualizan reportes Excel desde K:\\ y M:\\. Este patron de BI no estandar debe considerarse en el plan de migracion.

6. **Instancia nombrada**: PRODTDPPLANICO es una instancia nombrada, lo que implica que la migracion debe preservar el nombre de instancia o actualizar todas las connection strings de los sistemas que se conectan.

7. **Recovery Model FULL en todas las BDs**: Todas las 32 BDs usan FULL recovery. Los logs transaccionales suman 130 GB. Verificar que exista un plan de backup de logs activo para evitar crecimiento descontrolado durante la migracion.

---

*Reporte generado automaticamente por QA Automatizado (Claude + Scanner) el 2026-03-20.*
*Scanner version: 1.0.0 | MEP: MEP_WINDBPVNB0002 | Score: 66/100 (C) | Veredicto: APROBADO CON OBSERVACIONES*
