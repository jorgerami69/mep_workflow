# PROJECT INIT — Assessment 360° Integratel Perú
> Fuente: FPE-001-LAT Project Governance Plan v2.0 (12-03-2026)
> Actualizado: 2026-03-19 — Incluye Gatherers y MEP Master Tracker

---

## 1. Información General

| Campo | Valor |
|-------|-------|
| Cliente | Integratel Perú S.A.A. |
| Ejecutor | Informática & Tecnología Stefanini S.A. |
| Proyecto | Transformación Data — Fase 1: Assessment 360° del Ecosistema de Datos |
| Fecha inicio | 09-Marzo-2026 |
| Fecha fin | 10-Julio-2026 |
| Duración | 18 semanas / 9 sprints |
| Metodología | Agile – SCRUM |
| PM Stefanini | Jytte Mørk Coloma |
| PM Integratel | Noemi Guerra / Hernán Ruiz |
| DSM Stefanini | Luz Espinoza |

---

## 2. Objetivo

Realizar un Assessment exhaustivo (radiografía técnico-funcional completa) del ecosistema de datos de Integratel como paso previo a la modernización hacia arquitectura **Lakehouse**.

### Objetivos de Negocio
| ID | Objetivo | Descripción |
|----|----------|-------------|
| OBJ-B1 | Transparencia Operacional | Visibilidad completa de procesos de datos, riesgos y dependencias. Cobertura ≥95% |
| OBJ-B2 | Racionalización del Legado | Identificar redundancias, procesos huérfanos, lógica duplicada |
| OBJ-B3 | Gobierno de Datos | Catálogo centralizado en OpenMetadata con ownership, clasificación y lineage |
| OBJ-B4 | Transformación Predecible | NÚCLEO definido, arquitectura To-Be validada, sizing técnico, roadmap 12m |
| OBJ-B5 | Reducción de Riesgo | Eliminar incertidumbre técnica, decisiones basadas en datos reales |

### Objetivos Técnicos
| ID | Objetivo | Milestone | Métrica |
|----|----------|-----------|---------|
| OBJ-T1 | Inventariar ≥95% procesos productivos As-Is | P1.1→P1.4 | ≥95% cobertura vs total MEPs |
| OBJ-T2 | Mapear 100% dominios SID (D1-D10) con criticidad 1-5 | P1.2→P1.4 | 10/10 dominios clasificados |
| OBJ-T3 | Lineage técnico-funcional a nivel tabla/pipeline | P1.2→P1.4 | ≥90% procesos críticos (nivel 1-2) |
| OBJ-T4 | Catálogo As-Is en OpenMetadata completo | P1.1→P1.4 | 100% activos en OM |
| OBJ-T5 | Matriz Mutualización + NÚCLEO | P2.1→P2.2 | Matriz completa + NÚCLEO aprobado |
| OBJ-T6 | Arquitectura To-Be Lakehouse | P3.1→P3.3 | Blueprint aprobado en Steering |
| OBJ-T7 | Roadmap 12 meses Fase 2 | P3.3 | Roadmap aprobado en Steering |

---

## 3. Fases y Milestones

### Fases
| Fase | Sprints | Duración | Peso |
|------|---------|----------|------|
| EPIC 0 – Movilización | Sprint 0 | 4 semanas | 10% |
| Discovery 360° | Sprints 1-3 | 6 semanas | 40% |
| Mutualización | Sprints 4-5 | 4 semanas | 20% |
| To-Be + Roadmap | Sprints 6-7 | 4 semanas | 30% |

### Milestones Detallados
| Milestone | Sprint | Peso | Entregable Principal | Criterio Clave |
|-----------|--------|------|---------------------|----------------|
| P0.1 | S0 | 10% | MEPs + OM operativo + Kickoff | ≥80% MEPs aceptados, OM accesible |
| P1.1 | S1 | 10% | Inventario 360° v0.3 + Catálogo OM v0.3 | Dominios prioritarios inventariados |
| P1.2 | S2 | 10% | Inventario v0.5 + Lineage v0.3 | ≥70% activos inventariados |
| P1.3 | S2 end | 10% | Inventario v0.8 + Lineage v0.5 | Dominios tardíos incorporándose |
| P1.4 | S3 | 10% | Inventario v1.0 + Lineage v1.0 + Mapa Dependencias v1.0 | ≥95% cobertura, catálogo verificado |
| P2.1 | S4 | 10% | Mutualización v0.5 + Ranking criticidad | Redundancias documentadas |
| P2.2 | S5 | 10% | Mutualización v1.0 + Proc. Críticos v1.0 + NÚCLEO sign-off | Sign-off formal PO/SMEs |
| P3.1 | S6 | 10% | Arquitectura To-Be v0.5 + Sizing preliminar | Blueprint 7 capas definidas |
| P3.2 | S7 mid | 10% | Sizing v0.9 + Co-living v0.5 | Supuestos sizing cerrados |
| P3.3 | S7 end | 10% | Arq. To-Be v1.0 + Roadmap 12m + Backlog T1-T12 | Acta Steering firmada |

---

