# QA Report - MEP_GPPESVLCLI2251

## 1. Informacion General

| Campo | Valor |
|-------|-------|
| **Servidor** | GPPESVLCLI2251 |
| **IP** | 10.4.40.229 |
| **Motor** | Microsoft SQL Server 2008 R2 SP2 (10.50.4000.0) |
| **Edicion** | Standard Edition (64-bit) |
| **Sistema Operativo** | Windows NT 6.2 (Build 9200) - Hypervisor |
| **Gerencia** | Gerencia de Atencion (D3 Customer Care) |
| **Focal** | B.Quispe / R.Smith |
| **Tracker** | #15 |
| **SME** | SME_1 |
| **Bases de Datos** | 10 (BD_CONTROL, BD_D2D, db_admsql, PE_ModelosFranquicias, PE_Ventas_Presencial, PV_HistoricoVisitas2017, PV_RepoDerivacionesHistorico, PV_RepoVisitas_aloha, PV_STC_Comisiones, Ventas_Demanda_Reclamos) |
| **Schemas** | 16 (total across all DBs) |
| **Paquetes SSIS (msdb)** | 108 |
| **Fecha Extraccion** | 2026-03-16 |
| **Fecha QA** | 2026-03-20 |
| **Total Archivos** | 48 |
| **Tamano Total** | 4.83 MB |

## 2. Resumen Ejecutivo

El MEP_GPPESVLCLI2251 corresponde a un servidor MSSQL 2008 R2 SP2 de la Gerencia de Atencion (D3 Customer Care) con IP 10.4.40.229. El servidor aloja 10 bases de datos relacionadas con gestion postventa, ventas presencial, comisiones STC, derivaciones, visitas y atencion al cliente (COC/COT). Opera con una instalacion completa de SQL Server incluyendo SSAS, SSRS, SSIS y SQL Agent, con 108 paquetes SSIS almacenados en msdb y multiples procesos ETL de integracion con sistemas como BotMaker, Teradata y otros servidores internos.

La extraccion presenta una falla critica y sistematica: el script gather_sqlserver.ps1 fallo en las 269 consultas SQL ejecutadas debido a un error en la invocacion de sqlcmd (parametro '-s' del separador CSV no fue pasado correctamente). Como resultado, no se genero ningun CSV de diccionario de datos: no hay informacion de tablas, columnas, stored procedures, vistas, triggers, indices, permisos, roles, linked servers ni configuracion del servidor. Adicionalmente, 90 de 108 paquetes SSIS (83%) no pudieron ser exportados via dtutil. Este es un caso claro de extraccion fallida.

El veredicto es **RECHAZADO** con score 41/100 (grado D). El MEP no puede ser utilizado para el assessment en su estado actual. Se requiere reejecutar ambos scripts (gather_sqlserver.ps1 y export_etl.ps1) corrigiendo el bug del parametro sqlcmd. La infraestructura de servicios (subcarpeta B) y las tareas programadas (D40) si se extrajeron correctamente, lo que indica que el acceso al servidor y los permisos basicos son adecuados -- el problema es estrictamente un bug en el script de extraccion.

## 3. Scores

### Scores por Subcarpeta

| Subcarpeta | Nombre | Score | Justificacion |
|------------|--------|-------|---------------|
| A | Ficha Funcional | 70/100 | A01 presente (17 KB) pero no verificable automaticamente en DOCX. Falta ficha de infraestructura. |
| B | Software/Servicios | 80/100 | Completa: sc_query, services_ps, process_cmdline, tasklist_svc, installed_programs (x2), netstat. 7 archivos utiles. |
| C | Diccionario BD | 20/100 | Extraccion fallida. 0 CSVs de diccionario. Solo version.txt y 18 de 108 SSIS exportados (no parseables). ETL artefactos parciales. |
| D | Jobs/ETL/ELT | 55/100 | D40_scheduled_tasks.csv presente (171 tareas). Falta D41 (SQL Agent Jobs CSV). Jobs parcialmente documentados via C/AgentJobs. |
| E | Interfaces IO | 65/100 | E01_E02 presente en xlsx. No cruzable contra linked_servers (no extraidos). |
| F | BI Artefactos | 65/100 | F01_Reportes_BI presente en xlsx. No verificable sin diccionario de datos. |
| G | Lineage/Doc | 30/100 | Marcada 'no aplica' con archivo vacio. Cuestionable dado volumen ETL (108 SSIS, 10 BDs). |
| H | Seguridad/Accesos | 65/100 | H01_Accesos presente en xlsx. No cruzable contra logins/roles/permissions (no extraidos). |

