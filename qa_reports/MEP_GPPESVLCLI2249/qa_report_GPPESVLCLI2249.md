# QA Report - MEP_GPPESVLCLI2249

## 1. Informacion General

| Campo | Valor |
|-------|-------|
| Servidor | GPPESVLCLI2249 |
| IP | 10.4.40.227 |
| Motor / Version | MSSQL - SQL Server 2008 R2 SP2 (10.50.4000.0) Standard Edition (64-bit) |
| Sistema Operativo | Windows Server 2012 Standard |
| Gerencia | Gerencia de Postventa (Gerencia de Atencion / D3 Customer Care) |
| Dominio SID | D3 - Customer Care |
| Focal | B.Quispe / R.Smith |
| SME | SME_1 |
| Tracker # | 14 |
| Fecha Extraccion | 2026-03-16 |
| Fecha QA | 2026-03-20 |
| Score | 58.5 / 100 (C) |
| Veredicto | **CONDICIONAL** |

## 2. Resumen Ejecutivo

El MEP del servidor GPPESVLCLI2249 fue recibido con la estructura completa de 8 subcarpetas (A-H) conteniendo 454 archivos y 8.04 MB de datos. La extraccion fue realizada el 2026-03-16 mediante los scripts MEP SQL Server Gatherer v4.1 y MEP ETL Exporter v1.1. El servidor aloja una instancia MSSQL 2008 R2 SP2 Standard Edition con 20 bases de datos de usuario, 1,965 tablas y mas de 1,061 millones de filas, totalizando aproximadamente 195 GB de datos. La base mas critica es BD_PORTAL_WEB_V2 (68.3 GB, 476 tablas) que alimenta el sistema KIPU para Call Center, socios, experiencia, tiendas y calidad.

Se identificaron 3 hallazgos criticos (FAIL) y 6 advertencias (WARN). Los problemas principales son: (1) la subcarpeta G de Lineage esta completamente vacia sin documentacion de linaje de datos, (2) se detectaron contrasenas SSIS expuestas en texto plano ("/DECRYPT 123" en 8 pasos de jobs), y (3) el archivo H01 de Accesos no contiene informacion util pese a existir 47 logins en la instancia. Adicionalmente, las interfaces en E01 son incompletas (solo 3 de 6 linked servers documentados), existe un linked server MySQL no documentado, el 89.8% de tablas carecen de Primary Key, y la subcarpeta D no consolida los Agent Jobs.

El veredicto es **CONDICIONAL** con un score de 58.5/100 (grado C). El MEP requiere acciones correctivas antes de ser aceptado para ingesta en Oracle Modernization: el focal debe completar G (lineage), corregir H01 (accesos), completar E01 (interfaces) y redactar las credenciales SSIS expuestas. Se recomienda no bloquear la ingesta por la version EOL del motor, que es informativa.

## 3. Scores

| Subcarpeta | Nombre | Peso | Score | Estado |
|------------|--------|------|-------|--------|
| A | Ficha Funcional | 10% | 85 | PASS |
| B | Software y Servicios | 10% | 90 | PASS |
| C | Diccionario de BD | 25% | 72 | PASS-WARN |
| D | Jobs / ETL | 15% | 65 | WARN |
| E | Interfaces I/O | 10% | 55 | WARN |
| F | BI Artefactos | 5% | 80 | PASS |
| G | Lineage | 5% | 30 | FAIL |
| H | Seguridad | 20% | 50 | WARN |

| Concepto | Valor |
|----------|-------|
| Score ponderado | 66.5 |
| Penalidades | -8 (credencial SSIS expuesta: -5, H01 sin datos: -3) |
| **Score final** | **58.5 / 100 (C)** |

## 4. Evaluacion por Subcarpeta

### 4.1 A -- Ficha Funcional (85/100)

**Archivos:** A01_Ficha_Funcional_GPPESVLCLI2249.docx (17,243 bytes)

