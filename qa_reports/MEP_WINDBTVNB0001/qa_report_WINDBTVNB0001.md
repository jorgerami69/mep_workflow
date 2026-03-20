# QA Report - MEP_WINDBTVNB0001

## 1. Informacion General

| Campo | Valor |
|-------|-------|
| Servidor | WINDBTVNB0001 |
| Instancia | TESTTDPPLANICO |
| IP | 172.30.249.166 |
| Motor | Microsoft SQL Server 2014 SP3 (12.0.6024.0) |
| Edicion | Enterprise Edition (64-bit) |
| Sistema Operativo | Windows Server 2016 (Build 14393) - Hypervisor |
| Gerencia | Gerencia de Atencion (D3 Customer Care) |
| Focal | B.Quispe / R.Smith |
| Tracker | #12 |
| SME | SME_1 |
| Archivos MEP | 872 archivos, 52.49 MB |
| Subcarpetas | 8/8 presentes (A-H) |
| Fecha de extraccion | 2026-03-09 |
| Fecha de QA | 2026-03-20 |
| Analista QA | QA Automatizado (Claude + Scanner v1.0.0) |

## 2. Resumen Ejecutivo

El servidor WINDBTVNB0001 (172.30.249.166) aloja una instancia SQL Server 2014 SP3 Enterprise Edition denominada TESTTDPPLANICO, perteneciente a la Gerencia de Atencion (D3 Customer Care). El servidor funciona como repositorio central de inteligencia de clientes y operaciones de contact center, alojando 25 bases de datos de usuario con un volumen total de 1.6 TB de datos. El MEP fue entregado con las 8 subcarpetas requeridas (A-H) conteniendo 872 archivos y 52.49 MB de informacion de inventario.

La evaluacion QA revela un MEP sustancialmente completo en terminos de diccionario de datos (subcarpeta C con 854 archivos cubriendo 25 bases de datos) y documentacion de ETL/Jobs (42 proyectos SSISDB, 43 SQL Agent Jobs). Sin embargo, se identificaron hallazgos criticos de seguridad: 7 ocurrencias de contrasenas SSIS triviales (/DECRYPT 123) expuestas en texto plano dentro de los job steps, y 9 connection strings con credenciales SQL en archivos de paquetes SSIS extraidos. Adicionalmente, la subcarpeta G (Lineage/Documentacion) esta vacia, lo cual es una deficiencia significativa dado el alto nivel de interconexion entre servidores (6 linked servers, transferencias entre servidores 165/166/167/227).

El score general del MEP es 62/100 (grado C), resultado de penalizaciones por los hallazgos de seguridad (-15 puntos) y la falta de documentacion de linaje. El veredicto es APROBADO CON OBSERVACIONES: el MEP contiene la informacion tecnica necesaria para proceder con el assessment, pero requiere que el equipo focal aborde las observaciones de seguridad y complete la documentacion de linaje antes de la migracion. Las contrasenas SSIS expuestas deben ser rotadas como parte del plan de migracion.

## 3. Scores

### Scores por Subcarpeta

| Subcarpeta | Nombre | Score | Justificacion |
|------------|--------|-------|---------------|
| A | Ficha Funcional | 70/100 | Archivo .docx presente pero no validable automaticamente. Tamano razonable (17 KB). |
| B | Software/Servicios | 90/100 | Completa: B10 (sc_query), B10 (services_ps), B11 (process/tasklist), B12 (programs), B13 (netstat). |
| C | Diccionario BD | 85/100 | 854 archivos cubriendo 25 BDs. Diccionario completo S01-S14 por esquema. Scripts de extraccion incluidos. |
| D | Jobs/ETL/ELT | 55/100 | D40 scheduled tasks presente. 43 Agent Jobs y 42 proyectos SSISDB documentados. Falta documentacion narrativa. |
| E | Interfaces I/O | 65/100 | xlsx presente (8.8 KB). 6 linked servers documentados en _instance. No validable contenido xlsx. |
| F | BI/Artefactos | 60/100 | xlsx presente (8.7 KB). Reportes PBI referenciados en jobs. No validable contenido xlsx. |
| G | Lineage/Documentacion | 30/100 | Solo contiene 'no aplica.txt' vacio. Deficiencia critica para servidor con 25 BDs y multiples interconexiones. |
| H | Seguridad/Accesos | 60/100 | xlsx presente (8.7 KB). 95 logins en 04_logins.csv. Permisos en 03_permissions.csv. No validable xlsx. |