### Penalizaciones

| Penalizacion | Puntos | Motivo |
|--------------|--------|--------|
| Extraccion fallida gather_sqlserver | -10 | 269 errores sqlcmd, 0 CSVs de diccionario generados para 10 BDs |
| SSIS export fallido (>80%) | -5 | 90 de 108 paquetes no exportados por dtutil |
| **Total penalizaciones** | **-15** | |

### Score Final

| Metrica | Valor |
|---------|-------|
| Promedio subcarpetas | 56.25 |
| Penalizaciones | -15 |
| **Score final** | **41/100** |
| **Grado** | **D** |
| **Veredicto** | **RECHAZADO** |

## 4. Evaluacion por Subcarpeta

### 4.1 A (70/100)

**Archivos:**
- `A01_Ficha_Funcional_GPPESVLCLI2251.docx` (17 KB)

**Evaluacion:**
La ficha funcional existe en formato DOCX. El tamano (17 KB) sugiere contenido basico. No es posible verificar automaticamente si todos los campos requeridos estan completos (descripcion funcional, responsables, SLAs, criticidad, etc.). No se incluye ficha de infraestructura separada. El archivo sigue la nomenclatura correcta A01_Ficha_Funcional_[SERVIDOR].docx.

### 4.2 B (80/100)

**Archivos:**
- `B10_sc_query.txt` (114 KB) - Servicios Windows via sc query
- `B10_services_ps.txt` (33 KB) - Servicios via PowerShell Get-Service
- `B11_process_cmdline.csv` (10 KB, 82 filas) - Procesos con linea de comandos
- `B11_tasklist_svc.txt` (15 KB) - Tasklist con servicios asociados
- `B12_installed_programs.csv` (5 KB, 61 filas) - Programas instalados (64-bit)
- `B12b_installed_programs.csv` (3 KB, 116 filas) - Programas instalados (32-bit)
- `B13_netstat.txt` (38 KB) - Conexiones de red activas

**Evaluacion:**
Subcarpeta bien cubierta con 7 archivos de evidencia. Se capturan servicios por dos metodos (sc query y PowerShell), procesos con detalle de linea de comandos, programas instalados en ambas arquitecturas y conexiones de red. Se confirman los servicios SQL activos (MSSQLSERVER, SQLSERVERAGENT, MSSQLServerOLAPService, ReportServer, MsDtsServer100, SQLBrowser). Software de seguridad presente: Panda/Cytomic Endpoint, Guardicore. Monitoreo: Pandora FMS, Zabbix. SCCM activo. Puerto 1433 abierto con conexiones entrantes activas.

### 4.3 C (20/100)

