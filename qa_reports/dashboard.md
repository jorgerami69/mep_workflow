# MEP QA Dashboard -- Gerencia de Postventa (D3 Customer Care)
## Integratel Assessment 360

**Generado:** 2026-03-20 | **MEPs analizados:** 5/5 | **Cobertura Postventa:** 100%
**Dominio SID:** D3 -- Customer Care | **Focales:** B. Quispe / R. Smith | **Score promedio: 60.5/100**

---

## Estado General

| Grado | Count | % | MEPs |
|-------|-------|---|------|
| A (90+) | 0 | 0% | -- |
| B (75-89) | 1 | 20% | WINDBDVNB0001 (75) |
| C (60-74) | 3 | 60% | WINDBPVNB0002 (66), WINDBTVNB0001 (62), GPPESVLCLI2249 (58.5) |
| D (40-59) | 1 | 20% | GPPESVLCLI2251 (41) |
| F (<40) | 0 | 0% | -- |

---

## Resumen por MEP

| # | MEP | Motor | IP | Score | Grado | FAIL | WARN | Veredicto |
|---|-----|-------|----|-------|-------|------|------|-----------|
| 14 | GPPESVLCLI2249 | MSSQL 2008 R2 | 10.4.40.227 | 58.5 | C | 3 | 6 | Condicional |
| 15 | GPPESVLCLI2251 | MSSQL 2008 R2 | 10.4.40.229 | 41.0 | D | 3 | 5 | Rechazado |
| 11 | WINDBDVNB0001 | MSSQL 2014 SP3 | 172.30.249.165 | 75.0 | B | 3 | 5 | Aprobado con obs. |
| 13 | WINDBPVNB0002 | MSSQL 2014 SP3 | 172.30.249.167 | 66.0 | C | 4 | 6 | Aprobado con obs. |
| 12 | WINDBTVNB0001 | MSSQL 2014 SP3 | 172.30.249.166 | 62.0 | C | 3 | 7 | Aprobado con obs. |

---

## Issues Mas Comunes

| Issue | Afecta | Severidad | Accion |
|-------|--------|-----------|--------|
| G_Lineage vacia | 5/5 MEPs | FAIL | Focal debe documentar lineage: dependencias entre BDs, linked servers, flujos SSIS |
| Credenciales SSIS /DECRYPT 123 | 3/5 MEPs | FAIL | Stefanini debe redactar. Integratel debe rotar passwords afectados |
| H_Seguridad dice "No aplica" | 3/5 MEPs | FAIL | Pre-llenar H con datos de logins/roles ya extraidos en C |
| E_Interfaces incompletas | 3/5 MEPs | WARN | Linked servers y conexiones SSIS no reflejados en E |
| Extraccion fallida (GPPESVLCLI2251) | 1/5 MEPs | FAIL | Stefanini: fix bug sqlcmd -s. Integratel: re-ejecutar script corregido |
| Passwords hardcoded en SPs | 1/5 MEPs | FAIL | WINDBPVNB0002: 4 passwords en stored procedures. Escalar a SPOC |
| Tablas sin PK (>89%) | 2/5 MEPs | INFO | Relevante para estrategia CDC en Fase 2 |

---

## Hallazgos de Seguridad (cross-MEP)

| MEP | Tipo | Detalle | Severidad |
|-----|------|---------|-----------|
| WINDBPVNB0002 | Passwords en SPs | 3 credenciales en texto plano en stored procedures + 1 SFTP en SSIS | Critica |
| WINDBTVNB0001 | SSIS /DECRYPT 123 | Password debil en 7 agent job steps + User IDs en connection strings | Alta |
| GPPESVLCLI2249 | SSIS /DECRYPT 123 | Password debil en 8 agent job steps | Alta |
| WINDBDVNB0001 | Variables en scripts | 7 pattern matches -- todos falsos positivos (variables del gatherer) | Ninguna |
| GPPESVLCLI2251 | -- | 0 hallazgos (extraccion fallida, data limitada) | -- |

---

## Escala de Infraestructura (5 servidores Postventa)