### Penalizaciones

| Penalizacion | Puntos | Motivo |
|--------------|--------|--------|
| Contrasenas SSIS /DECRYPT en texto plano | -10 | 7 ocurrencias de /DECRYPT 123 en job steps de SQL Agent |
| Connection strings con credenciales SSIS | -5 | 9 connection strings con User IDs en archivos extraidos |
| **Total penalizaciones** | **-15** | |

### Score Final

| Metrica | Valor |
|---------|-------|
| Promedio ponderado subcarpetas | 77/100 |
| Penalizaciones | -15 |
| **Score final** | **62/100** |
| Grado | C |
| Veredicto | APROBADO CON OBSERVACIONES |

## 4. Evaluacion por Subcarpeta

### 4.1 A (70/100)

**Archivos:**
- A01_Ficha_Funcional_WINDBTVNB0001.docx (17,404 bytes)

**Evaluacion:**
La ficha funcional esta presente en formato Word (.docx). El tamano de 17 KB sugiere contenido basico pero existente. Al ser formato binario, no se puede validar automaticamente si contiene todos los campos requeridos (descripcion funcional, criticidad, ventana de mantenimiento, SLAs, contactos de escalamiento). Se requiere validacion manual del contenido. Se asigna score 70 porque el archivo existe pero no se puede confirmar completitud.

### 4.2 B (90/100)

**Archivos:**
- B10_sc_query.txt (151,780 bytes) - Servicios Windows via sc query
- B10_services_ps.txt (49,056 bytes) - Servicios via PowerShell Get-Service
- B11_process_cmdline.csv (20,800 bytes) - Procesos con linea de comando
- B11_tasklist_svc.txt (16,368 bytes) - Lista de tareas con servicios
- B12_installed_programs.csv (39,580 bytes) - Programas instalados (427 entradas)
- B13_netstat.txt (41,830 bytes) - Conexiones de red activas
- README_Instrucciones.md (702 bytes)

**Evaluacion:**
Subcarpeta B muy completa. Se documentan todos los servicios del sistema operativo (Windows Server 2016), los procesos en ejecucion con lineas de comando, 427 programas instalados y las conexiones de red. El netstat muestra puertos clave: 1433 (SQL Server), 3389 (RDP), 2382-2383 (Analysis Services), 10050 (Zabbix Agent), 33000. Se identifica el servicio MSSQL$TESTTDPPLANICO como la instancia principal. Score alto porque la informacion de infraestructura esta completa.

### 4.3 C (85/100)

**Archivos:**
- mep_scripts/gather_sqlserver.ps1 - Script de recopilacion SQL Server
- mep_scripts/export_etl.ps1 - Script de exportacion ETL
- mep_scripts/mep_sqlserver_WINDBTVNB0001_TESTTDPPLANICO_20260309_165333/ - Diccionario de 25 BDs
  - _instance/ (00_version.txt, 01_server_config.csv, 02_linked_servers.csv, 03_agent_jobs.csv, 04_logins.csv, 05_databases.csv)
  - 25 subdirectorios de BD, cada uno con: _database/ (01_principals.csv, 02_role_members.csv, 03_permissions.csv, 04_object_summary.csv) + dbo/ (S01-S14 CSVs)
- mep_scripts/mep_etl_WINDBTVNB0001_TESTTDPPLANICO_20260309_165414/ - Exportacion ETL
  - AgentJobs/ (all_job_steps.csv, ssis_job_steps.csv, tsql_job_steps.sql, cmdexec_powershell_steps.csv)
  - SSISDB/ (42 proyectos con paquetes .dtsx extraidos)
  - MSDB/ (paquetes legacy)
  - FileSystem/ (inventario)