**Archivos:**
- `mep_sqlserver_GPPESVLCLI2251_20260316_094318/_instance/00_version.txt` (245 bytes)
- `mep_sqlserver_GPPESVLCLI2251_20260316_094318/gather_sqlserver.log` (264 KB)
- `mep_etl_GPPESVLCLI2251_20260316_094501/export_etl.log` (17 KB)
- `mep_etl_GPPESVLCLI2251_20260316_094501/AgentJobs/all_job_steps.csv` (5 KB, 62 filas)
- `mep_etl_GPPESVLCLI2251_20260316_094501/AgentJobs/cmdexec_powershell_steps.csv` (339 bytes, 3 filas)
- `mep_etl_GPPESVLCLI2251_20260316_094501/AgentJobs/ssis_job_steps.csv` (581 bytes, 4 filas)
- `mep_etl_GPPESVLCLI2251_20260316_094501/AgentJobs/tsql_job_steps.sql` (3 KB)
- `mep_etl_GPPESVLCLI2251_20260316_094501/MSDB/inventory.csv` (7 KB, 109 filas)
- `mep_etl_GPPESVLCLI2251_20260316_094501/MSDB/_extracted/Correr_Todo_connections.txt` (232 bytes)
- `mep_etl_GPPESVLCLI2251_20260316_094501/MSDB/_extracted/Correr_Todo_sql_tasks.sql` (126 bytes)
- 18 archivos `.dtsx` exportados desde msdb (no parseables como XML)
- `scripts.zip` (29 KB) - Scripts de recoleccion originales

**Evaluacion:**
Esta es la subcarpeta critica y presenta falla total en la extraccion del diccionario de datos. El script gather_sqlserver.ps1 v4.1 ejecuto correctamente la deteccion de version y el descubrimiento de 10 bases de datos con 16 schemas, pero fallo sistematicamente en TODAS las 269 consultas de extraccion por un bug en la invocacion de sqlcmd: el parametro '-s' (column separator) no fue pasado correctamente, generando el error "Sqlcmd: '-s': Missing argument". Como resultado, no existe ningun CSV de diccionario de datos (0 de 20 archivos esperados).

El ETL export tuvo exito parcial: de 108 paquetes en msdb, se exportaron 18 como .dtsx pero ninguno pudo ser parseado como XML valido. Se extrajeron artefactos de Agent Jobs (all_job_steps, SSIS steps, T-SQL embebido, PowerShell steps) y el inventario de MSDB (109 paquetes). Los paquetes exportados incluyen Data Collector (sistema), cargas de negocio (Altas Fija/Movil, CAEQ, Fibra, Migraciones) y el orquestador Correr_Todo.

### 4.4 D (55/100)

**Archivos:**
- `D40_scheduled_tasks.csv` (166 KB, 171 filas, UTF-16LE)

**Evaluacion:**
Se capturaron las tareas programadas de Windows (171 registros) correctamente. Las tareas incluyen procesos de BotMaker, transferencias desde servidor 167, y diversos procesos de Inteligencia de Clientes. La mayoria estan deshabilitadas (status=Disabled). Algunas muestran Last Result=-2147024895 (error de acceso). Falta el CSV de SQL Agent Jobs (D41) que deberia haberse generado desde gather_sqlserver pero fallo por el bug de sqlcmd. Los Agent Jobs se documentan parcialmente via los archivos de C/AgentJobs.

### 4.5 E (65/100)

**Archivos:**
- `E01_E02_Interfaces_GPPESVLCLI2251.xlsx` (9 KB)

**Evaluacion:**
El archivo de interfaces existe y sigue la nomenclatura correcta. Sin embargo, no es posible validar automaticamente su contenido (formato xlsx). Sin los CSVs de linked_servers y sin las connection strings completas de los paquetes SSIS, no se puede cruzar las interfaces declaradas contra las conexiones reales del servidor. El netstat muestra conexion saliente a 10.226.3.218:1433 que podria ser un linked server no documentado.

### 4.6 F (65/100)

**Archivos:**
- `F01_Reportes_BI_GPPESVLCLI2251.xlsx` (9 KB)

**Evaluacion:**
El archivo de reportes BI existe. El servidor tiene SSRS activo (ReportingServicesService, PID 3056) y SSAS activo (msmdsrv.exe, PID 2296, puerto 2383), lo que confirma que hay artefactos BI. Sin el diccionario de datos del Report Server, no se puede validar si los reportes declarados en F01 cubren todos los reportes desplegados en SSRS.

