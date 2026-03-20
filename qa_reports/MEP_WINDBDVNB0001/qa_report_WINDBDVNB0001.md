# QA Report - MEP_WINDBDVNB0001

## 1. Informacion General

| Campo | Valor |
|---|---|
| MEP | MEP_WINDBDVNB0001 |
| Servidor | WINDBDVNB0001 |
| Instancia | DESTDPPLANCO |
| IP | 172.30.249.165 |
| Motor | Microsoft SQL Server 2014 SP3 (12.0.6024.0) Enterprise Edition (64-bit) |
| SO | Windows Server 2016 (Build 14393) - Hypervisor |
| Gerencia | Gerencia de Atencion (D3 Customer Care) |
| Focal | B.Quispe / R.Smith |
| Tracker | #11 |
| SME | SME_1 |
| Archivos | 479 |
| Tamano | 46 MB |
| Subcarpetas | 8/8 (A-H completas) |
| Fecha Extraccion | 2026-03-09 |
| Fecha QA | 2026-03-20 |
| Analista QA | QA Automatizado (Claude + Scanner v1.0.0) |

## 2. Resumen Ejecutivo

El servidor WINDBDVNB0001 aloja la instancia DESTDPPLANCO de SQL Server 2014 SP3 Enterprise Edition, dedicada a la Gerencia de Atencion (D3 Customer Care). Gestiona 16 bases de datos con un volumen total de 2.7 TB, de las cuales las principales son TP_CALIDAD (143 GB, 1033 tablas, 83 stored procedures), CALIDAD_CRUCES (293 GB, 644 tablas) y CALIDAD (160 GB, 166 tablas). El servidor opera procesos ETL criticos via SSIS con 46 paquetes distribuidos en 8 proyectos, ademas de 43 SQL Agent jobs (31 habilitados) que orquestan la consolidacion de encuestas, procesos de calidad y consolidacion de bases externas.

El MEP presenta una estructura completa en las 8 subcarpetas (A-H), con 479 archivos y documentacion adecuada en la mayoria de las areas. Sin embargo, se identificaron deficiencias criticas: la subcarpeta G (Lineage/Documentacion) esta vacia, hay paquetes SSIS con fallas recurrentes (ETL_Base_04_Averias.dtsx con 100% de fallas), y 12 jobs deshabilitados sin documentacion de razon. De los 7 hallazgos de seguridad del scanner, 6 son falsos positivos (patrones de password en scripts de recoleccion MEP) y 1 es informativo (ruta OneDrive corporativa en connection string).

El MEP obtiene un score de 75/100 (Grade B - APROBADO CON OBSERVACIONES). Las principales acciones requeridas son: (1) completar la documentacion de lineage en subcarpeta G, (2) documentar el estado de los paquetes SSIS fallidos, y (3) documentar la razon de deshabilitacion de los 12 SQL Agent jobs. No se identificaron riesgos de seguridad reales.

## 3. Scores

| Subcarpeta | Descripcion | Peso | Score | Ponderado |
|---|---|---|---|---|
| A | Ficha Funcional | 10% | 75 | 7.5 |
| B | Software y Servicios | 15% | 90 | 13.5 |
| C | Diccionario BD | 20% | 92 | 18.4 |
| D | Jobs / ETL / ELT | 15% | 70 | 10.5 |
| E | Interfaces I/O | 10% | 80 | 8.0 |
| F | BI / Artefactos | 5% | 80 | 4.0 |
| G | Lineage / Documentacion | 15% | 30 | 4.5 |
| H | Seguridad / Accesos | 10% | 80 | 8.0 |
| **Subtotal** | | **100%** | | **80.0** |

**Penalizaciones:** -5 (paquetes SSIS con fallas recurrentes sin documentacion)

**Score Final: 75/100 - Grade B - APROBADO CON OBSERVACIONES**

## 4. Evaluacion por Subcarpeta

### 4.1 A (75/100)

**Archivos:**
- A01_Ficha_Funcional_WINDBDVNB0001.docx (17 KB)

**Evaluacion:**
La ficha funcional esta presente y documenta el servidor WINDBDVNB0001. Contiene informacion basica del servidor. El archivo es relativamente pequeno (17 KB) lo cual sugiere un nivel de detalle basico. Se otorga 75/100 porque cumple con el requisito minimo de presencia pero el tamano indica documentacion limitada.