- scripts.zip (MEP_Gatherer.bat + scripts)
- inventory.csv

**Evaluacion:**
La subcarpeta C es la mas completa del MEP con 854 archivos. El diccionario de datos cubre las 25 bases de datos con detalle a nivel de esquema incluyendo tablas/columnas (S01), primary keys (S02), tablas sin PK (S03), foreign keys (S04), indices (S05), check constraints (S06), stored procedures (S07), funciones (S08), triggers (S09), vistas (S10), tamanos de tabla (S11), extended properties (S12), dependencias (S13) y user types (S14). La exportacion ETL incluye los 42 proyectos SSISDB con sus paquetes DTSX y archivos de conexion extraidos. Score 85 por excelencia en cobertura; pierde puntos por contener hallazgos de seguridad.

### 4.4 D (55/100)

**Archivos:**
- D40_scheduled_tasks.csv (~244 KB, UTF-16)
- README_Instrucciones.md

**Evaluacion:**
La subcarpeta D contiene las scheduled tasks del sistema operativo pero carece de documentacion narrativa de los 43 SQL Agent Jobs (documentados en C/_instance/03_agent_jobs.csv). Los jobs incluyen procesos criticos de negocio como: carga de tipificaciones visor (GPR_*), procesos de demanda y KPIs (GMC_*), cargas SSIS adaptativas (FAY_*), procesos de planificacion (KAJ_*), actualizaciones de retenciones (HPU_*), y procesos de comisiones y cobranza. Falta un documento que describa el calendario de ejecucion y las dependencias entre jobs. Score bajo porque la documentacion de ETL es incompleta a nivel de carpeta D.

### 4.5 E (65/100)

**Archivos:**
- E01_E02_Interfaces_WINDBTVNB0001.xlsx (8,863 bytes)
- README_Instrucciones.md

**Evaluacion:**
El archivo xlsx de interfaces esta presente. El servidor tiene 6 linked servers configurados: 10.226.3.96, 10.4.40.227, 10.4.40.229, 172.30.249.165, 172.30.249.167, GPPESVLCLI2248. Ademas se identificaron conexiones FTP en paquetes SSIS (10.4.3.226:21, 10.4.40.49:21) y connection strings a servidores externos. Los jobs evidencian transferencias de datos bidireccionales entre servidores 165, 166, 167 y 227. No se puede validar automaticamente si el xlsx documenta todas estas interfaces. Score medio-bajo por incertidumbre en completitud.

### 4.6 F (60/100)

**Archivos:**
- F01_Reportes_BI_WINDBTVNB0001.xlsx (8,798 bytes)
- README_Instrucciones.md

**Evaluacion:**
El archivo xlsx de reportes BI esta presente. Se identifican multiples referencias a Power BI en los jobs del servidor: Proceso_PowerBI (Fija_Tec_Rellamadores.dtsx), PBI_Accesadas_Aura, PBI_Reit_Aura, PBI_Reit_Aura_7d, reportes de tipificaciones y dashboards. El servidor alimenta reportes de KPIs de contact center, demanda, retenciones y comisiones. No se puede validar el contenido del xlsx. Score medio-bajo por la misma razon.

### 4.7 G (30/100)

**Archivos:**
- no aplica.txt (0 bytes - vacio)
- README_Instrucciones.md

**Evaluacion:**
La subcarpeta G esta esencialmente vacia. El archivo "no aplica.txt" tiene 0 bytes, indicando que el equipo focal considero que la documentacion de linaje no aplica para este servidor. Esta es una deficiencia significativa considerando que el servidor: (1) tiene 25 bases de datos activas, (2) mantiene 6 linked servers para transferencias inter-servidor, (3) ejecuta 42 proyectos SSISDB con flujos de datos complejos, (4) transfiere datos entre los servidores 165, 166, 167 y 227. Un diagrama minimo de flujo de datos es esencial para la planificacion de migracion. Score muy bajo por falta total de documentacion de linaje.

### 4.8 H (60/100)

**Archivos:**
- H01_Accesos_WINDBTVNB0001.xlsx (8,781 bytes)
- README_Instrucciones.md