**Evaluacion:**
- Ficha completada con 4 tablas: Identificacion del Activo, Informacion Organizacional, Infraestructura y Cuestionario Funcional
- Servidor identificado correctamente como GPPESVLCLI2249, IP 10.4.40.227, MSSQL, VM
- BD critica identificada: Portal_web_v2; areas consumidoras: Call Center, socios, Experiencia, Tiendas, Calidad
- Se confirma que no hay replicacion, mirroring ni AlwaysOn
- Dependencias criticas con Linked Servers confirmadas; restriccion de acceso via Citrix + perfil de usuario
- Falta dato de Hypervisor y CPU; vCPU no reportada

### 4.2 B -- Software y Servicios (90/100)

**Archivos:** B10_sc_query.txt (117,574 B), B10_services_ps.txt (36,638 B), B11_process_cmdline.csv (9,943 B), B11_tasklist_svc.txt (14,910 B), B12_installed_programs.csv (5,290 B), B12b_installed_programs.csv (15,785 B), B13_netstat.txt (48,102 B)

**Evaluacion:**
- Todos los archivos B10-B13 estan presentes y con contenido
- B12/B12b listan 69+275 programas instalados; se identifican SQL Server 2008 R2 SP2 componentes (SSIS, SSRS, SSAS, Management Studio, BI Dev Studio)
- MySQL Connector/ODBC 5.2 instalado (consistente con linked server MYSQL_DRH_LS)
- ODBC Driver 17 for SQL Server presente
- Anaconda3 2021.11 (Python 3.9.7) y Nmap 7.91 instalados en el servidor
- B13 netstat disponible para validacion de conexiones de red

### 4.3 C -- Diccionario de BD (72/100)

**Archivos:** mep_sqlserver_GPPESVLCLI2249_20260316_143912/ (22 BDs con S01-S14 por schema), mep_etl_GPPESVLCLI2249_20260316_144034/ (AgentJobs, MSDB, FileSystem), scripts.zip

**Evaluacion:**
- **Bases de datos:** 20 BDs de usuario + ReportServer + ReportServerTempDB = 22 total. Todas en estado ONLINE, recovery model FULL
- **Schemas:** Predomina dbo; BD_METRICAS_CANALES_ESCRITOS tiene schema adicional DIM
- **CSVs por BD:** S01 (tables_columns), S02 (PKs), S03 (tables_no_pk), S04 (FKs), S05 (indexes), S06 (check_constraints), S07 (sp_code), S08 (function_code), S09 (trigger_code), S10 (view_code), S11 (table_sizes), S12 (extended_properties), S13 (dependencies), S14 (user_types). Seguridad: 01-03 (principals, role_members, permissions), 04 (object_summary)
- **Volumetria:** 1,965 tablas, 1,061,124,207 filas totales, ~195 GB datos. Top: BD_PORTAL_WEB_V2 (323M filas, 60.3 GB), BD_IVR_ADAPTATIVO (307M filas, 19.8 GB), BD_REPORTE_AGENTES (112M filas, 20 GB)
- **PKs/FKs:** Solo 413 PKs y 92 FKs en toda la instancia. 1,764 tablas sin PK (89.8%) -- riesgo significativo para migracion
- **SPs:** 906 stored procedures extraidos con codigo en S07_sp_code.csv
- **Jobs:** 100 Agent Jobs documentados en _instance/03_agent_jobs.csv
- **SSIS:** 11 paquetes DTSX exportados de MSDB; 8 job steps SSIS referenciando archivos en K:\MSSQL\ISS_JOB\; SSISDB no existe (legacy deployment)
- **CDC:** No hay CDC ni Change Tracking configurado

### 4.4 D -- Jobs / ETL (65/100)

**Archivos:** D40_scheduled_tasks.csv (199,834 B)