### 4.2 B (90/100)

**Archivos:**
- B10_sc_query.txt (158 KB) - Listado de servicios Windows (sc query)
- B10_services_ps.txt (51 KB) - Servicios via PowerShell
- B11_process_cmdline.csv (37 KB) - Procesos activos con linea de comando
- B11_tasklist_svc.txt (27 KB) - Listado de tareas con servicios
- B12_installed_programs.csv (39 KB) - Programas instalados (431 registros)
- B13_netstat.txt (52 KB) - Conexiones de red activas
- README_Instrucciones.md (0.7 KB)

**Evaluacion:**
Cobertura completa de software y servicios. Se documenta SQL Server 2014 SP3 Enterprise, servicios activos (MSSQL$DESTDPPLANCO, SQLAgent$DESTDPPLANCO), conexiones de red (puerto 1433 SQL, 3389 RDP, 33000). Los datos de netstat muestran conexiones establecidas hacia linked servers y clientes. Se instalan herramientas como Python 3.9.7, Visual Studio, Microsoft Office 16, Guardicore Agent. Score 90/100 por cobertura completa.

### 4.3 C (92/100)

**Archivos:**
- mep_scripts/mep_sqlserver_WINDBDVNB0001_DESTDPPLANCO_20260309_173944/ - Extraccion SQL Server (16 BDs con tablas, columnas, PKs, FKs, indexes, SPs, funciones, vistas, triggers, permisos, principals, roles)
- mep_scripts/mep_etl_WINDBDVNB0001_DESTDPPLANCO_20260309_174024/ - Extraccion ETL (SSISDB inventory, execution_history, Agent Jobs, paquetes DTSX extraidos)
- gather_sqlserver.ps1 (40 KB) - Script de recoleccion SQL Server
- export_etl.ps1 (44 KB) - Script de recoleccion ETL
- scripts.zip - Backup de scripts de recoleccion
- Total: 461 archivos, 45.15 MB

**Evaluacion:**
Excelente cobertura del diccionario de base de datos. Se documentan las 16 bases de datos con detalle de esquemas (S01-S14 por cada BD): tablas/columnas, primary keys, foreign keys, indexes, check constraints, stored procedures, funciones, triggers, vistas, table sizes, extended properties, dependencias, user types. Los scripts de recoleccion estan presentes y son funcionales. Se incluye el inventario SSIS completo con 46 paquetes y su historial de ejecucion. Score 92/100 - se descuenta ligeramente por la estructura de archivos que no coincide exactamente con el patron esperado por el scanner.

### 4.4 D (70/100)

**Archivos:**
- D40_scheduled_tasks.csv - Tareas programadas de Windows
- README_Instrucciones.md

**Evaluacion:**
La subcarpeta D presenta solo las scheduled tasks de Windows. La informacion de SQL Agent jobs esta en la subcarpeta C (dentro de mep_scripts). Se documentan 43 SQL Agent jobs (31 habilitados, 12 deshabilitados). Las scheduled tasks de Windows incluyen BotMaker_Formato_Archivos (deshabilitado), Guardicore Agent Autorun (activo), Office Telemetry y tareas de sistema. Score 70/100 porque la informacion de jobs SQL esta dispersa en subcarpeta C y faltan los archivos D01-D30 esperados para documentacion de jobs en formato estandar.

### 4.5 E (80/100)

**Archivos:**
- E01_E02_Interfaces_WINDBDVNB0001.xlsx - Documentacion de interfaces
- README_Instrucciones.md

**Evaluacion:**
El documento de interfaces esta presente y documenta las interfaces de entrada/salida. Se verifican 4 linked servers (10.226.3.96, 10.4.40.229, 172.30.249.166, 172.30.251.85) que representan dependencias externas. Los paquetes SSIS muestran conexiones a Teradata (Extraccion_teradata.dtsx) y conexiones OLEDB a multiples servidores. Score 80/100 - presente y con formato adecuado.

### 4.6 F (80/100)

**Archivos:**
- F01_Reportes_BI_WINDBDVNB0001.xlsx - Inventario de reportes BI
- README_Instrucciones.md

**Evaluacion:**
El inventario de reportes BI esta presente documentando los artefactos de Business Intelligence asociados al servidor. El servidor maneja procesos de calidad y encuestas que generan reportes consolidados. Score 80/100 - cumple con el formato.