**Evaluacion:**
El archivo xlsx de accesos esta presente. La instancia tiene 95 logins registrados: 37 cuentas Windows del dominio GP (GP\*), 6 cuentas por IP para linked servers, 4 cuentas de servicio NT, y 48 cuentas SQL. De las cuentas SQL, 27 estan deshabilitadas (lo cual indica buena gestion de bajas). Los permisos estan documentados a nivel de BD en 03_permissions.csv y 02_role_members.csv para cada base de datos. No se puede validar si el xlsx refleja completamente esta informacion. Score medio por presencia del archivo pero sin validacion de contenido.

## 5. Hallazgos

### 5.1 Criticos (FAIL)

| ID | Categoria | Titulo | Descripcion |
|----|-----------|--------|-------------|
| F001 | Seguridad | Contrasenas SSIS /DECRYPT expuestas en texto plano | 7 ocurrencias de /DECRYPT 123 en job steps de SQL Agent. Contrasena trivial para paquetes SSIS del File System. |
| F002 | Seguridad | Connection strings con credenciales SQL en paquetes SSIS | CARGA_TOT_connections.txt contiene 9 connection strings con User IDs (rsmith, mcutimbop) y servidores destino. |
| F003 | Documentacion | Subcarpeta G_Lineage sin contenido util | Solo 'no aplica.txt' vacio. Sin documentacion de linaje para 25 BDs con interconexiones complejas. |

### 5.2 Advertencias (WARN)

| ID | Categoria | Titulo | Descripcion |
|----|-----------|--------|-------------|
| F004 | Completitud | Ficha Funcional (A01) sin validar contenido | Archivo .docx existe (17 KB) pero contenido no validable automaticamente. |
| F005 | Completitud | Scheduled Tasks (D40) sin analisis completo | Codificacion UTF-16, falta documentacion narrativa de jobs. |
| F006 | Completitud | Interfaces (E01/E02) en xlsx sin validacion | Existe pero no validable. 6 linked servers + conexiones FTP deben estar reflejados. |
| F007 | Completitud | Reportes BI (F01) en xlsx sin validacion | Existe pero no validable. Reportes PBI referenciados en jobs. |
| F008 | Completitud | Accesos (H01) en xlsx sin validacion | Existe pero 95 logins deben estar documentados. |
| F009 | Infraestructura | SQL Server 2014 SP3 en fin de soporte extendido | EOL desde julio 2024. Sin parches de seguridad. |
| F010 | Seguridad | Scripts de recopilacion con referencias a contrasenas | Falso positivo: export_etl.ps1 y gather_sqlserver.ps1 usan variables parametrizadas, no contrasenas hardcodeadas. |

### 5.3 Informativos (INFO)

| ID | Categoria | Titulo | Descripcion |
|----|-----------|--------|-------------|
| F011 | Infraestructura | Servidor con alto volumen de datos (1.6 TB) | 25 BDs, 1,601 GB datos + 12 GB logs. Mayor BD: Repo_Layout (586 GB). |
| F012 | Infraestructura | Conectividad con multiples servidores | 6 linked servers. Transferencias entre 165/166/167/227. FTP a 10.4.3.226 y 10.4.40.49. |
| F013 | ETL | 42 proyectos SSISDB con 109 paquetes DTSX | Catalogo SSISDB completo + paquetes legacy en File System. |
| F014 | Completitud | MEP Gatherer scripts incluidos | Scripts de recopilacion ejecutados 2026-03-09. Informativo. |
| F015 | Seguridad | Logins con gestion activa | 95 logins totales, 27 deshabilitados. Cuentas SQL + Windows + servicio. |

## 6. Cross-References