### 4.7 G (30/100)

**Archivos:**
- `no aplica.txt` (0 bytes - archivo vacio)

**Evaluacion:**
La subcarpeta esta marcada como "no aplica" con un archivo vacio. Esto es cuestionable dado que el servidor tiene: 108 paquetes SSIS en msdb, 10 bases de datos, procesos ETL que integran datos de BotMaker, COC, COT, NPS, Ventas, Canales Escritos, entre otros. Existe una conexion saliente a otro servidor SQL (10.226.3.218:1433) y referencias a Teradata en los paquetes SSIS. El lineage de datos seria valioso para el assessment. Se otorga score parcial por la existencia de la subcarpeta con justificacion explicita (aunque insuficiente).

### 4.8 H (65/100)

**Archivos:**
- `H01_Accesos_GPPESVLCLI2251.xlsx` (9 KB)

**Evaluacion:**
El archivo de accesos existe y sigue la nomenclatura correcta. Sin embargo, sin los CSVs de seguridad (02_logins.csv, S10_roles.csv, S11_users.csv, S12_permissions.csv), no se puede realizar validacion cruzada entre los accesos documentados y los accesos reales del servidor. El scanner no detecto credenciales expuestas en ninguno de los 25 archivos de texto escaneados.

## 5. Hallazgos

### 5.1 Criticos (FAIL)

| ID | Titulo | Subcarpeta | Impacto |
|----|--------|------------|---------|
| F-001 | Extraccion de diccionario de datos completamente fallida | C | Sin diccionario de datos, es imposible realizar el assessment de la BD. 269 errores sqlcmd, 0 CSVs para 10 BDs. |
| F-002 | 83% de paquetes SSIS no exportados (90 de 108) | C | Cobertura incompleta de logica ETL. Paquetes con conexiones y dependencias criticas no documentadas. |
| F-003 | Ausencia total de CSVs de inventario de servidor (00-05, S01-S14) | C | Assessment bloqueado: sin catalogo de objetos, seguridad de BD, linked servers ni configuracion. |

### 5.2 Advertencias (WARN)

| ID | Titulo | Subcarpeta | Impacto |
|----|--------|------------|---------|
| F-004 | Falta exportacion de SQL Agent Jobs en CSV (D41) | D | No hay detalle estructurado de Agent Jobs. Solo inferible desde C/AgentJobs. |
| F-005 | Ficha funcional DOCX no verificable automaticamente | A | No se confirma completitud de campos requeridos. |
| F-006 | Interfaces sin validacion cruzada posible | E | No se verifica completitud de interfaces declaradas vs. reales. |
| F-007 | Lineage marcado 'no aplica' cuestionable | G | Sin trazabilidad del flujo de datos entre sistemas fuente y destino. |
| F-008 | Accesos sin CSVs de validacion cruzada | H | No se verifica que accesos documentados correspondan a la realidad. |

### 5.3 Informativos (INFO)

| ID | Titulo | Subcarpeta | Detalle |
|----|--------|------------|---------|
| F-009 | SQL Server 2008 R2 SP2 - End of Life | General | EOL desde julio 2019. Sin parches de seguridad desde hace >6 anos. |
| F-010 | Multiples agentes de monitoreo y seguridad | B | Pandora FMS, Zabbix, Panda/Cytomic, Guardicore, SCCM, NXLog, ManageEngine. |
| F-011 | Suite SQL Server completa activa | B | MSSQLSERVER, SQLSERVERAGENT, SSAS, SSRS, SSIS, SQL Browser operativos. |
| F-012 | Orquestador Correr_Todo.dtsx con 10 connections | C | Paquete orquestador con connection managers (nombres no extraidos). |
| F-013 | 171 tareas programadas Windows (mayoria deshabilitadas) | D | Procesos historicos de BotMaker, transferencias 167, Inteligencia de Clientes. |

## 6. Cross-References