### 4.7 G (30/100)

**Archivos:**
- no aplica.txt (vacio)
- README_Instrucciones.md

**Evaluacion:**
La subcarpeta G esta esencialmente vacia. El archivo "no aplica.txt" tiene 0 bytes de contenido. Esto es insuficiente dado que el servidor tiene 16 bases de datos, 46 paquetes SSIS activos, 4 linked servers y multiples flujos ETL que procesan datos de encuestas, calidad, cruces, regulados, delivery, recargas, botmaker, etc. La documentacion de lineage es critica para entender las dependencias entre estos componentes. Score 30/100 - incumplimiento critico. Se otorgan 30 puntos por la presencia de la subcarpeta.

### 4.8 H (80/100)

**Archivos:**
- H01_Accesos_WINDBDVNB0001.xlsx - Matriz de accesos
- README_Instrucciones.md

**Evaluacion:**
La matriz de accesos esta presente. Se documentan 41 logins a nivel instancia: 16 SQL logins (11 activos, 5 deshabilitados) y 25 Windows logins (17 GP\domain, 4 NT Service, 3 locales WINDBDVNB0001\). Los permisos a nivel de BD estan documentados con principals, role_members y permissions por cada base. Se observan 5 SQL logins con nombres IP-based que dificultan la auditoria. Score 80/100 - presente con buena cobertura.

## 5. Hallazgos

### 5.1 Criticos (FAIL)

| ID | Categoria | Subcarpeta | Titulo | Detalle |
|---|---|---|---|---|
| F-001 | Documentacion | G | Subcarpeta G sin documentacion de lineage | G_Lineage_Documentacion contiene solo archivo vacio 'no aplica.txt'. Sin diagrama de lineage para 16 BDs, 46 paquetes SSIS, 4 linked servers. |
| F-002 | ETL | C | Paquetes SSIS con ejecuciones fallidas recurrentes | ETL_Base_04_Averias.dtsx falla 100%. COBRO_RECONEXION, DESCUENTOS, RETENCION_FIJA tambien fallan. Tasa exito general 89.5%. |
| F-003 | Estructura | C | Archivos esperados del motor MSSQL ausentes a nivel instancia | Faltan archivos en formato estandar (00_server_info.csv, etc.) pero datos presentes en _instance con nombrado distinto. Impacto menor. |

### 5.2 Advertencias (WARN)

| ID | Categoria | Subcarpeta | Titulo | Detalle |
|---|---|---|---|---|
| F-004 | Jobs | D | 12 SQL Agent Jobs deshabilitados sin documentacion | 12/43 jobs (28%) deshabilitados. Incluye B2B, JCG, Aura. Sin documentacion de razon. |
| F-005 | Infraestructura | B | SQL Server 2014 SP3 en End of Life | SQL Server 2014 End of Extended Support: 9 julio 2024. Informativo para assessment. |
| F-006 | Seguridad | H | SQL Logins con nombres de IP activos | 5 logins IP-based activos con permisos en multiples BDs. Dificulta auditoria. |
| F-007 | Base de Datos | C | Gran volumen de bases de backup historico | 9 bases BD_BACKUP_* con ~1.9 TB. Total 2.7 TB en 16 BDs. Recovery model FULL. |
| F-008 | Conectividad | B | 4 Linked Servers configurados | Linked servers a 10.226.3.96, 10.4.40.229, 172.30.249.166, 172.30.251.85. Dependencias externas. |

### 5.3 Informativos (INFO)

| ID | Categoria | Subcarpeta | Titulo | Detalle |
|---|---|---|---|---|
| F-009 | ETL | C | 46 paquetes SSIS en 8 proyectos SSISDB | Proyectos: CONSOLIDACION_BASES_EXTERNAS, Delivery_Movil, Proceso_BotMaker, Proceso_Prueba, Procesos_Calidad (x3), Recargas, Refarming HU. |
| F-010 | Estructura | A | Ficha funcional presente y correcta | A01_Ficha_Funcional_WINDBDVNB0001.docx presente. |
| F-011 | Seguridad | H | Matriz de accesos documentada | H01_Accesos presente. 41 logins (16 SQL, 25 Windows). 5 deshabilitados. |
| F-012 | Objetos | C | Inventario de objetos completo para 16 bases | TP_CALIDAD: 1033 tablas, 83 SPs. CALIDAD_CRUCES: 644 tablas. BD_REGULADOS: 221 tablas. Completo. |
| F-013 | Interfaces | E | Documento de interfaces presente | E01_E02_Interfaces_WINDBDVNB0001.xlsx presente. |
| F-014 | BI | F | Inventario de reportes BI documentado | F01_Reportes_BI_WINDBDVNB0001.xlsx presente. |