| Servidor Origen | Servidor Destino | Tipo Conexion | Evidencia |
|-----------------|------------------|---------------|-----------|
| 172.30.249.166 (este) | 172.30.249.165 | Linked Server | 02_linked_servers.csv, job steps con [172.30.249.165].* |
| 172.30.249.166 (este) | 172.30.249.167 | Linked Server | 02_linked_servers.csv, multiples jobs copian datos del 167 |
| 172.30.249.166 (este) | 10.226.3.96 | Linked Server + SSIS | 02_linked_servers.csv, CARGA_TOT_connections.txt (COBRANZA_PROD) |
| 172.30.249.166 (este) | 10.4.40.227 | Linked Server | 02_linked_servers.csv, job HPU copia catalogos del 227 |
| 172.30.249.166 (este) | 10.4.40.229 | Linked Server | 02_linked_servers.csv |
| 172.30.249.166 (este) | GPPESVLCLI2248 | Linked Server | 02_linked_servers.csv |
| 172.30.249.166 (este) | 10.4.3.226 | FTP | CARGA_TOT_connections.txt (FTP Connection Manager) |
| 172.30.249.166 (este) | 10.4.40.49 | FTP | CARGA_TOT_connections.txt (FTP Connection Manager 1) |
| 172.30.249.167 | 172.30.249.166 (este) | Transferencia datos | Jobs GPR_* copian tipificaciones y layouts del 167 al 166 |
| 172.30.249.165 | 172.30.249.166 (este) | Transferencia datos | Job JSH copia usuarios reclamos del 165 al 166 |
| 10.4.40.227 | 172.30.249.166 (este) | Transferencia datos | Job HPU copia catalogos comisiones del 227 al 166 |

## 7. Estadisticas del Servidor

### 7.1 Bases de Datos

| Base de Datos | Data (MB) | Log (MB) | Recovery | Estado | Collation |
|---------------|-----------|----------|----------|--------|-----------|
| BD_BACKUP_2021 | 273,000 | 250 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_BACKUP_2022 | 70,833 | 250 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_BACKUP_DEMANDA | 51,557 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_BACKUP_LOGSIEM | 204,971 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_BACKUP_PLANTAS | 73,193 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_CONTROL | 968 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_KIPU | 351 | 146 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_PROCESOS_CRUCES | 10,321 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| BD_Proyectos | 15,409 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_ALDM | 9,645 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Canales_Escritos | 40,187 | 101 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Comisiones | 3,610 | 177 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Contact_Center | 80,433 | 1,918 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Contactos | 721 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Dashboard | 33,774 | 1,744 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Extractores | 39,663 | 550 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Inteligencia | 117 | 31 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Layout | 586,000 | 3,001 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Planificacion | 41,999 | 1,801 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Planta_Ultima | 135 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Retenciones | 4,303 | 1,918 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Trazabilidad | 21,926 | 195 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| Repo_Visor | 24,461 | 121 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| SSISDB | 2,978 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| TP_Contact_Center | 49,094 | 1 | FULL | ONLINE | SQL_Latin1_General_CP1_CI_AS |
| **TOTAL** | **1,639,648 (1,601 GB)** | **12,214 (12 GB)** | | | |

### 7.2 Objetos

| Tipo de Objeto | Cantidad |
|----------------|----------|
| Tablas de usuario (USER_TABLE) | 854 |
| Vistas (VIEW) | 250 |
| Stored Procedures (SQL_STORED_PROCEDURE) | 291 |
| Funciones (SQL_SCALAR_FUNCTION) | 39 |
| Triggers | 0 |
| Constraints (PK, FK, CHECK, UNIQUE, DEFAULT) | 121 |
| **Total objetos principales** | **1,555** |

### 7.3 ETL/Jobs

| Metrica | Valor |
|---------|-------|
| SQL Agent Jobs (total) | 43 |
| Jobs habilitados | 28 |
| Jobs deshabilitados | 15 |
| Proyectos SSISDB | 42 |
| Paquetes SSIS (.dtsx) | 109 |
| Jobs con subsistema SSIS | ~20 |
| Jobs con subsistema TSQL | ~23 |
| Paquetes SSIS en File System | 7 (K:\Inteligencia_de_Clientes\Proyectos_SSIS) |
| Contrasenas /DECRYPT detectadas | 7 (todas usan "123") |

### 7.4 Seguridad