| Elemento | Fuente | Destino | Estado | Observacion |
|----------|--------|---------|--------|-------------|
| Puerto SQL 1433 | B13_netstat | Conexiones activas | Verificado | 7 conexiones desde 172.19.26.7, 1 desde 172.19.28.3 |
| Puerto SSAS 2383 | B13_netstat | msmdsrv.exe (SSAS) | Verificado | Escuchando en 0.0.0.0 |
| Conexion saliente 1433 | B13_netstat | 10.226.3.218:1433 | No cruzable | Posible linked server, no verificable sin 04_linked_servers.csv |
| SSIS jobs en Agent | all_job_steps.csv | ssis_job_steps.csv | Consistente | 3 SSIS steps en Agent Jobs: BotMaker Notification, BotMaker Descarga, Visitas |
| Paquetes MSDB | inventory.csv (109) | export_etl.log (108) | Consistente | Diferencia de 1 por conteo con/sin header separator |
| Servicios SQL activos | B10_services_ps.txt | B11_tasklist_svc.txt | Consistente | MSSQLSERVER, SQLAGENT, SSAS, SSRS, SSIS confirmados en ambas fuentes |
| Version SQL | 00_version.txt | B12_installed_programs.csv | Consistente | Ambos reportan SQL Server 2008 R2 SP2 |
| Guardicore Agent | B11_tasklist_svc.txt | B13_netstat | Verificado | gc-agents-service activo, multiples subprocesos (detection, enforcement, deception, guest, controller) |
| Tareas Windows | D40_scheduled_tasks.csv | SSIS paths | Consistente | Tareas referencian M:\Inteligencia_de_Clientes\Proyectos_SSIS\ |
| BotMaker jobs | all_job_steps.csv | D40_scheduled_tasks.csv | Parcial | Jobs de BotMaker en ambas fuentes, en estado deshabilitado/disabled |

## 7. Estadisticas del Servidor

### 7.1 Bases de Datos

| Base de Datos | Esquemas | Archivos Generados | Tamano | Observacion |
|---------------|----------|--------------------|--------|-------------|
| BD_CONTROL | dbo | 0 | N/D | Extraccion fallida |
| BD_D2D | N/D | 0 | N/D | Extraccion fallida |
| db_admsql | N/D | 0 | N/D | Extraccion fallida |
| PE_ModelosFranquicias | N/D | 0 | N/D | Extraccion fallida |
| PE_Ventas_Presencial | N/D | 0 | N/D | Extraccion fallida |
| PV_HistoricoVisitas2017 | N/D | 0 | N/D | Extraccion fallida |
| PV_RepoDerivacionesHistorico | N/D | 0 | N/D | Extraccion fallida |
| PV_RepoVisitas_aloha | N/D | 0 | N/D | Extraccion fallida |
| PV_STC_Comisiones | N/D | 0 | N/D | Extraccion fallida |
| Ventas_Demanda_Reclamos | N/D | 0 | N/D | Extraccion fallida |

*Nota: 16 schemas descubiertos en total pero no se pudo extraer metadata de ninguno.*

### 7.2 Objetos

| Tipo de Objeto | Cantidad | Fuente |
|----------------|----------|--------|
| Bases de datos de usuario | 10 | gather_sqlserver.log |
| Schemas totales | 16 | gather_sqlserver.log |
| Tablas | N/D | Extraccion fallida |
| Vistas | N/D | Extraccion fallida |
| Stored Procedures | N/D | Extraccion fallida |
| Functions | N/D | Extraccion fallida |
| Triggers | N/D | Extraccion fallida |
| Indices | N/D | Extraccion fallida |
| Paquetes SSIS (msdb) | 108 | inventory.csv |
| Paquetes SSIS exportados | 18 | export_etl.log |

### 7.3 ETL/Jobs