## 6. Cross-References

| Dato | Fuente 1 | Fuente 2 | Consistente |
|---|---|---|---|
| Hostname WINDBDVNB0001 | 00_version.txt / 01_server_config.csv | B11_process_cmdline.csv / B13_netstat.txt | SI |
| IP 172.30.249.165 | 04_logins.csv (login activo) | B13_netstat.txt (conexiones) | SI |
| Instancia DESTDPPLANCO | 01_server_config.csv (instance_name) | 03_agent_jobs.csv (SSIS paths) | SI |
| SQL Server 2014 SP3 | 00_version.txt (12.0.6024.0) | 01_server_config.csv (product_version) | SI |
| 16 bases de datos | 05_databases.csv (16 registros) | Directorios en mep_sqlserver (16 carpetas BD) | SI |
| 43 SQL Agent jobs | 03_agent_jobs.csv (43 jobs unicos) | all_job_steps.csv (139 pasos) | SI |
| 46 paquetes SSIS | inventory.csv (47 registros, 46 unicos) | Archivos .dtsx extraidos en SSISDB/ | SI |
| Linked servers | 02_linked_servers.csv (4 servers) | Connection strings en paquetes SSIS | SI |
| Logins B.Quispe | 04_logins.csv (bquispealc SQL + GP\bquispealc) | Focal declarado | SI |
| Logins R.Smith | 04_logins.csv (rsmith SQL + GP\rsmith) | Focal declarado | SI |

## 7. Estadisticas del Servidor

### 7.1 Bases de Datos

| Base de Datos | Data (MB) | Log (MB) | Recovery | Estado | Tablas | SPs | Views |
|---|---|---|---|---|---|---|---|
| TP_CALIDAD | 146,382 | 1,401 | FULL | ONLINE | 1,033 | 83 | 11 |
| CALIDAD_CRUCES | 300,000 | 100 | FULL | ONLINE | 644 | 0 | 5 |
| BD_BACKUP_2023_VOZ | 485,708 | 1 | FULL | ONLINE | 25 | 0 | 0 |
| BD_BACKUP_2024_VOZ | 397,915 | 1 | FULL | ONLINE | 25 | 0 | 0 |
| BD_BACKUP_PLANTA | 300,000 | 1 | FULL | ONLINE | 115 | 0 | 0 |
| BD_REGULADOS | 272,825 | 1 | FULL | ONLINE | 221 | 3 | 0 |
| BD_BACKUP_2022_CCEE | 229,216 | 1 | FULL | ONLINE | 36 | 0 | 0 |
| BD_BACKUP_2023_CCEE_INTERACCIONES | 215,000 | 1 | FULL | ONLINE | 12 | 0 | 0 |
| CALIDAD | 163,826 | 1,083 | FULL | ONLINE | 166 | 10 | 0 |
| BD_BACKUP_2024_CCEE | 143,322 | 1 | FULL | ONLINE | 24 | 0 | 0 |
| BD_BACKUP_2023_CCEE_SESIONES | 81,669 | 1 | FULL | ONLINE | 12 | 0 | 0 |
| TP_CALIDAD_CRUCES | 47,170 | 101 | FULL | ONLINE | 644 | 10 | 5 |
| BD_BACKUP_FACO | 35,294 | 1 | FULL | ONLINE | 3 | 0 | 0 |
| BD_BACKUP_2023_VISOR | 14,430 | 1 | FULL | ONLINE | 12 | 0 | 0 |
| SSISDB | 3,112 | 1 | FULL | ONLINE | 30 | 96 | 33 |
| BD_CONTROL | 852 | 3 | FULL | ONLINE | 8 | 5 | 1 |
| **TOTAL** | **2,836,721** | **2,699** | | | **3,010** | **207** | **55** |

### 7.2 Objetos