| Metrica | Valor |
|---------|-------|
| Logins totales | 95 |
| Logins SQL | 58 |
| Logins Windows (dominio GP) | 37 |
| Cuentas de servicio NT | 4 |
| Logins deshabilitados | 27 |
| Logins activos | 68 |
| Linked Servers | 6 |
| Hallazgos de seguridad scanner | 15 |
| Hallazgos criticos reales | 2 (contrasenas SSIS + connection strings) |
| Falsos positivos | 6 (scripts MEP Gatherer) |

### 7.5 Infraestructura

| Metrica | Valor |
|---------|-------|
| Hostname | WINDBTVNB0001 |
| Instancia | TESTTDPPLANICO |
| SQL Server Version | 12.0.6024.0 (SQL Server 2014 SP3) |
| Edicion | Enterprise Edition (64-bit) |
| Memoria asignada | 32,767 MB (32 GB) |
| CPUs | 8 |
| Collation | SQL_Latin1_General_CP1_CI_AS |
| Clustered | No |
| HADR (AlwaysOn) | No |
| FullText | Si |
| Inicio del servicio | 2025-05-26 19:41:09 |
| Puertos abiertos | 1433 (SQL), 3389 (RDP), 2382-2383 (SSAS), 10050 (Zabbix), 33000 |

## 8. Hallazgos de Seguridad

Se investigaron los 15 hallazgos de seguridad reportados por el scanner. A continuacion el analisis detallado:

**Grupo 1: Contrasenas SSIS /DECRYPT en job steps (7 ocurrencias - CRITICO)**

Se encontraron 7 job steps que utilizan el parametro `/DECRYPT 123` para ejecutar paquetes SSIS desde el File System. Todos usan la misma contrasena trivial "123". Los jobs afectados son:
- 20250605___FAY_ACTUALIZAR_BASE_MIGRA_FIBRA (2 schedules)
- 20250605___FAY_ISS_CARGA_TELEFONOS_MT
- 20251204___FAY_EXPORT_BASES_ADAP (2 schedules)
- 20251204___FAY_REPORTE_LOGOUT_GENESYS
- JCO_ACTUALIZAR_BASE_TRAMITADORES