**Evaluacion:**
- D40_scheduled_tasks.csv contiene 249 tareas programadas de Windows: 94 Ready, 153 Disabled, 2 Running
- Tareas incluyen ejecucion de scripts BAT, procesos SSIS y reportes automatizados
- No se incluyen archivos D10 (resumen Agent Jobs), D20 (detalle SSIS) ni D30 (scripts ETL) como documentos separados
- La informacion de Agent Jobs esta disponible en C/_instance/03_agent_jobs.csv pero no consolidada en esta subcarpeta
- Falta reconciliacion entre D40 (tareas Windows) y Agent Jobs (100 jobs en SQL Agent)

### 4.5 E -- Interfaces I/O (55/100)

**Archivos:** E01_E02_Interfaces_GPPESVLCLI2249.xlsx (8,840 B)

**Evaluacion:**
- Solo 3 interfaces documentadas, todas con direccion IP (172.30.249.165/166/167), tipo "SQL", modo "Usuario Servidor"
- No se especifica protocolo, schema origen, ni base de datos destino (solo "varios")
- La instancia tiene 6 linked servers configurados: 3 de los documentados + 10.4.40.226 + 172.30.251.85 + MYSQL_DRH_LS
- El linked server MYSQL_DRH_LS (via MSDASQL/ODBC a MySQL) no esta documentado
- Frecuencia indicada como "Diaria" sin horario ni detalle de ventana

### 4.6 F -- BI Artefactos (80/100)

**Archivos:** F01_Reportes_BI_GPPESVLCLI2249.xlsx (8,697 B)

**Evaluacion:**
- F01 indica "No aplica" para reportes BI
- Consistente con el uso de SSRS nativo (ReportServer BD presente con 53.4 MB)
- No se identifican artefactos Power BI, Tableau u otra herramienta BI externa
- SSRS esta documentado como parte de la instancia en B12 (SQL Server 2008 R2 SP2 Reporting Services)

### 4.7 G -- Lineage (30/100)

**Archivos:** no aplica.txt (0 bytes), README_Instrucciones.md

**Evaluacion:**
- Subcarpeta efectivamente vacia; no hay documentacion de linaje de datos
- No se proporcionan diagramas de flujo, matrices de dependencia ni mapeos de datos
- Existe informacion parcial de dependencias en S13_dependencies.csv por BD, pero no consolidada
- Critico: el servidor tiene 20 BDs interconectadas, 6 linked servers y dependencias con KIPU y Genesys IVR que requieren documentacion de linaje

### 4.8 H -- Seguridad (50/100)

**Archivos:** H01_Accesos_GPPESVLCLI2249.xlsx (8,681 B)

**Evaluacion:**
- H01 contiene unicamente la fila "No aplica" sin documentar usuarios, roles ni permisos aplicativos
- La instancia tiene 47 logins (28 SQL, 18 Windows, 1 grupo Windows) documentados en 04_logins.csv
- Cada BD tiene archivos 01_principals, 02_role_members, 03_permissions con datos de seguridad
- Se detectaron contrasenas SSIS expuestas: "/DECRYPT 123" en 8 pasos de jobs SSIS
- La Ficha Funcional menciona restriccion via "Rol de Citrix y perfil de usuario" pero no se documenta el detalle

## 5. Hallazgos

### 5.1 Criticos (FAIL)

| ID | Titulo | Evidencia | Impacto | Remediacion |
|----|--------|-----------|---------|-------------|
| FAIL-001 | Subcarpeta G (Lineage) vacia - sin documentacion de linaje | G_Lineage_Documentacion contiene solo 'no aplica.txt' (0 bytes) y README | No se puede trazar el flujo de datos entre sistemas ni validar dependencias para la migracion | Focal debe documentar el linaje entre las 20 BDs, linked servers y sistemas externos (KIPU, Genesys IVR) |
| FAIL-002 | Contrasena SSIS expuesta en texto plano | 8 pasos SSIS en ssis_job_steps.csv usan /DECRYPT 123 como contrasena de paquete | Credencial trivial expuesta en metadatos exportados; riesgo de acceso no autorizado | Rotar contrasena de paquetes SSIS antes de ingesta; redactar en entregables MEP |
| FAIL-003 | H01 Accesos sin datos relevantes | H01_Accesos_GPPESVLCLI2249.xlsx contiene unicamente 'No aplica'; existen 47 logins en la instancia | No se puede evaluar postura de seguridad ni planificar migracion de accesos | Focal debe completar H01 con mapeo de usuarios aplicativos, roles y permisos por BD |