| Categoria | Cantidad | Fuente | Estado |
|-----------|----------|--------|--------|
| Paquetes SSIS en msdb | 108 | inventory.csv | 18 exportados, 90 fallidos |
| SQL Agent Jobs (steps) | 62 | all_job_steps.csv | Parcial - incluye jobs deshabilitados |
| SSIS Job Steps | 3 | ssis_job_steps.csv | BotMaker Notification, BotMaker Descarga, Visitas |
| CmdExec/PowerShell Steps | 1 | cmdexec_powershell_steps.csv | syspolicy_purge_history |
| T-SQL Job Steps | 11 | tsql_job_steps.sql | Captura sesiones, DB size, logs, conexiones, tablas, etc. |
| Tareas programadas Windows | 171 | D40_scheduled_tasks.csv | Mayoria deshabilitadas |
| Paquete orquestador | 1 | Correr_Todo.dtsx | 10 connection managers |

### 7.4 Seguridad

| Aspecto | Estado | Detalle |
|---------|--------|---------|
| Logins del servidor | N/D | Extraccion fallida (02_logins.csv no generado) |
| Roles de BD | N/D | Extraccion fallida |
| Usuarios de BD | N/D | Extraccion fallida |
| Permisos | N/D | Extraccion fallida |
| Credenciales expuestas | 0 hallazgos | Scanner escaneo 25 archivos sin encontrar credenciales |
| Endpoint Protection | Activo | Panda/Cytomic Endpoint Agent v1.23.01, Advanced EPDR v8.0.24 |
| Network Security | Activo | Guardicore Agent con modulos detection, enforcement, deception |

### 7.5 Infraestructura

| Aspecto | Valor | Fuente |
|---------|-------|--------|
| Hostname | GPPESVLCLI2251 | 00_version.txt, D40 |
| IP | 10.4.40.229 | B13_netstat |
| OS | Windows NT 6.2 (Build 9200) | 00_version.txt |
| Virtualizacion | Hypervisor | 00_version.txt |
| SQL Server | 2008 R2 SP2 (10.50.4000.0) | 00_version.txt |
| Edicion | Standard Edition (64-bit) | 00_version.txt |
| Puerto SQL | 1433 | B13_netstat |
| Puerto SSAS | 2383 | B13_netstat |
| Puerto HTTP/IIS | 80, 8081 | B13_netstat |
| Puerto RDP | 3389 | B13_netstat |
| Puerto FTP | ftpsvc activo | B10_services_ps.txt |
| Monitoreo | Pandora FMS, Zabbix (puerto 10050), NXLog | B11_tasklist_svc.txt |
| SCCM | CcmExec activo (SMS Agent Host) | B11_tasklist_svc.txt |
| Backup/Archival | GXHSM Recaller, GxCVD activos | B11_tasklist_svc.txt |

## 8. Hallazgos de Seguridad

No se detectaron hallazgos criticos de seguridad en los archivos analizados:

- **Credenciales expuestas**: 0 hallazgos. El scanner analizo 25 archivos de texto sin detectar passwords, connection strings con credenciales, ni tokens.
- **Endpoint Protection**: Panda/Cytomic Endpoint Agent (v1.23.01) y Advanced EPDR (v8.0.24) activos.
- **Network Security**: Guardicore Agent Service activo con 5 subprocesos (detection, enforcement, deception, guest-agent, controller). Esto indica segmentacion de red implementada.
- **Puertos abiertos**: SQL (1433), SSAS (2383), HTTP (80, 8081), RDP (3389), FTP (ftpsvc activo), Zabbix (10050), y varios puertos de gestion. El FTP activo en un servidor de BD merece atencion.
- **SQL Server EOL**: Version 2008 R2 SP2 sin soporte desde julio 2019. No se reciben parches de seguridad.
- **Limitacion**: Sin CSVs de logins, roles, usuarios y permisos, no se puede evaluar la postura de seguridad a nivel de base de datos.

## 9. Checklist QA