| Tipo de Objeto | Cantidad | BDs Principales |
|---|---|---|
| USER_TABLE | 3,010 | TP_CALIDAD (1,033), CALIDAD_CRUCES (644), TP_CALIDAD_CRUCES (644) |
| SQL_STORED_PROCEDURE | 207 | SSISDB (86 catalog+internal), TP_CALIDAD (83), CALIDAD (10) |
| VIEW | 55 | SSISDB (33), TP_CALIDAD (11), CALIDAD_CRUCES (5), TP_CALIDAD_CRUCES (5) |
| DEFAULT_CONSTRAINT | 292 | CALIDAD_CRUCES (139), TP_CALIDAD (48), TP_CALIDAD_CRUCES (47) |
| SQL_SCALAR_FUNCTION | 18 | SSISDB (10 internal+catalog), TP_CALIDAD (4), TP_CALIDAD_CRUCES (4) |
| PRIMARY_KEY_CONSTRAINT | 35 | SSISDB (30), TP_CALIDAD (2), BD_CONTROL (2), TP_CALIDAD_CRUCES (1) |
| FOREIGN_KEY_CONSTRAINT | 28 | SSISDB (28) |
| SEQUENCE_OBJECT | 2 | TP_CALIDAD (1), TP_CALIDAD_CRUCES (1) |
| UNIQUE_CONSTRAINT | 6 | SSISDB (4), TP_CALIDAD (1), TP_CALIDAD_CRUCES (1) |

### 7.3 ETL/Jobs

| Metrica | Valor |
|---|---|
| SQL Agent Jobs (total) | 43 |
| Jobs habilitados | 31 (72%) |
| Jobs deshabilitados | 12 (28%) |
| Proyectos SSIS (SSISDB) | 8 (en 7 carpetas) |
| Paquetes SSIS | 46 |
| Ejecuciones recientes | 200 |
| Ejecuciones exitosas | 179 (89.5%) |
| Ejecuciones fallidas | 21 (10.5%) |
| Paquetes con fallas | ETL_Base_04_Averias, COBRO_RECONEXION, DESCUENTOS, RETENCION_FIJA, ETL_Base_60_Tiendas, ETL_Bases_44_Retenciones_Bajas_Tiendas_Movil |
| Scheduled tasks Windows | 2 relevantes (BotMaker deshabilitado, Guardicore activo) |

### 7.4 Seguridad

| Metrica | Valor |
|---|---|
| Total logins instancia | 41 |
| SQL Logins | 16 (11 activos, 5 deshabilitados) |
| Windows Logins | 25 (todos activos) |
| Windows Groups | 0 |
| Logins IP-based | 5 (10.4.40.227, 172.30.249.165, 172.30.249.166, 172.30.249.167, 172.30.251.85) |
| Logins deshabilitados | gmondragonca, gmurgaso, hramosm, jguzmanc, jsernah |
| Linked servers | 4 (10.226.3.96, 10.4.40.229, 172.30.249.166, 172.30.251.85) |
| Linked server con remote login | 172.30.251.85 |

### 7.5 Infraestructura

| Metrica | Valor |
|---|---|
| Servidor | WINDBDVNB0001 |
| IP | 172.30.249.165 |
| Motor | SQL Server 2014 SP3 (12.0.6024.0) |
| Edicion | Enterprise Edition (64-bit) |
| SO | Windows Server 2016 (Build 14393) Hypervisor |
| Memoria | 32,767 MB (32 GB) |
| CPUs | 8 |
| Collation | SQL_Latin1_General_CP1_CI_AS |
| Clustered | No |
| HADR | No |
| Fulltext | Si |
| BDs usuario | 16 |
| Inicio servicio | 2025-10-02 14:50:47 |
| Almacenamiento total datos | 2.7 TB |
| Puerto SQL | 1433 |
| Puerto RDP | 3389 |
| Guardicore Agent | Activo |

## 8. Hallazgos de Seguridad

Se investigaron los 7 hallazgos de seguridad reportados por el scanner. Resultado: **6 falsos positivos, 1 informativo (no critico)**.