### 5.2 Advertencias (WARN)

| ID | Titulo | Evidencia | Impacto | Remediacion |
|----|--------|-----------|---------|-------------|
| WARN-001 | E01 Interfaces incompletas | Solo 3 de 6 linked servers documentados; falta MYSQL_DRH_LS, 10.4.40.226, 172.30.251.85 | Interfaces insuficientes para planificar corte/reconexion | Completar E01 con los 6 linked servers, protocolo y schemas |
| WARN-002 | Alta proporcion de tablas sin Primary Key | 1,764 tablas sin PK de 1,965 (89.8%); solo 413 PKs y 92 FKs | Riesgo de duplicacion en migracion; dificulta CDC | Documentar estrategia de deduplicacion para tablas criticas |
| WARN-003 | 54 de 100 Agent Jobs deshabilitados | 54 jobs disabled; algunos nombres son fragmentos SQL | Jobs pueden contener logica necesaria; nombres sugieren problemas de exportacion | Focal debe validar cuales jobs son necesarios vs obsoletos |
| WARN-004 | Volumen de datos muy alto (~195 GB) | BD_PORTAL_WEB_V2: 68.3 GB, BD_METRICAS_CONTACT_CENTER: 35.3 GB, BD_REPORTE_REGULADOS: 28.1 GB | Requiere planificacion especifica de ventana de migracion | Definir migracion por fases; considerar particionado de tablas >50M filas |
| WARN-005 | D40 solo cubre tareas Windows, no Agent Jobs | D_Jobs_ETL_ELT tiene solo D40 (249 tareas Windows); falta D10/D20/D30 | Info de Agent Jobs en C pero no consolidada en D | Generar D10/D20 con resumen de Agent Jobs y SSIS |
| WARN-006 | Linked Server MySQL no documentado en interfaces | MYSQL_DRH_LS via MSDASQL a DSN MYSQL_DRH_64 no aparece en E01 | Dependencia cross-engine no documentada | Documentar en E01 conexion MySQL y plan de reconexion |

### 5.3 Informativos (INFO)

| ID | Titulo | Evidencia |
|----|--------|-----------|
| INFO-001 | SQL Server 2008 R2 SP2 - fuera de soporte extendido desde julio 2019 | Version 10.50.4000.0, Standard Edition (64-bit) sobre Windows Server 2012 Standard |
| INFO-002 | SSRS activo con ReportServer y ReportServerTempDB | ReportServer (53.4 MB) + ReportServerTempDB (1.6 MB); SSRS 2008 R2 SP2 instalado |
| INFO-003 | 11 paquetes SSIS en MSDB (legacy), SSISDB no existe | 19 paquetes registrados, 11 exportados como DTSX. 8 jobs SSIS referencian K:\MSSQL\ISS_JOB\ |
| INFO-004 | BD critica: BD_PORTAL_WEB_V2 | 476 tablas, 187 SPs, 84 views, 323M filas, 60.3 GB. Alimenta KIPU |
| INFO-005 | 1,061 millones de filas totales en 1,965 tablas | 20 BDs usuario. Schemas: dbo + DIM (BD_METRICAS_CANALES_ESCRITOS) |
| INFO-006 | F01 BI Artefactos indica 'No aplica' | Consistente con uso de SSRS nativo como plataforma de reportes |

## 6. Cross-References

| Cruce | Estado | Detalle |
|-------|--------|---------|
| A <-> C | PASS | Ficha identifica BD critica Portal_web_v2; C tiene datos completos para BD_PORTAL_WEB_V2 (476 tablas, 187 SPs) |
| D <-> C | WARN | Agent Jobs en C (100 jobs) no reflejados en D dedicado; D40 solo tiene Scheduled Tasks Windows |
| E <-> C | FAIL | 6 linked servers en C/_instance/02_linked_servers.csv; solo 3 IPs en E01 sin detalle de protocolo/schema |
| Tracker | PASS | Tracker #14 asignado |
| Version | PASS | Version en 00_version.txt (10.50.4000.0 SP2) coincide con Ficha Funcional (SQL Server 2008 R2 SP2) |