## 4. Alcance — Inventario de Activos (45 servidores)

### Por Gerencia
| # | Gerencia | Qty | Motores | Focal | Dirección |
|---|----------|-----|---------|-------|-----------|
| 1 | Planificación Comercial | 3 | MSSQL 2008R2, 2019 | Carlos Ramírez | Dir. B2C |
| 2 | FARECO B2C | 3 | MSSQL 2008R2, 2012, 2022 | Michael Martínez | Dir. Facturación |
| 3 | Planif. y Gestión Económica | 1 | MSSQL 2019 | V. Chávez / J. Bobadilla | Dir. B2B |
| 4 | GMT Blindaje | 1 | MSSQL 2008R2 | Diego Ambrocio | Dir. B2C |
| 5 | División Fiscal | 1 | MSSQL 2016 | Rossana Gonzales | Dir. Finanzas |
| 6 | Desarrollo Técnico y Ops | 4 | MySQL 5.7, 8.0 | Jesús Villanueva | Dir. Ops Campo |
| 7 | Postventa | 6 | MSSQL 2008R2, 2014, Apache | R. Smith / B. Quispe | Dir. B2C |
| 8 | Revenue & Cost Assurance | 2 | MSSQL 2008R2 | E. Ponce / J. Nuñez | Dir. Control Gestión |
| 9 | Comisiones y Fareco B2B | 6 | MSSQL 2014, 2017 | B. Quispe / O. Navarro | Dir. Facturación |
| 10 | Producción TI – VISOR | 3 | MySQL 5.7 | Mikel Pérez | Dir. Tecnología |
| 11 | VPF – Mediador (CDRs/EDR) | 1 | N/A (middleware) | Ernesto Garaycochea | Dir. Tecnología |
| 12 | VPF – +Simple (ALDM) | 7 | Oracle 12c/19c, PG 13/16 | Jordano Rivera | Dir. Tecnología |
| 13 | VPF – DITO | 2 | PostgreSQL 13, MongoDB 4.0 | Diego Hurtado | Dir. Tecnología |
| 14 | Dominio RED | 3 | Oracle 12c/19c, MySQL | L. Perinango / M. Avila / M. Pareja | Dir. Tecnología |
| 15 | BI/BigData | 2 | Teradata v17.20, N/A | C. Orosco / A. Leiva / B. Idrogro / J. Martínez | Dir. Datos |

**Nota:** 5 activos de Comisiones y Fareco B2B son gestionados por **VALTX** (tercero).

---

## 5. Dominios TM Forum SID

| Prio | ID | Dominio | Qty | Gerencias | Criticidad | Alcance Funcional |
|------|----|---------|-----|-----------|------------|-------------------|
| 1 | D7 | Billing & Collections | 10 | FARECO B2C, Com. B2B, Planif. Gest. Económica | Alta | Facturación, cobros, comisiones, conciliaciones |
| 2 | D2 | Product | 7 | +Simple/ALDM (ODS, OMS, ABP, CRM, MCSS, SVO, SVA) | Alta | Portafolio productos, configuración comercial, CRM |
| 3 | D3 | Customer Care | 6 | Postventa | Alta | Atención postventa, reclamos, SLAs |
| 4 | D4 | Service Assurance | 4 | Desarrollo Técnico y Ops | Media | Aseguramiento servicio, monitoreo, calidad |
| 5 | D10 | Common / IT & Data | 5 | Producción TI VISOR, BI/BigData | Media | Reporting, dashboards, herramientas TI transversales |
| 6 | D1 | Market & Sales | 4 | Planificación Comercial, GMT Blindaje | Media | Planificación comercial, campañas, blindaje churn |
| 7 | D6 | Mediation & Usage | 3 | Mediador CDRs/EDR, DITO | Crítica | Mediación tráfico, procesamiento CDR/EDR |
| 8 | D5 | Network / Resource Ops | 3 | Dominio RED | Alta (Condicional) | Red, OSS, gestión recursos de red |
| 9 | D9 | Risk / Fraud / RA | 2 | Revenue & Cost Assurance | Media | Aseguramiento ingresos, riesgo comercial |
| 10 | D8 | Finance & Tax | 1 | División Fiscal | Alta | Determinación tributaria, reporting fiscal |

---

## 6. Motores de Base de Datos

| Motor | Qty | Versiones | Uso Principal | Método Extracción MEP |
|-------|-----|-----------|---------------|----------------------|
| MSSQL | 21 | 2008R2, 2012, 2014, 2016, 2017, 2019, 2022 | Departamentales | PowerShell + sqlcmd (MEP Seed Pack v4.1) |
| MySQL | 8 | 5.7.x, 8.0.x | Ops Campo, VISOR, RED | Bash + mysql CLI |
| Oracle | 8 | 12c, 19c | ALDM (+Simple), RED | SQL*Plus / sqlcl (requiere DBA Oracle) |
| PostgreSQL | 3 | 13, 16 | ALDM (SVO, SVA), DITO | psql CLI |
| MongoDB | 1 | 4.0 | DITO | mongosh |
| Teradata | 1 | v17.20 | BI/BigData | bteq / JDBC |