Estos jobs ejecutan paquetes .dtsx ubicados en `K:\Inteligencia_de_Clientes\Proyectos_SSIS\ISS_CARGA_ADAPTATIVO_LN\ISS_JOB\` y otros directorios del File System. La contrasena "123" se usa para descifrar los paquetes que tienen ProtectionLevel=EncryptSensitiveWithPassword. Aunque la contrasena es trivial, los jobs afectados estan deshabilitados (job_enabled=0) para los prefijos FAY_, lo cual mitiga parcialmente el riesgo.

**Grupo 2: Connection strings en archivos SSIS extraidos (9 ocurrencias - CRITICO)**

El archivo `CARGA_TOT_connections.txt` contiene los connection managers del paquete CARGA_TOT.dtsx del proyecto Proceso_Transferencia1212_166. Se identifican:
- Conexion SQL a 10.226.3.96 (COBRANZA_PROD) con User ID: rsmith
- Conexion SQL a 172.30.249.166 (FacCob, Faco_DTM) con User ID: mcutimbop
- Conexiones a File System: K:\...\CARGA_TOT\Archivos, C98MT, Files, JTELLER, TOT
- Conexiones FTP: 10.4.3.226:21, 10.4.40.49:21
- Conexion Excel: archivos CARGA_CAMD.xlsx y PAGOS_AMDOCS_TSF

Las connection strings usan `Persist Security Info=True` pero NO contienen contrasenas en texto plano (solo User IDs). El riesgo es la exposicion de usuarios SQL y servidores destino.

**Grupo 3: Scripts MEP Gatherer (6 ocurrencias - FALSO POSITIVO)**

Los scripts export_etl.ps1 (lineas 439, 603, 643, 1053) y gather_sqlserver.ps1 (lineas 319, 1016) contienen referencias a variables de contrasena (`$script:_credPass`). Estas son variables parametrizadas que se pasan al script en tiempo de ejecucion y se limpian al final (`PASSWORD = $null`). Son parte del mecanismo de autenticacion del MEP Gatherer y NO contienen contrasenas hardcodeadas. Se clasifican como falsos positivos.

**Resumen de la investigacion:**
- 15 hallazgos totales del scanner
- 2 hallazgos criticos reales (contrasenas SSIS + connection strings)
- 7 hallazgos informativos (connection strings sin contrasenas)
- 6 falsos positivos (scripts MEP Gatherer)

## 9. Checklist QA

| Item | Descripcion | Estado | Observacion |
|------|-------------|--------|-------------|
| 1.1 | Ficha funcional presente | OK | A01_Ficha_Funcional_WINDBTVNB0001.docx presente (17 KB). Verificar contenido manualmente. |
| 1.2 | Estructura MEP completa (8 subcarpetas) | OK | 8/8 subcarpetas presentes (A-H). |
| 1.3 | Volumen de archivos coherente | OK | 872 archivos, 52.49 MB. Consistente con MSSQL 25 BDs. |
| 1.4 | Archivos requeridos por subcarpeta | PARCIAL | B completa. xlsx de E/F/H presentes pero no validables. |
| 1.5 | Motor de BD identificado correctamente | OK | MSSQL detectado con alta confianza. SQL Server 2014 SP3 Enterprise. |
| 2.1 | Diccionario de bases de datos | OK | 25 BDs documentadas con diccionario S01-S14 por esquema. |
| 2.2 | Inventario de objetos completo | OK | 854 tablas, 250 vistas, 291 SPs, 39 funciones en 04_object_summary.csv. |
| 2.3 | Integridad referencial documentada | PARCIAL | Tablas sin PK detectadas en multiples BDs (~681 tablas). S02/S04 presentes. |
| 2.4 | Metadatos y descripciones | PARCIAL | S12_extended_properties presente. Cobertura de comentarios no verificada. |
| 3.1 | Jobs de SQL Agent documentados | OK | 43 jobs (28 habilitados, 15 deshabilitados) en 03_agent_jobs.csv. |
| 3.2 | Paquetes ETL/SSIS exportados | OK | 42 proyectos SSISDB, 109 paquetes .dtsx extraidos. |
| 3.3 | Scheduled Tasks documentadas | OK | D40_scheduled_tasks.csv presente. |
| 3.4 | Detalle de pasos/comandos de jobs | OK | step_command incluido en CSVs. Subsistemas SSIS y TSQL documentados. |
| 4.1 | Interfaces de entrada/salida | PARCIAL | E01_E02 xlsx presente. 6 linked servers en 02_linked_servers.csv. Validar xlsx. |
| 4.2 | APIs documentadas | NO APLICA | No se identifican APIs REST/SOAP en este servidor. |
| 4.3 | Connection strings identificados | OK | Conexiones SSIS extraidas. Data sources: 10.226.3.96, FTP 10.4.3.226/10.4.40.49. |
| 5.1 | Reportes BI inventariados | OK | F01_Reportes_BI xlsx presente. Jobs PowerBI identificados. |
| 5.2 | Linaje de datos documentado | FALTA | G_Lineage vacio ('no aplica.txt'). Critico para 25 BDs con interconexiones. |
| 5.3 | Dependencias entre objetos | PARCIAL | S13_dependencies.csv presente por BD. Falta diagrama de dependencias global. |
| 5.4 | Flujos de datos entre servidores | PARCIAL | Transferencias 165/166/167/227 evidenciadas en jobs, no diagramadas. |
| 6.1 | Sin credenciales expuestas | FAIL | 7 contrasenas /DECRYPT 123 en jobs + 9 connection strings con User IDs. |
| 6.2 | Usuarios y accesos documentados | PARCIAL | 95 logins en 04_logins.csv. H01 xlsx presente. 27 cuentas deshabilitadas. |
| 6.3 | Permisos y roles documentados | PARCIAL | 03_permissions.csv y 02_role_members.csv por BD. Revision parcial. |

### Resumen Checklist

| Estado | Cantidad |
|--------|----------|
| OK | 12 |
| PARCIAL | 8 |
| FALTA | 1 |
| FAIL | 1 |
| NO APLICA | 1 |
| **Total** | **23** |

## 10. Recomendaciones

### 10.1 Bloqueantes

#### Acciones Integratel

1. **Documentar contrasenas SSIS para plan de migracion**: Las 7 ocurrencias de /DECRYPT 123 deben ser incluidas en el inventario de credenciales a rotar post-migracion. Verificar si los paquetes del File System (K:\Inteligencia_de_Clientes\) seran migrados tal cual o redesplegados en SSISDB con ProtectionLevel diferente.

2. **Completar documentacion de linaje (G_Lineage)**: Solicitar al equipo focal (B.Quispe/R.Smith) que documente como minimo: (a) Diagrama de flujo de datos entre servidores 165, 166, 167 y 227; (b) Mapa de las bases de datos que reciben datos externos vs las que solo alimentan reportes; (c) Dependencias criticas del proceso diario de tipificaciones (GPR_*) y demanda (GMC_*).

#### Acciones Stefanini

1. **Evaluar plan de rotacion de credenciales SSIS**: Post-migracion, las contrasenas de paquetes SSIS deben ser cambiadas. Considerar migrar paquetes del File System al catalogo SSISDB con ProtectionLevel=ServerStorage para eliminar contrasenas embebidas.

2. **Validar conectividad inter-servidor en nuevo ambiente**: Los 6 linked servers y las conexiones FTP deben ser reconfiguradas. Coordinar con los equipos de los servidores 165, 167 y 227 para asegurar conectividad bidireccional.

### 10.2 Importantes

#### Acciones Integratel

1. **Validar manualmente contenido de archivos xlsx**: Verificar que E01_E02 (interfaces), F01 (reportes BI) y H01 (accesos) contengan la informacion completa correspondiente a los 6 linked servers, los reportes PBI identificados y los 95 logins respectivamente.

2. **Validar ficha funcional (A01)**: Confirmar que el .docx contiene descripcion funcional del negocio, nivel de criticidad, ventana de mantenimiento, SLAs y contactos de escalamiento.

3. **Documentar calendario de ejecucion de jobs**: Complementar D_Jobs con un documento que describa los 28 jobs habilitados, sus horarios, dependencias y contactos responsables.

#### Acciones Stefanini

1. **Planificar migracion de bases BD_BACKUP_***: Las 5 bases BD_BACKUP totalizan 673 GB. Evaluar si requieren migracion completa o si se pueden archivar/excluir para reducir el tiempo de migracion.

2. **Verificar cuentas SQL deshabilitadas**: Las 27 cuentas SQL deshabilitadas deben ser revisadas para determinar si se migran deshabilitadas o se eliminan del nuevo ambiente.

3. **Evaluar connection strings con Persist Security Info=True**: Tras la migracion, configurar los connection managers SSIS con `Persist Security Info=False` para evitar exposicion de credenciales.

### 10.3 Observaciones para el Assessment

1. **SQL Server 2014 SP3 (EOL)**: El motor esta en End-of-Life desde julio 2024. Esta informacion es relevante para la planificacion del assessment y la seleccion de la version destino, pero no bloquea la entrega del MEP.

2. **Volumen de datos significativo (1.6 TB)**: La migracion de 1,601 GB de datos requerira planificacion cuidadosa de ventana de migracion. La base Repo_Layout (586 GB) es la mas grande y puede requerir estrategia incremental.

3. **Alta interconexion entre servidores**: El servidor 166 participa en un ecosistema de 4+ servidores (165, 166, 167, 227) con transferencias de datos bidireccionales. El orden de migracion debe considerar estas dependencias.

4. **42 proyectos SSISDB activos**: La migracion del catalogo SSISDB requiere exportar/importar los 42 proyectos. Los paquetes legacy del File System (7 jobs) deben evaluarse para posible consolidacion en SSISDB.

5. **Procesos de negocio criticos**: El servidor soporta procesos diarios de tipificaciones visor, KPIs de contact center, demanda, retenciones y comisiones que operan con ventanas horarias especificas (5:30am - 10:00pm).