## 7. Estadisticas del Servidor

### 7.1 Bases de Datos

| Nombre | Tamano (MB) | Tablas | Filas |
|--------|------------|--------|-------|
| BD_PORTAL_WEB_V2 | 69,952.8 | 476 | 323,081,316 |
| BD_METRICAS_CONTACT_CENTER | 36,119.4 | 103 | 101,728,043 |
| BD_REPORTE_REGULADOS | 28,811.5 | 59 | 75,136,202 |
| BD_REPORTE_AGENTES | 25,000.0 | 108 | 112,748,271 |
| BD_IVR_ADAPTATIVO | 19,992.1 | 526 | 307,080,001 |
| BD_PROCESOS_CRUCES_V2 | 16,200.0 | 15 | 3,868,025 |
| BD_DETALLE_RELLAMADAS_TRANSFERENCIAS | 11,000.0 | 67 | 8,441,242 |
| BD_METRICAS_CANALES_ESCRITOS | 9,993.2 | 40 | 24,000,283 |
| BD_REPORTE_REGULADOS_V2 | 9,000.0 | 15 | 28,657,003 |
| BD_PLANIFICACION | 8,000.0 | 120 | 19,286,160 |
| BD_DETALLE_NOT_READY | 3,000.0 | 8 | 23,695,859 |
| BD_CONTROL | 2,296.1 | 8 | 10,731,803 |
| BD_FACTURACION | 2,004.2 | 222 | 2,792,276 |
| BD_REPORTES_TABLAS | 1,702.0 | 75 | 15,103,626 |
| BD_DETALLE_LLAMADAS | 1,609.0 | 17 | 517,475 |
| BD_REPORTES_NATIVOS_INFOMART | 1,200.0 | 22 | 3,914,288 |
| BD_FACTURACION_HISPAM | 400.0 | 23 | 20,425 |
| BD_DICCIONARIO_PROCESOS | 271.4 | 3 | 318,064 |
| BD_LENGUAJE_NATURAL | 3.0 | 1 | 0 |
| db_admsql | 2.0 | 10 | 3,739 |
| ReportServer | 53.4 | 34 | 79 |
| ReportServerTempDB | 1.6 | 13 | 27 |
| **TOTAL** | **~246,611** | **1,965** | **1,061,124,207** |

### 7.2 Objetos

| Tipo | Cantidad |
|------|----------|
| USER_TABLE | 1,965 |
| SQL_STORED_PROCEDURE | 906 |
| VIEW | 162 |
| SQL_SCALAR_FUNCTION | 24 |
| PRIMARY_KEY_CONSTRAINT | 413 |
| FOREIGN_KEY | 92 |
| Tablas sin PK | 1,764 |
| TRIGGER | 0 |
| CHECK_CONSTRAINT | 0 |

### 7.3 ETL / Jobs

| Tipo | Cantidad | Activos | Fallidos |
|------|----------|---------|----------|
| SQL Agent Jobs | 100 | 46 | N/A |
| SSIS Job Steps | 8 | -- | -- |
| SSIS Packages (MSDB) | 11 | -- | -- |
| SSIS Packages (FileSystem) | 0 | -- | -- |
| Scheduled Tasks (Windows) | 249 | 94 (Ready) + 2 (Running) | 153 (Disabled) |

### 7.4 Seguridad

| Tipo | Cantidad |
|------|----------|
| SQL Logins | 28 |
| Windows Logins | 18 |
| Windows Groups | 1 |
| Total Logins | 47 |
| Linked Servers | 6 |
| Credenciales Expuestas | 1 (SSIS /DECRYPT) |