---

## 7. Fuentes Principales de Datos

### a. Servidores Departamentales (27 activos)
BD SQL Server y MySQL. 60% del inventario. Mayor concentración de deuda técnica. Lógica embebida en stored procedures, jobs y queries ad-hoc.

### b. +Simple / ALDM (7 activos)
Plataforma transaccional core: ODS (Oracle 12c), OMS (Oracle 19c), ABP (Oracle 19c), CRM (Oracle 19c), MCSS (Oracle 19c), SVO (PG 13), SVA (PG 16). Fuente principal para Producto, Ventas y Facturación.

### c. Mediación CDR/EDR (1 activo – clúster 4 nodos)
Middleware que procesa 100% de CDRs/EDRs. Clúster 4 nodos IP (10.4.43.181-184). No es BD relacional.

### d. VISOR (3 activos)
Visualización y reporting operativo sobre MySQL 5.7.23.

### e. DITO (2 activos)
Transformación digital: PostgreSQL 13 + MongoDB 4.0.

### f. Dominio RED (3 activos – Condicional)
Oracle 12c/19c + MySQL. Depende del proyecto NIC. RED-LAPTOP (#45) fuera de alcance.

---

## 8. MEP (Minimum Evidence Pack)

### Estructura (8 carpetas)
| Carpeta | Contenido |
|---------|-----------|
| A_Ficha_Funcional | Identificación, contexto organizacional, cuestionario funcional |
| B_Software_Servicios | Inventario software, servicios, procesos, puertos activos |
| C_Diccionario_BD | **Componente central.** Metadata completa: tablas, columnas, índices, SPs, triggers, vistas, jobs, permisos, volumetrías |
| D_Jobs_ETL_ELT | Todos los procesos programados (BD y SO) |
| E_Interfaces_IO | Conexiones entrantes/salientes, mapa integraciones |
| F_BI_Artefactos | Reportes, dashboards, artefactos BI |
| G_Lineage_Documentacion | Documentación existente de linaje y arquitectura |
| H_Seguridad_Accesos | Modelo de accesos y seguridad |

### Ciclo de Vida
```
Requested → InProgress → Received → QA (24h) → Accepted / QA-Failed → Ingested → Used
```

### Scripts por Motor
| Motor | Herramienta | Script |
|-------|-------------|--------|
| MSSQL | PowerShell + sqlcmd | MEP Seed Pack v4.1 |
| MySQL | Bash + mysql CLI | MEP Seed Pack v4 adaptado |
| Oracle | SQL*Plus / sqlcl | Requiere DBA Oracle de Integratel |
| PostgreSQL | psql CLI | Scripts adaptados por versión |
| MongoDB | mongosh | Extracción colecciones y esquemas |
| Mediador | Manual / documental | Formatos CDR/EDR, topología, flujos |

### Carga por Focal Point
| Focal | MEPs | Motor(es) | Semana | Riesgo |
|-------|------|-----------|--------|--------|
| B. Quispe | 5 | MSSQL | W1 | **Alta carga** + coord. VALTX |
| R. Velarde | 4 | Oracle, PG | W1 | Alta carga, 2 motores |
| Jesús Villanueva | 4 | MySQL 5.7/8.0 | W2 | Media |
| Mikel Pérez | 4 | MySQL | W2 | Versión TBC |
| R. Smith | 4 | MSSQL, Apache | W1 | Apache manual |
| O. Navarro | 3 | MSSQL | W1 | VALTX |
| Michael Martínez | 3 | MSSQL | W1 | Baja |
| Carlos Ramírez | 3 | MSSQL | W2 | Baja |
| J. Rivera | 3 | Oracle 12c/19c | W1 | Requiere DBA |
| Rossana Gonzales | 1 | MSSQL | W3 (cond.) | **Condicional** |
| L. Perinango | 1 | Oracle, MySQL | W3 (cond.) | **Condicional** (NIC) |

---

## 9. OpenMetadata

| Componente | Detalle |
|------------|---------|
| Hosting | AWS (Stefanini paga Fase 1) |
| Acceso | URL + usuario/contraseña + allowlisting CIDRs |
| CIDRs | 200.37.220.48/29, 200.60.150.40/29, 177.8.156.53/32 |
| VPN Stefanini | Habilitada a nivel de red |
| Conectores | MSSQL, MySQL, Oracle, PostgreSQL, MongoDB |
| Tags | TM Forum SID (D1-D10), criticidad (1-5), sensibilidad, ownership, estado |

### Usuarios Integratel (10)
| Nombre | Rol OM |
|--------|--------|
| Noemi Guerra | Administrador / Validador principal |
| Hernan Ruiz | Validador |
| Javier Dietz | Validador |
| Ludwing Ortiz | Validador |
| Harry Isla | Consulta |
| Wilfred Espinoza | Consulta |
| Juan Garcia | Consulta |
| Gabriel Flores | Consulta |
| Christian Lobaton | Consulta |
| Anthony Talavera | Consulta |

---

## 10. Equipo Stefanini

### Nivel Estratégico (a demanda)
- Romina Pelosi — Digital Business Manager
- Esteban De La Torre — Preventa Líder
- Camilo Góngora — Director Delivery
- Jenny Arias — Portafolio Manager

### Nivel Táctico
- Fabio De Oliveira — Preventa Arquitecto Datos
- Luz Espinoza — Delivery Service Manager
- Jytte Mørk — PM Senior
- Fabio Iregui — SME_1 Telco (Pod 1: D1, D3, D7, D8, D9 = 23 servidores)
- Jacqueline Rodríguez — SME_2 Telco (Pod 2: D2, D4, D5, D6, D10 = 22 servidores)

### Nivel Operativo (100%)
- Jorge Ramirez — Data Architect
- Cristian Quiroga — Sr Data Engineer #1
- Hernando Rojas — Sr Data Engineer #2
- Jeisson Lombana — BI Engineer Senior
- Kevin Huancahuasi — BI Engineer Senior
- Adrián Aguirre — BI Engineer Mid
- Fernando Callasaca — BI Engineer Mid
- Simón Padrón — AI/Accelerator Specialist
- Felix Fernandez — Mid Data Engineer
- Yaneth Castillo — Mid Data Engineer
- Elvis Vigilio — Governance Specialist

---

## 11. Equipo Integratel

### Sponsors
- Wilfredo Espinoza Guillen
- Javier Omar Dietz Matute

### PM / SPOC
- Noemi Guerra Jiménez (PM + SPOC + Admin OM)
- Hernán Ruiz Angulo (PM + Validador OM)

### Focales por Dominio (24 personas)
Distribuidos en las 15 gerencias. Ver sección 4 para detalle.

---

## 12. Gobernanza

### Modelo de 3 Capas
| Capa | Actores | Alcance | SLA |
|------|---------|---------|-----|
| Operativa | Equipo técnico + Focales + SPOC | Ejecución diaria, issues N1 | 24-48h |
| Táctica | PMs + SPOC + DSM | Sprints, milestones, bloqueos N2 | 48-72h |
| Estratégica | Sponsors + DSM + PMs | Cambios alcance, gates, N3 | 5 días hábiles |

### Artefactos de Gobierno
- **RAID Log** — Riesgos, Supuestos, Issues, Dependencias (continua)
- **Decision Log** — Decisiones con contexto y justificación
- **MEP Tracker** — Estado MEPs por activo/dominio (diario en EPIC 0)
- **Sprint Backlog** — Azure DevOps (User Stories, Tasks, Burndown)
- **Actas de Workshops** — Dentro de 24h post-workshop
- **Actas de Aceptación** — Sign-off por milestone
- **Change Log** — Change Requests
- **Status Report** — Quincenal con semáforo RAG

### Escalamiento
- N1: Equipo técnico → resolución directa (24-48h)
- N2: PMs ambas partes (48-72h)
- N3: Sponsors / Steering ejecutivo (5 días)

---

## 13. Alcance Condicional y Restricciones

### Condicional
| Elemento | Condición | Plan Alternativo |
|----------|-----------|------------------|
| Dominio RED (D5) | Definición proyecto NIC + MEPs de equipo RED | Documentar como "pendiente", incorporar en v1.0 si llega en Mutualización |
| División Fiscal (D8) | Focal disponible desde Semana 3 | Integrar como "dominio tardío" |
| Activos VALTX (5 serv.) | Coordinación Integratel-VALTX | Documentar como "pendiente tercero", escalar a PM |

### Fuera de Alcance
- Implementación/migración de plataforma To-Be (Fase 2)
- Ejecución de pipelines en producción
- Extracción de datos productivos sensibles (solo metadatos)
- Sizing definitivo (solo estimaciones con supuestos)
- Implementación de gobierno de datos operativo
- RED-LAPTOP (#45)
- Servidores fuera del inventario de 45

### Supuestos Clave
- S01: 15 focales confirmados y disponibles desde Semana 1
- S02: Jefes/directores participan en validación MEP y ranking criticidad
- S03: 10 dominios ETA Mes 1 disponibles; D8 (Fiscal) ETA Mes 2
- S04: Existe documentación preliminar del ecosistema
- S05: Infraestructura Huawei on-premises con capacidad suficiente

### Restricciones
- R01: Recursos Stefanini 100% / 0% por mes
- R02: No se implementa nada durante Assessment
- R03: Duración máxima 4.5 meses (extensiones requieren CCB)
- R04: MEPs deben completarse antes de Discovery profundo (Sprint 3)

---

## 14. Versionamiento Progresivo de Entregables

```
v0.3 → Dominios prioritarios (D7, D3, D2) con MEPs completos
v0.5 → ~41 activos (excluyendo D8 y D5 si condicionales no activados)
v0.8 → Incorporación dominios tardíos (D8 Fiscal)
v1.0 → Versión final completa (excepciones documentadas)
```

---

## 15. Riesgos Principales

| ID | Riesgo | Mitigación |
|----|--------|------------|
| RSK-001 | Heterogeneidad de 8 familias de motores en 14 versiones | MEP Seed Pack pre-validado, scripts adaptados, SMEs por motor |
| RSK-002 | Dependencia de VALTX para 5 servidores D7 | Coordinación vía SPOC, escalación a PM, modelo late-binding |
| RSK-003 | Dominio RED condicional (proyecto NIC) | Documentar como excepción, incorporar si evidencia llega |
| RSK-004 | Carga alta en focales (B. Quispe 5, R. Velarde 4) | Monitoreo diario, soporte técnico Stefanini |

---

## 16. SAI (Stefanini Artificial Intelligence)

Pipeline de análisis asistido con LLMs con enfoque bottom-up progresivo:
1. **Parsing & Fingerprinting** — Análisis automatizado de SQL, stored procedures, jobs
2. **Clasificación** — Categorización de artefactos por dominio y criticidad
3. **Lineage** — Detección automática de dependencias entre tablas/pipelines
4. **Enriquecimiento** — Sugerencias de descripción semántica y reglas de negocio
5. **Integración OM** — Resultados publicados en OpenMetadata

Motores soportados: MSSQL, MySQL, Oracle, PostgreSQL (MongoDB y Teradata con capacidades limitadas).

---

## 17. Gestión de Cambios

- Todo cambio de alcance requiere **Change Request (CR)** formal
- Evaluación de impacto en: alcance, cronograma, costo, calidad, riesgos
- Niveles de aprobación según impacto (PM → Steering → CCB)
- SLA de evaluación de CR: 5 días hábiles
- Change Log mantenido en SharePoint

---

## 18. Criterios de Aceptación

- Cada milestone tiene **Definition of Done (DoD)** explícito
- Aceptación basada en evidencia verificable en OM + documentación formal
- Período de revisión: **10 días hábiles** tras entrega formal
- Regla de aceptación tácita: si no hay observaciones en 10 días hábiles, el milestone se considera aceptado
- Máximo **2 ciclos de observaciones** por milestone
- Rechazo requiere justificación por escrito con criterios específicos no cumplidos

---

## 19. Gatherers — Scripts de Extracción de Metadatos

> Ubicación: `Gatherers/`
> Estado actual (2026-03-19): Scripts casi listos, ya se recibe data extraída de los focales.

### 19.1 MEP Packs por Motor de BD

#### a. MSSQL + Oracle Pack (v5.6)
**Directorio:** `MEP_Pack_Integratel_MSSQL_ORACLE_v5.6/`

**Scripts principales:**
- `C_Diccionario_BD/scripts/gather_sqlserver.ps1` (1248 líneas, PowerShell)
  - Auto-detecta versión SQL Server (2008R2 a 2022) y adapta queries
  - 14 categorías de metadatos por schema: tablas, columnas, vistas, SPs, triggers, functions, indexes, statistics, roles, users, permisos, full-text, replication, SQL Agent
  - Soporta Windows Auth y SQL Server Auth
  - Output: CSV/TSV jerárquico por Database → Schema
- `C_Diccionario_BD/scripts/export_etl.ps1` (1187 líneas, PowerShell)
  - Extracción de paquetes SSIS en 6 fases: SSISDB catalog, msdb legacy, SQL Agent jobs, file system scan, post-processing, sanitización
  - Extrae SQL embebido, conexiones, dataflows de .dtsx
  - Redacta passwords/tokens automáticamente
- `C_Diccionario_BD/oracle/gather_oracle_19c.sh` (~900 líneas, Bash)
  - Oracle 12c/19c vía SQL*Plus/sqlcl
  - Schemas, PL/SQL, DBMS_SCHEDULER, DB links, tablespaces

**Gerencias cubiertas (MSSQL):**
| Gerencia | MEPs (servidores) |
|----------|-------------------|
| Gerencia_Planificacion_Comercial | WINDBPVLI0012, GPPESPLCLI1030, GPPESPLCLI1235 |
| Gerencia_de_FARECO_B2C | WINDBPVLI0017, GPPESVLCLI1376, GPPESPLCLI1005 |
| Gerencia_de_Planificacion_y_Gestion_Economica | WINDBPVLI0005 |
| Gerencia_GMT_Blindaje | GPPESVLCLI2248 |
| Director_Division_de_Fiscal | GPPESVLCMO1514 |
| Gerencia_de_Postventa | WINDBDVNB0001, WINDBTVNB0001, WINDBPVNB0002, GPPESVLCLI2249, GPPESVLCLI2251, WINDBPVMO0001 |
| Gerencia_de_Comisiones_y_Fareco_B2B | WINDBPVNB0001, TGPESVLCLI1610, TGPESVLCLI1385, TGPESVLCLI1384, TGPESVLCLI1088, TGPESVLCLI1060 |
| Gerencia_de_Revenue_Cost_Assurance | GPPESVLCLI2250 |
| Gerencia_de_Produccion_TI_VISOR | GPPESVLCOC0023 |

**Gerencias cubiertas (Oracle):**
| Gerencia | MEPs |
|----------|------|
| Gerencia_de_VPF_+Simple_(ALDM) | ODS, OMS, ABP, CRM, MCSS |
| Gerencia-Dominio_RED | MEP_43_ORACLE, MEP_44_ORACLE |

#### b. MySQL Pack (v5.8.2)
**Directorio:** `MEP_Pack_Integratel_MYSQL_v5.8.2/`

**Scripts principales:**
- `gather_mysql.ps1` (336 líneas, PowerShell) — Cross-platform, auto-localiza binarios mysql/mysqldump
- `mep_mysql_gather.sh` (279 líneas, Bash) — Versión pura Bash sin dependencia PowerShell

**Metadata extraída (6 CSVs por BD):** tablas, columnas, constraints, routines, triggers, views + DDL vía mysqldump --no-data

**Gerencias cubiertas:**
| Gerencia | MEPs |
|----------|------|
| Gerencia_de_Desarrollo_Tecnico_y_Operaciones | WINSRPVNB0005, MF-PLAT-COC-01, mf-plat-coc-02, LV-COC-LIN-004 |
| Gerencia_de_Produccion_TI_VISOR | GPPESVLCOC0021, GPPESVLCOC0022 |
| Gerencia-Dominio_RED | MEP_43_MYSQL |

#### c. PostgreSQL + Teradata Pack (v5.3)
**Directorio:** `MEP_Pack_Integratel_PG_TD_v5.3/`

**Scripts principales:**
- `gather_postgres.sh` (897 líneas, Bash) — Compatible PG v10-v16
  - **41 CSVs de salida**, el más completo de todos los gatherers
  - Diccionario completo + CDC readiness + materialized views + FDW + particiones + pg_cron
  - Sección especial CDC: WAL settings, replication slots, publications, tables sin PK (CDC blocker)
  - Clasificación de tasa de cambio: VERY_HIGH_CHANGE, HIGH_CHANGE, etc.
- `gather_teradata_v17.sql` — Queries SQL para Teradata v17

**Gerencias cubiertas:**
| Gerencia | MEPs |
|----------|------|
| Gerencia_de_VPF_+Simple_(ALDM) | SVA (PG 16), SVO (PG 13) |
| Gerencia_de_VPF_DITO | PostgreSQL v13 |
| Teradata_(Azure) | Teradata V17 Azure |

#### d. Laptop Pack (v1)
**Directorio:** `MEP_Pack_Integratel_Laptop_v1/`
- Minimal, marcado como "No Aplica" en C_Diccionario_BD
- Para el activo RED-LAPTOP (#45), fuera de alcance estándar

### 19.2 Gatherers Especiales

#### a. Cloudera NiFi & Hive
**Directorio:** `Cloudera NiFi & Hive/`
- `dump_nifi_flows.py` (605 líneas, Python 3) — REST API client para NiFi 1.x
  - Autenticación JWT, exporta recursivamente: process groups, processors, connections, templates, controller services, variable registry
  - Output: manifest.json + index.md + jerarquía JSON
- `export_hive_ddl.sh` (24 líneas, Bash) — CREATE TABLE de todas las tablas Hive

#### b. Mediador CDRs/EDR
**Directorio:** `Gerencia_de_VPF_Mediador_CDRs_EDR/`
- No es BD relacional — recolección documental
- Placeholder con Excel de interfaces (`E01_E02_Interfaces_Mediador.xlsx`)
- Secciones marcadas "No aplica.txt"

#### c. Revenue & Cost Assurance (JAZZIT Oracle)
**Directorio:** `MEP_Gerencia_de_Revenue_Cost Assurance_Riesgo_Comercial_JAZZIT/`
- `gather_oracle_19c.sh` para instancia JAZZIT (Oracle)
- Complementado con Excel de BI reports, interfaces, accesos

#### d. GPPESVLCLI225 Standalone
**Directorio:** `MEP_GPPESVLCLI225_C_Diccionario_BD/`
- Pack standalone MSSQL con `gather_sqlserver.ps1` + `export_etl.ps1`
- Incluye README con instrucciones de ejecución

### 19.3 Estructura de Carpetas por Servidor
Cada MEP por servidor replica la estructura estándar de 8 carpetas:
```
MEP_Pack_<Motor>/
  └── <Gerencia>/
      └── MEP_<Servidor>/
          ├── A_Ficha_Funcional/          → Cuestionario funcional (Excel)
          ├── B_Software_Servicios/       → Inventario software/servicios
          ├── C_Diccionario_BD/           → **SCRIPTS AQUÍ** (gather_*.ps1|.sh)
          │   ├── scripts/ (MSSQL)
          │   ├── oracle/ (Oracle)
          │   └── (raíz para MySQL/PG)
          ├── D_Jobs_ETL_ELT/            → export_etl.ps1 (SSIS)
          ├── E_Interfaces_IO/            → Conexiones I/O (Excel)
          ├── F_BI_Artefactos/            → Reportes/dashboards (Excel)
          ├── G_Lineage_Documentacion/    → Documentación existente
          └── H_Seguridad_Accesos/        → Modelo accesos (Excel)
```

### 19.4 Resumen de Capacidades por Gatherer

| Capacidad | MSSQL | MySQL | PostgreSQL | Oracle | NiFi | Hive | Teradata |
|-----------|-------|-------|-----------|--------|------|------|----------|
| Schemas/Tables/Columns | X | X | X | X | — | X | X |
| Constraints (PK/FK) | X | X | X | X | — | — | X |
| Indexes | X | X | X | X | — | — | X |
| Views | X | X | X | X | — | X | X |
| Stored Procedures | X | X | X | X | — | — | — |
| Triggers | X | X | X | X | — | — | — |
| Functions | X | X | X | X | — | — | — |
| Jobs/Schedulers | X (SQL Agent) | X (Events) | X (pg_cron) | X (DBMS_SCHEDULER) | — | — | — |
| ETL/SSIS Packages | X | — | — | — | — | — | — |
| NiFi Flows | — | — | — | — | X | — | — |
| CDC/Replication | — | — | X (completo) | — | — | — | — |
| Security/Grants | X | X | X | X | — | — | — |
| Statistics/Sizes | X | X | X | X | — | — | — |
| DDL Export | X | X (mysqldump) | X (pg_dump) | X | — | X | — |

### 19.5 Formatos de Output
| Formato | Uso |
|---------|-----|
| CSV/TSV | Tablas de metadatos (todos los motores) |
| JSON | NiFi flows, manifests, controller services |
| XML (.dtsx) | Paquetes SSIS |
| SQL | DDL statements |
| XLSX | Documentación manual (interfaces, BI, accesos) |
| LOG | Ejecución con row counts, timing, errores |

---

## 20. MEP Master Tracker

> Archivo: `MEP_00_Master_Tracker 1.xlsx` (hoja: "MEP Tracker", v3)

### 20.1 Estructura del Tracker
**Columnas:** Nro | MEP Folder | Servidor | IP | Gerencia | Focal | A01 Ficha | B Servicios | C Orquestador | D ETL/Jobs | E Interfaces | F BI | H Accesos | Status General | Notas

Las columnas A-H permiten tracking granular del estado de cada subcarpeta MEP por servidor.

### 20.2 Inventario de MEPs (36 registros)

| Nro | MEP Folder | Servidor | IP | Gerencia | Focal |
|-----|-----------|----------|-----|----------|-------|
| 1 | MEP_01_WINDBPVLI0012 | WINDBPVLI0012 | 10.226.3.100 | Planificacion B2C | Carlos Ramirez |
| 2 | MEP_02_GPPESPLCLI1030 | GPPESPLCLI1030 | 10.226.3.137 | Planificacion B2C | Carlos Ramirez |
| 3 | MEP_03_GPPESPLCLI1235 | GPPESPLCLI1235 | 10.226.3.218 | Planificacion B2C | Carlos Ramirez |
| 4 | MEP_04_WINDBPVLI0017 | WINDBPVLI0017 | 10.226.3.96 | FARECO B2C | Michael Martinez |
| 5 | MEP_05_GPPESVLCLI1376 | GPPESVLCLI1376 | 10.226.5.84 | FARECO B2C | Michael Martinez |
| 6 | MEP_06_GPPESPLCLI1005 | GPPESPLCLI1005 | 10.226.3.179 | FARECO B2C | Michael Martinez |
| 7 | MEP_07_WINDBPVLI0005 | WINDBPVLI0005 | 172.29.24.2 | Jef. Gestión Ingresos y Planta | Vladimir Chavez |
| 8 | MEP_08_GPPESVLCLI2248 | GPPESVLCLI2248 | 10.4.40.226 | Postpago | Diego Ambrocio |
| 9 | MEP_09_GPPESVLCMO1514 | GPPESVLCMO1514 | 10.4.40.87 | (sin asignar) | Rossana Gonzales |
| 10 | MEP_10_WINSRPVNB0005 | WINSRPVNB0005 | 172.30.229.2 | Desarrollo y Ops Técnicas | Jesus Villanueva |
| 11 | MEP_11_WINDBDVNB0001 | WINDBDVNB0001 | 172.30.249.165 | Atención | B. Quispe / R. Smith |
| 12 | MEP_12_WINDBTVNB0001 | WINDBTVNB0001 | 172.30.249.166 | Atención | B. Quispe / R. Smith |
| 13 | MEP_13_WINDBPVNB0002 | WINDBPVNB0002 | 172.30.249.167 | Atención | B. Quispe / R. Smith |
| 14 | MEP_14_GPPESVLCLI2249 | GPPESVLCLI2249 | 10.4.40.227 | Atención | B. Quispe / R. Smith |
| 15 | MEP_15_GPPESVLCLI2251 | GPPESVLCLI2251 | 10.4.40.229 | Atención | B. Quispe / R. Smith |
| 16 | MEP_16_GPPESVLCOC0024 | GPPESVLCOC0024 | 172.30.249.38 | Atención | B. Quispe / R. Smith |
| 17 | MEP_17_WINDBPVMO0001 | WINDBPVMO0001 | 10.4.77.23 | Atención | B. Quispe / R. Smith |
| 18 | MEP_18_GPPESVLCLI2250 | GPPESVLCLI2250 | 10.4.40.228 | Riesgos y Aseguramiento | Jhonatan Marcelo |
| 19 | MEP_19_TGPESVLCLI1159 | TGPESVLCLI1159 | 10.4.50.252 | Inspección y Prevención Fraude | Paul Ruiz |
| 20 | MEP_20_WINDBPVNB0001 | WINDBPVNB0001 | 172.30.251.85 | Reclamos y Comisiones | B. Quispe / O. Navarro |
| 21 | MEP_21_TGPESVLCLI1610 | TGPESVLCLI1610 | 172.13.35.78 | Reclamos y Comisiones | B. Quispe / O. Navarro |
| 22 | MEP_22_TGPESVLCLI1385 | TGPESVLCLI1385 | 172.13.35.65 | Reclamos y Comisiones | B. Quispe / O. Navarro |
| 23 | MEP_23_Por identificar | Por identificar | 172.13.33.162 | Reclamos y Comisiones | Oscar Navarro |
| 24 | MEP_24_TGPESVLCLI1088 | TGPESVLCLI1088 | 10.4.50.25 | Reclamos y Comisiones | Oscar Navarro |
| 25 | MEP_25_TGPESVLCLI1060 | TGPESVLCLI1060 | 10.4.50.106 | Reclamos y Comisiones | Oscar Navarro |
| 26 | MEP_26_GPPESVLCOC0021 | GPPESVLCOC0021 | 172.30.249.11 | Producción TI | Junior Torres |
| 27 | MEP_27_GPPESVLCOC0022 | GPPESVLCOC0022 | 172.30.249.12 | Producción TI | Junior Torres |
| 28 | MEP_28_GPPESVLCOC0023 | GPPESVLCOC0023 | 172.30.249.13 | Producción TI | Junior Torres |
| 29 | MEP_29_WINSRPVNB0003 | WINSRPVNB0003 | 172.30.249.14 | Producción TI | Junior Torres |
| 30 | MEP_30_GPPESPLCMO1027 | GPPESPLCMO1027 | 10.226.1.40 | **Por identificar** | **Por identificar** |
| 31 | MEP_31_GPPESVLCLI2252 | GPPESVLCLI2252 | 10.4.40.231 | **Por identificar** | **Por identificar** |
| 32 | MEP_32_GPPESVLCLI2259 | GPPESVLCLI2259 | 10.4.40.239 | **Por identificar** | **Por identificar** |
| 34 | MEP_34_Por identificar | Por identificar | Por identificar | Mediación (CDR/EDR) | Ernesto Garaycochea |
| 35 | MEP_35_Por identificar | Por identificar | Multi-IP (ALDM) | +Simple (ALDM) | Jordano Rivera (Ventas) |
| 36 | MEP_36_Por identificar | Por identificar | Multi-IP (ALDM) | +Simple (ALDM) | Raul Velarde (Facturación) |

**Nota:** Falta el MEP #33 en el tracker. MEPs #30-32 tienen gerencia y focal "Por identificar". MEPs #34-36 tienen servidor "Por identificar" (Mediador y ALDM son multi-componente).

### 20.3 Distribución por Gerencia (desde Tracker)
| Gerencia | Qty MEPs | Focales |
|----------|----------|---------|
| Planificación B2C | 3 | Carlos Ramirez |
| FARECO B2C | 3 | Michael Martinez |
| Jef. Gestión Ingresos y Planta | 1 | Vladimir Chavez |
| Postpago | 1 | Diego Ambrocio |
| (Fiscal - sin gerencia) | 1 | Rossana Gonzales |
| Desarrollo y Ops Técnicas | 1 | Jesus Villanueva |
| Atención | 7 | B. Quispe / R. Smith |
| Riesgos y Aseguramiento | 1 | Jhonatan Marcelo |
| Inspección y Prevención Fraude | 1 | Paul Ruiz |
| Reclamos y Comisiones | 6 | B. Quispe / O. Navarro |
| Producción TI | 4 | Junior Torres |
| Por identificar | 3 | Por identificar |
| Mediación (CDR/EDR) | 1 | Ernesto Garaycochea |
| +Simple (ALDM) | 2 | Jordano Rivera / Raul Velarde |

### 20.4 Observaciones del Tracker vs Governance Plan
- El Tracker tiene **36 MEPs** vs **45 activos** en el Governance Plan — diferencia de 9 activos aún no registrados en el tracker (probablemente MySQL VISOR, dominio RED, Teradata/Cloudera, DITO)
- Nombres de gerencias difieren ligeramente entre Tracker y Governance (ej: "Atención" vs "Postventa", "Reclamos y Comisiones" vs "Comisiones y Fareco B2B")
- Focales en Tracker incluyen nombres nuevos no listados en Governance: Junior Torres, Jhonatan Marcelo, Paul Ruiz
- MEP #33 ausente (posible error de numeración o activo excluido)
- IPs de ALDM (#35-36) muestran 3 ambientes: No Prod (10.91.80.93), Prod (10.4.56.81), Certi (172.28.248.59)