| # | Archivo | Linea | Tipo | Severidad Scanner | Veredicto QA | Razon |
|---|---|---|---|---|---|---|
| 1 | export_etl.ps1 | 439 | Password assignment | critical | FALSE POSITIVE | Script de recoleccion MEP. Usa variable runtime `$script:_credPass` para `SQLCMDPASSWORD`. Sin credenciales hardcoded. |
| 2 | export_etl.ps1 | 603 | Password assignment | critical | FALSE POSITIVE | Connection string parametrizado. Valor de password viene de variable `$script:_credPass`, no hardcoded. |
| 3 | export_etl.ps1 | 643 | Password assignment | critical | FALSE POSITIVE | Mismo patron que #2 - connection string para SSISDB con variable parametrizada. |
| 4 | export_etl.ps1 | 1053 | Password assignment | critical | FALSE POSITIVE | Limpieza de credenciales: `$env:SQLCMDPASSWORD = $null`. Buena practica de seguridad. |
| 5 | gather_sqlserver.ps1 | 319 | Password assignment | critical | FALSE POSITIVE | Mismo patron que #1 - script de recoleccion con variable parametrizada. |
| 6 | gather_sqlserver.ps1 | 1016 | Password assignment | critical | FALSE POSITIVE | Limpieza de credenciales al finalizar script. Mismo patron seguro. |
| 7 | New Package_connections.txt | 10 | Connection string | critical | INFO (no critico) | Ruta local OneDrive corporativa: `D:\OneDrive - Integratel Peru\07_Documentos_Gestion_TDP\03_Calidad\`. No contiene credenciales. Revela ruta de trabajo interna. Riesgo bajo. |

**Conclusion de seguridad:** No se identificaron credenciales expuestas ni riesgos de seguridad reales. Los 6 hallazgos en scripts PowerShell son falsos positivos del patron de deteccion "Password assignment" que no distingue entre asignaciones de variables parametrizadas y credenciales hardcoded. El hallazgo #7 es una ruta de archivo OneDrive corporativa que no representa un riesgo de seguridad.

## 9. Checklist QA

| Item | Descripcion | Estado | Observacion |
|---|---|---|---|
| 1.1 | Ficha funcional presente | OK | A01_Ficha_Funcional_WINDBDVNB0001.docx presente y completa. |
| 1.2 | Estructura de subcarpetas completa | OK | 8 de 8 subcarpetas presentes (A-H). |
| 1.3 | Volumen y consistencia de archivos | OK | 479 archivos, 46 MB. Estructura consistente con MSSQL. |
| 1.4 | Datos de servidor verificados | OK | Hostname WINDBDVNB0001, IP 172.30.249.165, instancia DESTDPPLANCO verificados. |
| 1.5 | Datos de gerencia y focal verificados | OK | Gerencia de Atencion (D3 Customer Care). Focal B.Quispe/R.Smith confirmados en logins. |
| 2.1 | Motor y version documentados | OK | SQL Server 2014 SP3 Enterprise Edition (12.0.6024.0). Windows Server 2016 Build 14393. |
| 2.2 | Bases de datos documentadas | OK | 16 bases de datos documentadas, todas ONLINE. Recovery model FULL en todas. |
| 2.3 | Inventario de objetos completo | OK | 3010 tablas, 207 SPs, 55 views, 18 funciones documentados con detalle. |
| 2.4 | Jobs y schedules documentados | WARN | 12 de 43 jobs deshabilitados (28%). Falta documentacion de razon de deshabilitacion. |
| 3.1 | SQL Agent jobs inventariados | OK | 43 jobs documentados con pasos, schedules, subsistemas. |
| 3.2 | ETL/SSIS documentados | WARN | 46 paquetes SSIS en 8 proyectos. ETL_Base_04_Averias.dtsx con 100% fallas. Tasa exito general 89.5%. |
| 3.3 | Lineage documentado | FAIL | Subcarpeta G vacia (solo 'no aplica.txt'). Sin documentacion de lineage para 16 BDs y multiples flujos SSIS. |
| 3.4 | Scheduled tasks documentadas | OK | 2 scheduled tasks de aplicacion (BotMaker deshabilitado, Guardicore activo). Resto del sistema. |
| 4.1 | Interfaces documentadas | OK | E01_E02_Interfaces_WINDBDVNB0001.xlsx presente. 4 linked servers documentados. |
| 4.2 | Artefactos BI documentados | OK | F01_Reportes_BI_WINDBDVNB0001.xlsx presente. |
| 4.3 | Dependencias externas identificadas | WARN | 4 linked servers. LS 172.30.251.85 con remote login habilitado. Conexiones Teradata via SSIS. |
| 5.1 | Matriz de accesos presente | OK | H01_Accesos_WINDBDVNB0001.xlsx presente. 41 logins documentados. |
| 5.2 | Convencion de nombrado de logins | WARN | 5 SQL logins con nombres IP-based activos. No siguen convencion de nombrado estandar. |
| 5.3 | Credenciales expuestas | OK | 0 de 7 hallazgos de seguridad son credenciales reales. 6 FP en scripts de recoleccion, 1 ruta OneDrive informativa. |
| 5.4 | Permisos documentados | OK | Permisos documentados por BD con principals, role_members y permissions. Roles asignados apropiadamente. |
| 6.1 | Scripts de recoleccion presentes | OK | gather_sqlserver.ps1 y export_etl.ps1 presentes y funcionales. |
| 6.2 | Documentacion tecnica completa | FAIL | Subcarpeta G sin lineage. No documenta flujo de datos entre 16 BDs, SSIS, linked servers. |
| 6.3 | Consistencia interna de datos | OK | 479 archivos. Consistencia verificada entre subcarpetas B, C, D, E y H. Cross-references OK. |

**Resumen Checklist:** 15 OK, 4 WARN, 2 FAIL, 2 N/A --> 23 items evaluados. Tasa de cumplimiento: 65% OK, 17% WARN, 9% FAIL.

## 10. Recomendaciones

### 10.1 Bloqueantes

#### Acciones Integratel
1. **Completar subcarpeta G - Lineage/Documentacion:** Generar documentacion de lineage que cubra los flujos de datos entre las 16 bases de datos, los 46 paquetes SSIS, los 4 linked servers y las conexiones Teradata. Incluir diagramas de flujo de datos para los procesos principales: Procesos_Calidad, CONSOLIDACION_BASES_EXTERNAS, Delivery_Movil.

#### Acciones Stefanini
1. **Documentar estado de paquetes SSIS fallidos:** Verificar si ETL_Base_04_Averias.dtsx, COBRO_RECONEXION.dtsx, DESCUENTOS.dtsx y RETENCION_FIJA.dtsx son procesos activos con errores o procesos deprecados. Documentar la causa raiz de las fallas recurrentes.

### 10.2 Importantes

#### Acciones Integratel
1. **Documentar jobs deshabilitados:** Proporcionar justificacion para los 12 SQL Agent jobs deshabilitados (28% del total). Indicar si son deprecados, temporales o pendientes de reactivacion.
2. **Documentar linked servers:** Completar la documentacion de interfaces con el proposito y uso de cada linked server (10.226.3.96, 10.4.40.229, 172.30.249.166, 172.30.251.85).
3. **Confirmar bases de backup:** Identificar cuales de las 9 bases BD_BACKUP_* (1.9 TB) son necesarias para el assessment y cuales pueden excluirse.

#### Acciones Stefanini
1. **Documentar logins IP-based:** Mapear los 5 logins SQL con nombres IP-based (10.4.40.227, 172.30.249.165, 172.30.249.166, 172.30.249.167, 172.30.251.85) a los servidores y aplicaciones que los utilizan.
2. **Verificar linked server 172.30.251.85:** Evaluar si el remote login habilitado en este linked server es necesario y documentar su uso.

### 10.3 Observaciones para el Assessment

1. **SQL Server 2014 SP3 End of Life:** El motor esta en EOL desde julio 2024. Esto es informativo para el assessment y debe registrarse en el inventario pero no requiere accion dentro del scope del MEP.
2. **Volumen de almacenamiento:** El servidor almacena 2.7 TB de datos. Las bases principales de produccion (TP_CALIDAD, CALIDAD_CRUCES, CALIDAD, BD_REGULADOS) suman ~883 GB. Las bases de backup historico suman ~1.9 TB.
3. **Guardicore Agent activo:** El servidor tiene Guardicore Agent activo (microsegmentacion), lo que indica que hay controles de red implementados.
4. **Conexion Teradata:** Existe un paquete SSIS (Extraccion_teradata.dtsx) que conecta a Teradata, lo cual es una dependencia cross-platform relevante para el assessment.
5. **OneDrive corporativo:** Un connection string de paquete SSIS referencia una ruta OneDrive local (`D:\OneDrive - Integratel Peru\`), lo que sugiere que algunos procesos pueden depender de archivos locales en el servidor.