| Item | Descripcion | Estado | Observacion |
|------|-------------|--------|-------------|
| **1. Estructura del MEP** | | | |
| 1.1 | Subcarpetas A-H presentes | CUMPLE | Las 8 subcarpetas estan presentes. |
| 1.2 | Archivos con contenido suficiente | CUMPLE | 48 archivos, 4.83 MB total. |
| 1.3 | Nomenclatura correcta | CUMPLE | Archivos siguen convencion A01, B10-B13, D40, E01, F01, H01. |
| 1.4 | Archivos legibles y no corruptos | CUMPLE | CSVs con encoding correcto (Windows-1252/latin-1/UTF-16LE). |
| 1.5 | Fichas completas (funcional + infra) | NO CUMPLE | Ficha funcional presente pero no verificable (DOCX). Falta ficha de infraestructura. |
| **2. Contenido Tecnico** | | | |
| 2.1 | Motor detectado correctamente | CUMPLE | MSSQL detectado con alta confianza. Version 10.50.4000.0. |
| 2.2 | Servicios y software capturados | CUMPLE | sc_query, services_ps, processes, tasklist, installed_programs, netstat presentes. |
| 2.3 | Diccionario de datos extraido | NO CUMPLE | Extraccion COMPLETAMENTE FALLIDA. 269 errores sqlcmd. 0 CSVs de diccionario. |
| 2.4 | CSVs de inventario servidor presentes | NO CUMPLE | Faltan TODOS: 00-05 y S01-S14 (20 archivos). |
| **3. Calidad de Datos** | | | |
| 3.1 | CSVs parseables y con datos | CUMPLE | 8 CSVs presentes y parseables correctamente. |
| 3.2 | Coherencia entre fuentes | NO CUMPLE | Sin CSVs de diccionario para validar coherencia integral. |
| 3.3 | Cross-references verificables | NO CUMPLE | Interfaces, BI y accesos no cruzables sin diccionario. |
| 3.4 | Sin credenciales expuestas | CUMPLE | 0 hallazgos de seguridad en 25 archivos escaneados. |
| **4. ETL y Jobs** | | | |
| 4.1 | Jobs/ETL documentados | CUMPLE | SSIS parcial (18/108), Agent Jobs (62 steps), tareas Windows (171). |
| 4.2 | Cobertura ETL adecuada | NO CUMPLE | 83% de paquetes SSIS no exportados. DTutil fallo en 90 paquetes. |
| 4.3 | Artefactos ETL extraidos | NO CUMPLE | Connection managers con nombres vacios. Sin dataflow ni script tasks. |
| **5. Interfaces y Dependencias** | | | |
| 5.1 | Interfaces documentadas | CUMPLE | E01_E02_Interfaces y F01_Reportes_BI presentes. |
| 5.2 | Interfaces validables | NO CUMPLE | Sin linked_servers ni connection strings para validacion cruzada. |
| 5.3 | Lineage documentado | NO CUMPLE | Marcado 'no aplica'. Cuestionable con 108 SSIS y 10 BDs. |
| 5.4 | Dependencias entre BDs | NO CUMPLE | Sin datos de diccionario para evaluar dependencias. |
| **6. Seguridad** | | | |
| 6.1 | Accesos documentados | CUMPLE | H01_Accesos presente en xlsx. |
| 6.2 | Accesos validables | NO CUMPLE | Sin CSVs de logins, roles, users, permissions. |
| 6.3 | Sin exposicion de credenciales | CUMPLE PARCIAL | Sin credenciales en texto, pero validacion limitada sin CSVs de seguridad. |

### Resumen Checklist

| Resultado | Cantidad |
|-----------|----------|
| CUMPLE | 11 |
| NO CUMPLE | 10 |
| CUMPLE PARCIAL | 2 |
| **Total items** | **23** |

## 10. Recomendaciones

### 10.1 Bloqueantes

#### Acciones Integratel