### 7.5 Infraestructura

| Recurso | Valor |
|---------|-------|
| Tipo | VM |
| RAM | 16 GB |
| Storage | 1 TB |
| CPU Cores | 2 |
| Total Data | ~241 GB |
| Total Log | ~3.1 GB |
| Recovery Model | FULL (todas las BDs) |
| Collation | SQL_Latin1_General_CP1_CI_AS |
| SO | Windows Server 2012 Standard |

## 8. Hallazgos de Seguridad

| # | Tipo | Ubicacion | Detalle (redactado) |
|---|------|-----------|---------------------|
| 1 | Contrasena SSIS en texto plano | C_Diccionario_BD/mep_etl_.../AgentJobs/ssis_job_steps.csv | 8 pasos SSIS usan /DECRYPT [REDACTADO] como contrasena trivial de paquete. Contrasena de baja complejidad (3 caracteres numericos) |

## 9. Checklist QA (23 items)

| ID | Seccion | Item | Estado | Observacion |
|----|---------|------|--------|-------------|
| **1. Estructura MEP** | | | | |
| 1.1 | Estructura | Subcarpetas A-H presentes | PASS | 8 subcarpetas presentes, 454 archivos, 8.04 MB total |
| 1.2 | Estructura | Ficha Funcional completa | PASS | A01 DOCX con 4 tablas completadas |
| 1.3 | Estructura | Archivos B10-B13 presentes | PASS | sc_query, services_ps, process_cmdline, tasklist_svc, installed_programs, netstat |
| 1.4 | Estructura | Extraccion C completa | PASS | mep_sqlserver (22 BDs, 435 CSVs) y mep_etl (AgentJobs, MSDB SSIS) |
| 1.5 | Estructura | Consistencia IP/servidor | PASS | IP 10.4.40.227 consistente en Ficha, scanner y estructura MEP |
| **2. Diccionario BD** | | | | |
| 2.1 | Diccionario | BDs extraidas con S01-S14 | PASS | 20 BDs usuario + 2 sistema con S01-S14 por schema |
| 2.2 | Diccionario | Codigo SP/Views/Funciones | PASS | 906 SPs, 162 views, 24 funciones con codigo extraido |
| 2.3 | Diccionario | PKs, FKs, constraints | WARN | 413 PKs, 92 FKs, 0 checks. 89.8% tablas sin PK |
| 2.4 | Diccionario | CDC / Change Tracking | N/A | No hay CDC ni Change Tracking configurado |
| **3. Jobs / ETL** | | | | |
| 3.1 | Jobs | Agent Jobs documentados | PASS | 100 jobs en 03_agent_jobs.csv con steps, schedules y comandos |
| 3.2 | Jobs | SSIS documentado | PASS | 8 SSIS job steps + 11 paquetes DTSX en MSDB |
| 3.3 | Jobs | D10/D20/D30/D40 completos | WARN | Solo D40 (tareas Windows); falta D10/D20/D30 dedicado |
| 3.4 | Jobs | Jobs validos y coherentes | WARN | 54 jobs deshabilitados; nombres con fragmentos SQL |
| **4. Interfaces** | | | | |
| 4.1 | Interfaces | E01/E02 completas | WARN | Solo 3 de 6 linked servers documentados |
| 4.2 | Interfaces | Linked servers documentados | WARN | MYSQL_DRH_LS via MSDASQL no documentado en E01 |
| 4.3 | Interfaces | Validacion cruzada con netstat | PASS | B13 netstat disponible para validacion |
| **5. Seguridad** | | | | |
| 5.1 | Seguridad | H01 Accesos completo | WARN | H01 con 'No aplica'; 47 logins no documentados |
| 5.2 | Seguridad | Sin credenciales expuestas | FAIL | /DECRYPT 123 expuesto en 8 pasos SSIS |
| 5.3 | Seguridad | Principals/roles por BD | PASS | 01-03 CSVs presentes por BD (22 BDs) |
| 5.4 | Seguridad | Logins documentados | PASS | 04_logins.csv con 47 logins documentados |
| **6. Lineage / Documentacion** | | | | |
| 6.1 | Lineage | Documentacion de linaje | FAIL | G vacio (no aplica.txt 0 bytes) |
| 6.2 | Lineage | Dependencias entre sistemas | FAIL | Sin documentacion de dependencias entre 20 BDs y sistemas externos |
| 6.3 | Lineage | Cuestionario funcional consistente | PASS | Ficha Q7 confirma linked servers; S13 dependencies disponibles por BD |