| Metrica | GPPESVLCLI2249 | GPPESVLCLI2251 | WINDBDVNB0001 | WINDBPVNB0002 | WINDBTVNB0001 | Total |
|---------|:-:|:-:|:-:|:-:|:-:|:-:|
| Bases de datos | 22 | 10* | 16 | 32 | 25 | 105 |
| Tablas | 1,965 | ?* | 3,010 | 3,931 | -- | 9,000+ |
| Stored Procedures | 906 | ?* | 207 | 1,138 | -- | 2,200+ |
| Agent Jobs | 100 | ?* | 43 | 177 | 42 | 362+ |
| SSIS Packages | 11 | 108* | 46 | 276 | 109 | 550 |
| Linked Servers | 6 | 3 | 4 | 8 | 6 | 27 |
| Storage | 195 GB | ?* | 2.7 TB | 8 TB | 1.6 TB | ~12.5 TB |

*GPPESVLCLI2251: datos no extraidos por bug sqlcmd*

---

## Acciones Requeridas por Prioridad

### P1 -- Bloqueantes

#### Acciones Integratel (Focal / SPOC)
1. **Todos (5/5):** Completar G_Lineage -- documentar dependencias entre BDs, linked servers, flujos SSIS
2. **3/5 MEPs:** Completar H_Seguridad con datos de logins/roles existentes (usar datos de C como referencia)
3. **GPPESVLCLI2251:** Re-ejecutar gather_sqlserver.ps1 con el script corregido que entregue Stefanini
4. **WINDBPVNB0002:** Confirmar si credenciales detectadas en SPs son vigentes. Escalar a SPOC para rotacion

#### Acciones Stefanini
1. **GPPESVLCLI2251:** Entregar script gather_sqlserver.ps1 corregido (fix parametro -s para SQL 2008 R2)
2. **3/5 MEPs:** Redactar credenciales SSIS (/DECRYPT 123) en los reportes y findings
3. **WINDBPVNB0002:** Escalar hallazgo de passwords hardcoded al SPOC y registrar en RAID log
4. **Todos:** Validar correcciones de G, H, E cuando los focales las entreguen

### P2 -- Importantes (antes de ingesta OM)

#### Acciones Integratel
1. **3/5 MEPs:** Completar E_Interfaces con linked servers y conexiones SSIS
2. **2/5 MEPs:** Documentar F_BI -- reportes Power BI / SSRS existentes

#### Acciones Stefanini
1. **4/5 MEPs aprobados:** Preparar ingesta OM (WINDBDVNB0001, WINDBPVNB0002, WINDBTVNB0001, GPPESVLCLI2249)
2. **GPPESVLCLI2249:** Re-ejecutar export_etl.ps1 con permisos elevados (Fase 4 fallo)

### P3 -- Observaciones para el Assessment

1. SQL Server 2008 R2 en 2 servidores y SQL Server 2014 en 3 servidores -- contexto para priorizacion de migracion
2. GPPESVLCLI2249: 89.8% tablas sin PK. WINDBPVNB0002: 97.3% tablas sin PK -- relevante para estrategia CDC en Fase 2
3. WINDBPVNB0002: 8 TB en 32 BDs con Teradata linked -- servidor hub de integracion critico para el NUCLEO
4. WINDBTVNB0001: SSIS con tasa de fallo recurrente en ETL_Base_04_Averias -- indicador de deuda tecnica
5. GPPESVLCLI2251: 10 BDs descubiertas (BD_CONTROL, BD_D2D, PE_ModelosFranquicias, PE_Ventas_Presencial, etc.) -- nombres sugieren modelos de franquicias y ventas presencial

---

## Conclusion

La Gerencia de Postventa (D3) presenta 105 bases de datos, ~12.5 TB de datos, 550 paquetes SSIS y 362 Agent Jobs en 5 servidores. Con un score promedio de 60.5/100, los resultados muestran mejora respecto a corridas anteriores gracias a un analisis de seguridad mas riguroso que distingue falsos positivos de credenciales reales.

**4 MEPs aprobados con observaciones** (WINDBDVNB0001, WINDBPVNB0002, WINDBTVNB0001, GPPESVLCLI2249) pueden avanzar a ingesta en OM tras completar secciones G y H. **1 MEP rechazado** (GPPESVLCLI2251) requiere re-extraccion completa tras fix del bug sqlcmd.

El patron sistematico persiste: la extraccion tecnica (C) funciona bien en 4/5 servidores, pero las secciones de gobierno (G lineage, H seguridad, E interfaces) estan sistematicamente vacias. Se recomienda una sesion de trabajo dedicada con los focales B. Quispe y R. Smith para cerrar estas secciones usando la data ya disponible en C como referencia.

---

*Dashboard generado por MEP QA Workflow -- Assessment 360 Integratel Peru*
*Scanner v1.0.0 + Evaluacion razonada Claude | Template estandarizado v4 (definitivo)*
*2026-03-20*