1. **Reejecutar gather_sqlserver.ps1**: Corregir el bug en la invocacion de sqlcmd que causa "'-s': Missing argument" en todas las consultas. El problema es la forma en que se pasa el parametro del separador de columnas al ejecutable sqlcmd. Verificar que la version de sqlcmd instalada (SQL Server 2008 R2 nativa) soporte la sintaxis utilizada por el script v4.1.

2. **Reejecutar export_etl.ps1**: Tras corregir el script, reexportar los 108 paquetes SSIS desde msdb. Considerar exportacion directa desde la tabla msdb.dbo.sysssispackages como alternativa a dtutil si este sigue fallando. Los paquetes DTS legacy (exit code 6) pueden requerir herramientas especificas.

3. **Entregar CSVs faltantes**: Tras la reextraccion, verificar que se generen los 20 archivos esperados (00_server_info.csv a 05_server_config.csv, S01 a S14 por cada esquema de cada BD).

#### Acciones Stefanini

1. **Validar scripts de recoleccion**: Confirmar que el script gather_sqlserver.ps1 ha sido actualizado para manejar correctamente la invocacion de sqlcmd en SQL Server 2008 R2. El parametro '-s' requiere formato especifico en versiones legacy.

2. **Coordinar ventana de reextraccion**: Agendar con focal B.Quispe/R.Smith la reextraccion en horario de baja carga del servidor.

### 10.2 Importantes

#### Acciones Integratel

1. **Justificar o completar Lineage (G)**: Proporcionar justificacion documentada del "no aplica" para lineage, o generar lineage basico desde los paquetes SSIS exportados y las connection strings. Dado que el servidor tiene 108 paquetes SSIS, 10 BDs y conexiones a otros servidores, la ausencia de lineage requiere explicacion.

2. **Completar ficha de infraestructura**: Agregar ficha de infraestructura a subcarpeta A con datos del servidor (CPU, RAM, discos, red).

3. **Incluir D41 SQL Agent Jobs**: Generar CSV especifico de SQL Agent Jobs para subcarpeta D, complementando las tareas programadas de Windows ya capturadas.

#### Acciones Stefanini

1. **Verificar validacion cruzada post-reextraccion**: Una vez entregados los CSVs faltantes, cruzar interfaces declaradas (E01) contra linked_servers, accesos declarados (H01) contra logins/roles/permissions, y reportes BI (F01) contra catalogo SSRS.

2. **Documentar conexion saliente a 10.226.3.218:1433**: El netstat muestra una conexion ESTABLISHED desde el servidor a 10.226.3.218:1433. Confirmar si corresponde a un linked server documentado.

### 10.3 Observaciones para el Assessment

1. **SQL Server 2008 R2 SP2 EOL**: El motor esta en End of Extended Support desde julio 2019. Documentar como riesgo informativo en el assessment. La decision sobre la version del motor destino queda fuera del alcance del MEP.

2. **Suite SQL completa**: El servidor opera MSSQLSERVER, SSAS, SSRS, SSIS y SQL Agent. El assessment debe considerar los 5 componentes para la migracion.

3. **Volumen ETL significativo**: 108 paquetes SSIS, 171 tareas programadas, 62 Agent Job steps. La complejidad ETL es considerable y requiere atencion especial en el assessment.

4. **FTP activo**: El servicio FTP (ftpsvc) esta activo en un servidor de base de datos. Verificar si es requerido para los procesos ETL (referencia a "FTP de BotMaker" en los nombres de jobs) y documentar en el assessment.

5. **Uso de drive M:**: Multiples tareas programadas y SSIS jobs referencian paths en `M:\Inteligencia_de_Clientes\Proyectos_SSIS\`. Confirmar la naturaleza de este volumen (local, SAN, NAS, compartido) para el plan de migracion.

6. **GXHSM activo**: El servidor tiene Graviton GXHSM Recaller activo, lo que sugiere archivado/HSM en los discos del servidor. Esto puede impactar la estrategia de migracion de datos.