**Resumen Checklist:**

| Estado | Cantidad |
|--------|----------|
| PASS | 14 |
| WARN | 6 |
| FAIL | 3 |
| N/A | 0 |
| **Total** | **23** |

## 10. Recomendaciones

### 10.1 Bloqueantes

#### Acciones Integratel (Focal / SPOC)

1. **Completar subcarpeta G -- Lineage:** Documentar el flujo de datos entre las 20 bases de datos del servidor, los 6 linked servers y los sistemas externos (KIPU, Genesys IVR). Incluir diagrama de dependencias y matrices de flujo entrada/salida.

2. **Completar H01 -- Accesos:** Mapear los 47 logins de la instancia con su uso funcional, roles por BD y responsable de cada cuenta. Documentar la integracion con Citrix mencionada en la Ficha Funcional.

3. **Redactar credenciales SSIS:** Eliminar o redactar la contrasena "/DECRYPT 123" expuesta en ssis_job_steps.csv antes de entregar el MEP final. Considerar rotacion de la contrasena en los paquetes SSIS del servidor.

#### Acciones Stefanini

1. **Validar exportacion de Agent Jobs:** Revisar los 54 jobs deshabilitados cuyos nombres son fragmentos de codigo SQL, ya que sugieren un problema en el script de exportacion. Regenerar 03_agent_jobs.csv si es necesario.

### 10.2 Importantes (antes de ingesta OM)

#### Acciones Integratel

1. **Completar E01 -- Interfaces:** Agregar los 3 linked servers faltantes (10.4.40.226, 172.30.251.85, MYSQL_DRH_LS) con protocolo, schema origen/destino, frecuencia detallada y responsable.

2. **Documentar linked server MySQL (MYSQL_DRH_LS):** Este linked server usa MSDASQL hacia un DSN MySQL. Documentar su uso funcional, base de datos destino y plan de reconexion post-migracion.

3. **Generar D10/D20 consolidados:** Crear archivos dedicados en D_Jobs_ETL_ELT con resumen de los 100 Agent Jobs y detalle de los 8 pasos SSIS, complementando el D40 de tareas Windows.

4. **Identificar tablas criticas sin PK:** De las 1,764 tablas sin Primary Key, identificar cuales son criticas para la operacion y documentar estrategia de deduplicacion para la ingesta.

#### Acciones Stefanini

1. **Planificar migracion por fases:** Con ~195 GB de datos y tablas con >300M filas, definir ventanas de migracion, orden de BDs y estrategia de validacion post-carga.

2. **Validar SSRS como componente de migracion:** Confirmar si los reportes de ReportServer deben migrarse o si se reemplazaran por otra plataforma BI en el destino.

### 10.3 Observaciones para el Assessment

- SQL Server 2008 R2 SP2 esta fuera de soporte extendido desde julio 2019. Esto es informativo y no debe bloquear la ingesta.
- Windows Server 2012 Standard tambien esta fuera de soporte extendido. Informativo.
- La instancia usa recovery model FULL en todas las BDs; los logs suman ~3.1 GB, lo cual es manejable dado el volumen de datos.
- BD_IVR_ADAPTATIVO tiene 526 tablas (la mayor cantidad de objetos) con 307M filas; sugiere historico de datos de IVR que podria requerir archivado pre-migracion.
- Se identifican herramientas de desarrollo no estandar instaladas en el servidor (Anaconda Python, Nmap) que deberian evaluarse en el contexto de seguridad del assessment.
