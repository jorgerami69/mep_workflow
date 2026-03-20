CREATE TABLE [dbo].[T_ADMIN_BASE_DATOS] (
    [AD_SERVIDOR_NOMBRE] varchar NOT NULL,
    [AD_SERVIDOR_IP] varchar NOT NULL,
    [AD_BD_NOMBRE] varchar NOT NULL,
    [AD_BD_TIPO] varchar NOT NULL,
    [AD_BD_UNIDAD_DISCO] varchar NOT NULL,
    [AD_BD_TAMANIO_EN_DISCO_EN_GB] numeric NOT NULL,
    [AD_BD_LIMITE_CRECIMIENTO] varchar NOT NULL,
    [AD_BD_MAXIMO_TAMANIO_EN_DISCO_EN_GB] numeric NOT NULL,
    [AD_BD_ESPACIO_PARA_CRECER] numeric NOT NULL,
    [AD_BD_CRECIMIENTO] numeric NOT NULL,
    [AD_BD_TIPO_CRECIMIENTO] varchar NOT NULL,
    [AD_BD_ESTADO] varchar NOT NULL,
    [AD_BD_FECHA_CREACION] datetime NOT NULL,
    [AD_BD_FECHA_AUTOMATICO] datetime NOT NULL
);

CREATE TABLE [dbo].[T_ADMIN_BASE_DATOS_ANTERIOR] (
    [AD_SERVIDOR_NOMBRE] varchar NOT NULL,
    [AD_SERVIDOR_IP] varchar NOT NULL,
    [AD_BD_NOMBRE] varchar NOT NULL,
    [AD_BD_TIPO] varchar NOT NULL,
    [AD_BD_UNIDAD_DISCO] varchar NOT NULL,
    [AD_BD_TAMANIO_EN_DISCO_EN_GB] numeric NOT NULL,
    [AD_BD_LIMITE_CRECIMIENTO] varchar NOT NULL,
    [AD_BD_MAXIMO_TAMANIO_EN_DISCO_EN_GB] numeric NOT NULL,
    [AD_BD_ESPACIO_PARA_CRECER] numeric NOT NULL,
    [AD_BD_CRECIMIENTO] numeric NOT NULL,
    [AD_BD_TIPO_CRECIMIENTO] varchar NOT NULL,
    [AD_BD_ESTADO] varchar NOT NULL,
    [AD_BD_FECHA_CREACION] datetime NOT NULL,
    [AD_BD_FECHA_AUTOMATICO] datetime NOT NULL
);

CREATE TABLE [dbo].[T_ADMIN_DISCO_DURO] (
    [AD_SERVIDOR_NOMBRE] varchar NOT NULL,
    [AD_SERVIDOR_IP] varchar NOT NULL,
    [AD_SERVIDOR_UNIDAD_DISCO] varchar NOT NULL,
    [AD_SERVIDOR_TOTAL_GB] numeric NOT NULL,
    [AD_SERVIDOR_TOTAL_GB_USADO] numeric NOT NULL,
    [AD_SERVIDOR_TOTAL_GB_DISPONIBLE] numeric NOT NULL,
    [AD_SERVIDOR_FECHA_AUTOMATICO] datetime NOT NULL
);

CREATE TABLE [dbo].[T_ADMIN_DISCO_DURO_ANTERIOR] (
    [AD_SERVIDOR_NOMBRE] varchar NOT NULL,
    [AD_SERVIDOR_IP] varchar NOT NULL,
    [AD_SERVIDOR_UNIDAD_DISCO] varchar NOT NULL,
    [AD_SERVIDOR_TOTAL_GB] numeric NOT NULL,
    [AD_SERVIDOR_TOTAL_GB_USADO] numeric NOT NULL,
    [AD_SERVIDOR_TOTAL_GB_DISPONIBLE] numeric NOT NULL,
    [AD_SERVIDOR_FECHA_AUTOMATICO] datetime NOT NULL
);

CREATE TABLE [dbo].[T_ADMIN_TAMANIO_TABLAS] (
    [AD_SERVIDOR_NOMBRE] varchar NOT NULL,
    [AD_SERVIDOR_IP] varchar NOT NULL,
    [AD_BD_NOMBRE] varchar NOT NULL,
    [AD_TABLA_NOMBRE] varchar NOT NULL,
    [AD_TABLA_FILAS] numeric NOT NULL,
    [AD_TABLA_ESPACIO_RESERVADO] numeric NOT NULL,
    [AD_TABLA_ESPACIO_DATA] numeric NOT NULL,
    [AD_TABLA_TAMANIO_INDICE] numeric NOT NULL,
    [AD_TABLA_ESPACIO_NO_USADO] numeric NOT NULL,
    [AD_TABLA_FECHA_CREACION] datetime NOT NULL,
    [AD_TABLA_FECHA_ULTIMA_MODIF_EXTRUCTURA] datetime NOT NULL,
    [AD_TABLA_FECHA_AUTOMATICO] datetime NOT NULL
);

CREATE TABLE [dbo].[T_ADMIN_TAMANIO_TABLAS_ANTERIOR] (
    [AD_SERVIDOR_NOMBRE] varchar NOT NULL,
    [AD_SERVIDOR_IP] varchar NOT NULL,
    [AD_BD_NOMBRE] varchar NOT NULL,
    [AD_TABLA_NOMBRE] varchar NOT NULL,
    [AD_TABLA_FILAS] numeric NOT NULL,
    [AD_TABLA_ESPACIO_RESERVADO] numeric NOT NULL,
    [AD_TABLA_ESPACIO_DATA] numeric NOT NULL,
    [AD_TABLA_TAMANIO_INDICE] numeric NOT NULL,
    [AD_TABLA_ESPACIO_NO_USADO] numeric NOT NULL,
    [AD_TABLA_FECHA_CREACION] datetime NOT NULL,
    [AD_TABLA_FECHA_ULTIMA_MODIF_EXTRUCTURA] datetime NOT NULL,
    [AD_TABLA_FECHA_AUTOMATICO] datetime NOT NULL
);

CREATE TABLE [dbo].[T_LOG_PROCESOS] (
    [LOG_ID] int NOT NULL,
    [LOG_FECHA] datetime NOT NULL,
    [LOG_NOMBRE_DTS] varchar NOT NULL,
    [LOG_PASO_DTS] varchar NOT NULL,
    CONSTRAINT [PK_T_LOG_PROCESOS] PRIMARY KEY ([LOG_ID])
);

CREATE TABLE [dbo].[T_WHO2_CAPTURA] (
    [FECHA_HORA_CAPTURA_SISTEMA] datetime NOT NULL,
    [SPID] int NOT NULL,
    [Status] varchar NOT NULL,
    [Login] varchar NOT NULL,
    [HostName] varchar NOT NULL,
    [BlkBy] varchar NOT NULL,
    [DBName] varchar NOT NULL,
    [Command] varchar NOT NULL,
    [CPUTime] int NOT NULL,
    [DiskIO] int NOT NULL,
    [LastBatch] varchar NOT NULL,
    [ProgramName] varchar NOT NULL,
    [SPID2] int NOT NULL,
    [REQUESTID] int NOT NULL
);

CREATE TABLE [dbo].[T_ANIS_UNICOS] (
    [FECHA] varchar NOT NULL,
    [HORA] varchar NOT NULL,
    [TELEFONO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [NOMBRE_PROGRAMA] varchar NOT NULL,
    [GRUPO_GESTION] varchar NOT NULL
);

CREATE TABLE [dbo].[T_DETALLE_ABANDONO] (
    [Interaction ID] varchar NOT NULL,
    [Interaction Type] varchar NOT NULL,
    [Handling Attempt Start] varchar NOT NULL,
    [Last VQueue] varchar NOT NULL,
    [Handling Resource Type] varchar NOT NULL,
    [Routing Point Time] varchar NOT NULL,
    [Service Subtype] varchar NOT NULL,
    [Technical Result] varchar NOT NULL,
    [Technical Result Reason] varchar NOT NULL,
    [Stop Action] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [COLA_COD] varchar NOT NULL,
    [flag_Abandono_Previo] varchar NOT NULL,
    [PLATAF_DESCRIPCION] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [HORA] varchar NOT NULL,
    [MEDIA_HORA] varchar NOT NULL
);

CREATE TABLE [dbo].[T_DETALLE_INFOMART_202503] (
    [Handling Attempt Hint] varchar NOT NULL,
    [Tenant Name] varchar NOT NULL,
    [Interaction ID] varchar NOT NULL,
    [Interaction Handling Attempt ID] varchar NOT NULL,
    [Interaction Type] varchar NOT NULL,
    [Handling Attempt Start] varchar NOT NULL,
    [Handling Attempt End] varchar NOT NULL,
    [Start Timestamp] varchar NOT NULL,
    [End Timestamp] varchar NOT NULL,
    [Duration] varchar NOT NULL,
    [Media Type] varchar NOT NULL,
    [From] varchar NOT NULL,
    [To] varchar NOT NULL,
    [GUID] varchar NOT NULL,
    [Last IVR] varchar NOT NULL,
    [Last Queue] varchar NOT NULL,
    [Last VQueue] varchar NOT NULL,
    [Handling Resource] varchar NOT NULL,
    [Handling Resource Type] varchar NOT NULL,
    [Response Time] varchar NOT NULL,
    [Queue Time] varchar NOT NULL,
    [Routing Point Time] varchar NOT NULL,
    [Total Duration] varchar NOT NULL,
    [Customer Engage Time] varchar NOT NULL,
    [Customer Hold Time] varchar NOT NULL,
    [Customer Handle Time] varchar NOT NULL,
    [Customer Alert Time] varchar NOT NULL,
    [Customer Dial Time] varchar NOT NULL,
    [Customer Wrap Time] varchar NOT NULL,
    [Conference Initiated Time] varchar NOT NULL,
    [Conference Received Time] varchar NOT NULL,
    [Routing Target] varchar NOT NULL,
    [Routing Target Type] varchar NOT NULL,
    [Routing Target Selected] varchar NOT NULL,
    [Customer ID] varchar NOT NULL,
    [Service Type] varchar NOT NULL,
    [Service Subtype] varchar NOT NULL,
    [Customer Segment] varchar NOT NULL,
    [Business Result] varchar NOT NULL,
    [Resource State] varchar NOT NULL,
    [Technical Result] varchar NOT NULL,
    [Technical Result Reason] varchar NOT NULL,
    [Technical Result Resource Role] varchar NOT NULL,
    [Technical Result Role Reason] varchar NOT NULL,
    [Active] varchar NOT NULL,
    [Stop Action] varchar NOT NULL,
    [NOMBRE_ARCHIVO] varchar NOT NULL,
    [FLAG_ARCHIVO] varchar NOT NULL,
    [CALL_RETRY] varchar NOT NULL,
    [CDN] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [CORRELATIVO] int NOT NULL,
    [Consult_Rcv_Talk_Time] varchar NOT NULL,
    [Consult_Rcv_Hold_Time] varchar NOT NULL,
    [Consult_Rcv_Wrap_Time] varchar NOT NULL,
    [NAC_Desktop] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_IVR] varchar NOT NULL,
    [PLACE] varchar NOT NULL,
    [CALL2] varchar NOT NULL,
    [CALL3] varchar NOT NULL,
    [NUEVO_CAMPO_CC] varchar NOT NULL,
    [FLAG_AR] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [SITE_GENESYS] varchar NOT NULL,
    [SITE_PROVEEDOR] varchar NOT NULL,
    [SITE_COLA] varchar NOT NULL,
    [SITE_MIXTO] varchar NOT NULL,
    [IVR_CONNID] varchar NOT NULL,
    [ID_VENTAS] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [flag_Abandono_Previo] varchar NOT NULL
);

CREATE TABLE [dbo].[T_HISPAM_RESUMEN] (
    [PERIODO] varchar NOT NULL,
    [TIPO] varchar NOT NULL,
    [DESCRIPCION] varchar NOT NULL,
    [Q] int NOT NULL,
    [QLLAMA] int NOT NULL
);

CREATE TABLE [dbo].[T_LISTADO_DNIS_GENESYS_V2] (
    [DNGEN_FECHA] varchar NOT NULL,
    [DNGEN_EMPLOYEE_ID] varchar NOT NULL,
    [DNGEN_SERVICIO] varchar NOT NULL,
    [DNGEN_ALIADO] varchar NOT NULL,
    [DNGEN_ALIADO_LOCAL] varchar NOT NULL
);

CREATE TABLE [dbo].[T_LISTADO_RP_ATENCION_RAPIDA] (
    [RP] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [Fecha_Uso] varchar NOT NULL,
    [SISTEMA] varchar NOT NULL,
    [FECHA_INICIO] date NOT NULL,
    [FECHA_FIN] date NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_BLANCA] (
    [TELEFONO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_CABINAS] (
    [Telefono] varchar NOT NULL,
    [Tienda_Inicio] varchar NOT NULL,
    [Canal] varchar NOT NULL,
    [Subcanal] varchar NOT NULL,
    [Tecnologia] varchar NOT NULL,
    [Socio] varchar NOT NULL,
    [Tienda_Estandar] varchar NOT NULL,
    [Fecha_Inicio] datetime NOT NULL,
    [Fecha_Fin] datetime NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_CABINAS_OLD] (
    [Telefono] varchar NOT NULL,
    [Tienda_Inicio] varchar NOT NULL,
    [Canal] varchar NOT NULL,
    [Subcanal] varchar NOT NULL,
    [Tecnologia] varchar NOT NULL,
    [Socio] varchar NOT NULL,
    [Tienda_Estandar] varchar NOT NULL,
    [Fecha_Inicio] datetime NOT NULL,
    [Fecha_Fin] datetime NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_DNI_TEMPO] (
    [DNI] varchar NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_NEGRA] (
    [TELF_LLAMANTE] varchar NOT NULL,
    [TITULARIDAD] varchar NOT NULL,
    [GESTION] varchar NOT NULL,
    [TIPO] varchar NOT NULL,
    [FECHA_CREACION] date NOT NULL,
    [FECHA_INICIO] date NOT NULL,
    [FECHA_FIN] date NOT NULL,
    [ESTADO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TEMPORAL_DETALLE_LLAMADAS_V7] (
    [Aliado] varchar NOT NULL,
    [Programa] varchar NOT NULL,
    [DNIS] varchar NOT NULL,
    [Producto ANI] varchar NOT NULL,
    [Site Ingreso] varchar NOT NULL,
    [Anexo ANI] varchar NOT NULL,
    [Anexo NAC] varchar NOT NULL,
    [NAC Desktop] varchar NOT NULL,
    [NAC IVR] varchar NOT NULL,
    [Producto NAC] varchar NOT NULL,
    [Tema] varchar NOT NULL,
    [Sub-Tema] varchar NOT NULL,
    [Place] varchar NOT NULL,
    [Abandoned from Hold] varchar NOT NULL,
    [To] varchar NOT NULL,
    [Connection ID] varchar NOT NULL,
    [GUID] varchar NOT NULL,
    [From] varchar NOT NULL,
    [Customer Engage Time] varchar NOT NULL,
    [Customer Handle Time] varchar NOT NULL,
    [Customer Hold Time] varchar NOT NULL,
    [Customer Wrap Time] varchar NOT NULL,
    [15 minutes] varchar NOT NULL,
    [Employee ID] varchar NOT NULL,
    [First Name] varchar NOT NULL,
    [Last Name] varchar NOT NULL,
    [User Name] varchar NOT NULL,
    [ANI IVR] varchar NOT NULL,
    [Last VQueue] varchar NOT NULL,
    [Interaction ID] varchar NOT NULL,
    [Interaction Handling Attempt ID] varchar NOT NULL,
    [Handling Attempt Start] varchar NOT NULL,
    [Handling Attempt End] varchar NOT NULL,
    [Interaction Type] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TEMP_DETALLE_INFOMART] (
    [Handling Attempt Hint] varchar NOT NULL,
    [Tenant Name] varchar NOT NULL,
    [Interaction ID] varchar NOT NULL,
    [Interaction Handling Attempt ID] varchar NOT NULL,
    [Interaction Type] varchar NOT NULL,
    [Handling Attempt Start] varchar NOT NULL,
    [Handling Attempt End] varchar NOT NULL,
    [Start Timestamp] varchar NOT NULL,
    [End Timestamp] varchar NOT NULL,
    [Duration] varchar NOT NULL,
    [Media Type] varchar NOT NULL,
    [From] varchar NOT NULL,
    [To] varchar NOT NULL,
    [GUID] varchar NOT NULL,
    [Last IVR] varchar NOT NULL,
    [Last Queue] varchar NOT NULL,
    [Last VQueue] varchar NOT NULL,
    [Handling Resource] varchar NOT NULL,
    [Handling Resource Type] varchar NOT NULL,
    [Response Time] varchar NOT NULL,
    [Queue Time] varchar NOT NULL,
    [Routing Point Time] varchar NOT NULL,
    [Total Duration] varchar NOT NULL,
    [Customer Engage Time] varchar NOT NULL,
    [Customer Hold Time] varchar NOT NULL,
    [Customer Handle Time] varchar NOT NULL,
    [Customer Alert Time] varchar NOT NULL,
    [Customer Dial Time] varchar NOT NULL,
    [Customer Wrap Time] varchar NOT NULL,
    [Conference Initiated Time] varchar NOT NULL,
    [Conference Received Time] varchar NOT NULL,
    [Routing Target] varchar NOT NULL,
    [Routing Target Type] varchar NOT NULL,
    [Routing Target Selected] varchar NOT NULL,
    [Customer ID] varchar NOT NULL,
    [Service Type] varchar NOT NULL,
    [Service Subtype] varchar NOT NULL,
    [Customer Segment] varchar NOT NULL,
    [Business Result] varchar NOT NULL,
    [Resource State] varchar NOT NULL,
    [Technical Result] varchar NOT NULL,
    [Technical Result Reason] varchar NOT NULL,
    [Technical Result Resource Role] varchar NOT NULL,
    [Technical Result Role Reason] varchar NOT NULL,
    [Active] varchar NOT NULL,
    [Stop Action] varchar NOT NULL,
    [NOMBRE_ARCHIVO] varchar NOT NULL,
    [CALL_RETRY] varchar NOT NULL,
    [CDN] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [CORRELATIVO] int NOT NULL,
    [Consult_Rcv_Talk_Time] varchar NOT NULL,
    [Consult_Rcv_Hold_Time] varchar NOT NULL,
    [Consult_Rcv_Wrap_Time] varchar NOT NULL,
    [FLAG_AR] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [CALL2] varchar NOT NULL,
    [CALL3] varchar NOT NULL,
    [NUEVO_CAMPO_CC] varchar NOT NULL,
    [NAC_Desktop] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_IVR] varchar NOT NULL,
    [PLACE] varchar NOT NULL,
    [SITE_GENESYS] varchar NOT NULL,
    [SITE_PROVEEDOR] varchar NOT NULL,
    [SITE_COLA] varchar NOT NULL,
    [SITE_MIXTO] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [flag_Abandono_Previo] varchar NOT NULL,
    [ID_VENTAS] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TEMP_DETALLE_INFORMART_V5] (
    [Handling Attempt Hint] varchar NOT NULL,
    [Tenant Name] varchar NOT NULL,
    [Interaction ID] varchar NOT NULL,
    [Interaction Handling Attempt ID] varchar NOT NULL,
    [Interaction Type] varchar NOT NULL,
    [Handling Attempt Start] varchar NOT NULL,
    [Handling Attempt End] varchar NOT NULL,
    [Start Timestamp] varchar NOT NULL,
    [End Timestamp] varchar NOT NULL,
    [Duration] varchar NOT NULL,
    [Media Type] varchar NOT NULL,
    [From] varchar NOT NULL,
    [To] varchar NOT NULL,
    [GUID] varchar NOT NULL,
    [Last IVR] varchar NOT NULL,
    [Last Queue] varchar NOT NULL,
    [Last VQueue] varchar NOT NULL,
    [Handling Resource] varchar NOT NULL,
    [Handling Resource Type] varchar NOT NULL,
    [Response Time] varchar NOT NULL,
    [Queue Time] varchar NOT NULL,
    [Routing Point Time] varchar NOT NULL,
    [Total Duration] varchar NOT NULL,
    [Customer Engage Time] varchar NOT NULL,
    [Customer Hold Time] varchar NOT NULL,
    [Customer Handle Time] varchar NOT NULL,
    [Customer Alert Time] varchar NOT NULL,
    [Customer Dial Time] varchar NOT NULL,
    [Customer Wrap Time] varchar NOT NULL,
    [Conference Initiated Time] varchar NOT NULL,
    [Conference Received Time] varchar NOT NULL,
    [Routing Target] varchar NOT NULL,
    [Routing Target Type] varchar NOT NULL,
    [Routing Target Selected] varchar NOT NULL,
    [Customer ID] varchar NOT NULL,
    [Service Type] varchar NOT NULL,
    [Service Subtype] varchar NOT NULL,
    [Customer Segment] varchar NOT NULL,
    [Business Result] varchar NOT NULL,
    [Resource State] varchar NOT NULL,
    [Technical Result] varchar NOT NULL,
    [Technical Result Reason] varchar NOT NULL,
    [Technical Result Resource Role] varchar NOT NULL,
    [Technical Result Role Reason] varchar NOT NULL,
    [Active] varchar NOT NULL,
    [Stop Action] varchar NOT NULL,
    [NOMBRE_ARCHIVO] varchar NOT NULL,
    [FLAG_ARCHIVO] varchar NOT NULL,
    [CALL_RETRY] varchar NOT NULL,
    [CDN] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [CORRELATIVO] int NOT NULL,
    [Consult_Rcv_Talk_Time] varchar NOT NULL,
    [Consult_Rcv_Hold_Time] varchar NOT NULL,
    [Consult_Rcv_Wrap_Time] varchar NOT NULL,
    [NAC_Desktop] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_IVR] varchar NOT NULL,
    [PLACE] varchar NOT NULL,
    [CALL2] varchar NOT NULL,
    [CALL3] varchar NOT NULL,
    [NUEVO_CAMPO_CC] varchar NOT NULL,
    [FLAG_AR] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [SITE_GENESYS] varchar NOT NULL,
    [SITE_PROVEEDOR] varchar NOT NULL,
    [SITE_COLA] varchar NOT NULL,
    [SITE_MIXTO] varchar NOT NULL,
    [IVR_CONNID] varchar NOT NULL,
    [ID_VENTAS] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [flag_Abandono_Previo] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_LISTA_CABINAS] (
    [Telefono] varchar NOT NULL,
    [Tienda_Inicio] varchar NOT NULL,
    [Canal] varchar NOT NULL,
    [Subcanal] varchar NOT NULL,
    [Tecnologia] varchar NOT NULL,
    [Socio] varchar NOT NULL,
    [Tienda_Estandar] varchar NOT NULL,
    [Fecha_Inicio] datetime NOT NULL,
    [Fecha_Fin] datetime NOT NULL
);

CREATE TABLE [dbo].[base_multicentro] (
    [TELEFONO] varchar NOT NULL
);

CREATE TABLE [dbo].[sysdiagrams] (
    [name] sysname NOT NULL,
    [principal_id] int NOT NULL,
    [diagram_id] int NOT NULL,
    [version] int NOT NULL,
    [definition] varbinary NOT NULL,
    CONSTRAINT [PK_sysdiagrams] PRIMARY KEY ([diagram_id])
);

CREATE TABLE [dbo].[T_AGENT_NOT_READY_REASON_CODE_REPORT] (
    [ANRTCR_FECHA] varchar NOT NULL,
    [ANRTCR_HORA] varchar NOT NULL,
    [ANRTCR_REASON_CODE] varchar NOT NULL,
    [ANRTCR_NOT_READY_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_CONTADOR] varchar NOT NULL,
    [ANRTCR_AGENT_NAME] varchar NOT NULL,
    [ANRTCR_MEDIA_TYPE] varchar NOT NULL,
    [ANRTCR_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[T_AGENT_NOT_READY_REASON_CODE_REPORT_202311] (
    [ANRTCR_FECHA] varchar NOT NULL,
    [ANRTCR_HORA] varchar NOT NULL,
    [ANRTCR_REASON_CODE] varchar NOT NULL,
    [ANRTCR_NOT_READY_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_CONTADOR] varchar NOT NULL,
    [ANRTCR_AGENT_NAME] varchar NOT NULL,
    [ANRTCR_MEDIA_TYPE] varchar NOT NULL,
    [ANRTCR_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[T_AGENT_NOT_READY_REASON_CODE_REPORT_202312] (
    [ANRTCR_FECHA] varchar NOT NULL,
    [ANRTCR_HORA] varchar NOT NULL,
    [ANRTCR_REASON_CODE] varchar NOT NULL,
    [ANRTCR_NOT_READY_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_CONTADOR] varchar NOT NULL,
    [ANRTCR_AGENT_NAME] varchar NOT NULL,
    [ANRTCR_MEDIA_TYPE] varchar NOT NULL,
    [ANRTCR_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[T_AGENT_NOT_READY_REASON_CODE_REPORT_202401] (
    [ANRTCR_FECHA] varchar NOT NULL,
    [ANRTCR_HORA] varchar NOT NULL,
    [ANRTCR_REASON_CODE] varchar NOT NULL,
    [ANRTCR_NOT_READY_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_CONTADOR] varchar NOT NULL,
    [ANRTCR_AGENT_NAME] varchar NOT NULL,
    [ANRTCR_MEDIA_TYPE] varchar NOT NULL,
    [ANRTCR_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[T_AGENT_NOT_READY_REASON_CODE_REPORT_202402] (
    [ANRTCR_FECHA] varchar NOT NULL,
    [ANRTCR_HORA] varchar NOT NULL,
    [ANRTCR_REASON_CODE] varchar NOT NULL,
    [ANRTCR_NOT_READY_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_CONTADOR] varchar NOT NULL,
    [ANRTCR_AGENT_NAME] varchar NOT NULL,
    [ANRTCR_MEDIA_TYPE] varchar NOT NULL,
    [ANRTCR_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[T_AGENT_NOT_READY_REASON_CODE_REPORT_202403] (
    [ANRTCR_FECHA] varchar NOT NULL,
    [ANRTCR_HORA] varchar NOT NULL,
    [ANRTCR_REASON_CODE] varchar NOT NULL,
    [ANRTCR_NOT_READY_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_CONTADOR] varchar NOT NULL,
    [ANRTCR_AGENT_NAME] varchar NOT NULL,
    [ANRTCR_MEDIA_TYPE] varchar NOT NULL,
    [ANRTCR_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[T_AGENT_NOT_READY_REASON_CODE_REPORT_202404] (
    [ANRTCR_FECHA] varchar NOT NULL,
    [ANRTCR_HORA] varchar NOT NULL,
    [ANRTCR_REASON_CODE] varchar NOT NULL,
    [ANRTCR_NOT_READY_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_TIME] varchar NOT NULL,
    [ANRTCR_NOT_READY_REASON_CONTADOR] varchar NOT NULL,
    [ANRTCR_AGENT_NAME] varchar NOT NULL,
    [ANRTCR_MEDIA_TYPE] varchar NOT NULL,
    [ANRTCR_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TEMP_Agent_Not_Ready_Reason_Code_Report_Today_PASO_1] (
    [Tenant_Name] varchar NOT NULL,
    [Hour] varchar NOT NULL,
    [Reason_Code] varchar NOT NULL,
    [Not_Ready_Time] varchar NOT NULL,
    [Not_Ready_Reason_Time] varchar NOT NULL,
    [Not_Ready_Reason_Count] varchar NOT NULL,
    [%_Not_Ready_Time] varchar NOT NULL,
    [%_Not_Ready_Reason_Time] varchar NOT NULL,
    [Agent_Name] varchar NOT NULL,
    [Media_Type] varchar NOT NULL,
    [CALC_FECHA] varchar NOT NULL,
    [CALC_HORA] varchar NOT NULL,
    [CALC_AGENT_LOGIN] varchar NOT NULL
);

CREATE TABLE [dbo].[20240917___LLAMADAS_ATENDIDAS_FACTURACION] (
    [ID_INTERACCION] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [SEMANA_ANIO] int NOT NULL,
    [CDN] varchar NOT NULL,
    [SKILL] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CONNID] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [SEMANA_ANIO_ORIGEN] varchar NOT NULL,
    [CDN_ORIGEN] varchar NOT NULL,
    [SKILL_ORIGEN] varchar NOT NULL,
    [PROGRAMA_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [SITE_ORIGEN] varchar NOT NULL,
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [TMO_ORIGEN] varchar NOT NULL,
    [CONNID_ORIGEN] varchar NOT NULL,
    [CALL_RETRY_ORIGEN] varchar NOT NULL,
    [CALL_RETRY_TRX_ORIGEN] varchar NOT NULL,
    [FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [ANI_ORIGEN] varchar NOT NULL,
    [BASE_ANALISIS] varchar NOT NULL,
    [RELLAMADA] varchar NOT NULL,
    [RANGO] varchar NOT NULL,
    [MX_FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [MX_SEMANA_ANIO_ORIGEN] varchar NOT NULL,
    [MX_CDN_ORIGEN] varchar NOT NULL,
    [MX_SKILL_ORIGEN] varchar NOT NULL,
    [MX_PROGRAMA_ORIGEN] varchar NOT NULL,
    [MX_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [MX_SITE_ORIGEN] varchar NOT NULL,
    [MX_NEGOCIO_ORIGEN] varchar NOT NULL,
    [MX_CALL_CENTER_ORIGEN] varchar NOT NULL,
    [MX_TMO_ORIGEN] varchar NOT NULL,
    [MX_CONNID_ORIGEN] varchar NOT NULL,
    [MX_CALL_RETRY_ORIGEN] varchar NOT NULL,
    [MX_FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [MX_ANI_ORIGEN] varchar NOT NULL,
    [MX_BASE_ANALISIS] varchar NOT NULL,
    [MX_RELLAMADA] varchar NOT NULL,
    [MX_RANGO] varchar NOT NULL,
    [FLAG_EXLUSION] varchar NOT NULL,
    [INDICE] int NOT NULL,
    [MOTIVO] varchar NOT NULL,
    [SUB_MOTIVO] varchar NOT NULL
);

CREATE TABLE [dbo].[20240917_____T_TMP_DETALLE] (
    [ID] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [SEMANA_ANIO] int NOT NULL,
    [CDN] varchar NOT NULL,
    [SKILL] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CONNID] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [SERVICE TYPE] varchar NOT NULL
);

CREATE TABLE [dbo].[JCO_LISTADO_CTI_DIARIO] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_CTI] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS_PARA_REITERADAS] varchar NOT NULL,
    [TMO] varchar NOT NULL,
    [COPC_SHORT_CALL] varchar NOT NULL,
    [COPC_TOTAL_CULP_RELL] varchar NOT NULL,
    [COPC_TOTAL_CULP_TRX] varchar NOT NULL,
    [COPC_TMO_DIA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_QUARTIL_RELL] varchar NOT NULL,
    [COPC_QUARTIL_TRX] varchar NOT NULL,
    [COPC_QUARTIL_TMO] varchar NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] varchar NOT NULL,
    [COPC_IND_CULPABLE_TRANS] varchar NOT NULL,
    [COPC_IND_CULPABLE_SHORT_CALL] varchar NOT NULL,
    [COPC_CRUCE_LISTA_CALL] varchar NOT NULL,
    [COPC_QUARTIL_RELL_CALL] varchar NOT NULL,
    [COPC_QUARTIL_TRX_CALL] varchar NOT NULL,
    [COPC_QUARTIL_TMO_CALL] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[LD_CLIENTES_REIT] (
    [ANI] varchar NOT NULL,
    [MES] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [LLAMADAS_ATENDIDAS] int NOT NULL,
    [LLAMADAS_ENTRANTES] int NOT NULL
);

CREATE TABLE [dbo].[LD_TMP_TABLA_BATCHERO_ELIMINA_ARCHIVOS_IHV5_POR_HORAS] (
    [QUERY] varchar NOT NULL
);

CREATE TABLE [dbo].[LLAMADAS_ATENDIDAS] (
    [ID_INTERACCION] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [SEMANA_ANIO] int NOT NULL,
    [CDN] varchar NOT NULL,
    [SKILL] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CONNID] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [SEMANA_ANIO_ORIGEN] varchar NOT NULL,
    [CDN_ORIGEN] varchar NOT NULL,
    [SKILL_ORIGEN] varchar NOT NULL,
    [PROGRAMA_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [SITE_ORIGEN] varchar NOT NULL,
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [TMO_ORIGEN] varchar NOT NULL,
    [CONNID_ORIGEN] varchar NOT NULL,
    [CALL_RETRY_ORIGEN] varchar NOT NULL,
    [CALL_RETRY_TRX_ORIGEN] varchar NOT NULL,
    [FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [ANI_ORIGEN] varchar NOT NULL,
    [BASE_ANALISIS] varchar NOT NULL,
    [RELLAMADA] varchar NOT NULL,
    [RANGO] varchar NOT NULL,
    [MX_FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [MX_SEMANA_ANIO_ORIGEN] varchar NOT NULL,
    [MX_CDN_ORIGEN] varchar NOT NULL,
    [MX_SKILL_ORIGEN] varchar NOT NULL,
    [MX_PROGRAMA_ORIGEN] varchar NOT NULL,
    [MX_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [MX_SITE_ORIGEN] varchar NOT NULL,
    [MX_NEGOCIO_ORIGEN] varchar NOT NULL,
    [MX_CALL_CENTER_ORIGEN] varchar NOT NULL,
    [MX_TMO_ORIGEN] varchar NOT NULL,
    [MX_CONNID_ORIGEN] varchar NOT NULL,
    [MX_CALL_RETRY_ORIGEN] varchar NOT NULL,
    [MX_FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [MX_ANI_ORIGEN] varchar NOT NULL,
    [MX_BASE_ANALISIS] varchar NOT NULL,
    [MX_RELLAMADA] varchar NOT NULL,
    [MX_RANGO] varchar NOT NULL,
    [FLAG_EXLUSION] varchar NOT NULL,
    [INDICE] int NOT NULL,
    [MOTIVO] varchar NOT NULL,
    [SUB_MOTIVO] varchar NOT NULL
);

CREATE TABLE [dbo].[LLAMADAS_ATENDIDAS_FACTURACION] (
    [ID_INTERACCION] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [SEMANA_ANIO] int NOT NULL,
    [CDN] varchar NOT NULL,
    [SKILL] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CONNID] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [SEMANA_ANIO_ORIGEN] varchar NOT NULL,
    [CDN_ORIGEN] varchar NOT NULL,
    [SKILL_ORIGEN] varchar NOT NULL,
    [PROGRAMA_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [SITE_ORIGEN] varchar NOT NULL,
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [TMO_ORIGEN] varchar NOT NULL,
    [CONNID_ORIGEN] varchar NOT NULL,
    [CALL_RETRY_ORIGEN] varchar NOT NULL,
    [CALL_RETRY_TRX_ORIGEN] varchar NOT NULL,
    [FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [ANI_ORIGEN] varchar NOT NULL,
    [BASE_ANALISIS] varchar NOT NULL,
    [RELLAMADA] varchar NOT NULL,
    [RANGO] varchar NOT NULL,
    [MX_FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [MX_SEMANA_ANIO_ORIGEN] varchar NOT NULL,
    [MX_CDN_ORIGEN] varchar NOT NULL,
    [MX_SKILL_ORIGEN] varchar NOT NULL,
    [MX_PROGRAMA_ORIGEN] varchar NOT NULL,
    [MX_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [MX_SITE_ORIGEN] varchar NOT NULL,
    [MX_NEGOCIO_ORIGEN] varchar NOT NULL,
    [MX_CALL_CENTER_ORIGEN] varchar NOT NULL,
    [MX_TMO_ORIGEN] varchar NOT NULL,
    [MX_CONNID_ORIGEN] varchar NOT NULL,
    [MX_CALL_RETRY_ORIGEN] varchar NOT NULL,
    [MX_FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [MX_ANI_ORIGEN] varchar NOT NULL,
    [MX_BASE_ANALISIS] varchar NOT NULL,
    [MX_RELLAMADA] varchar NOT NULL,
    [MX_RANGO] varchar NOT NULL,
    [FLAG_EXLUSION] varchar NOT NULL,
    [INDICE] int NOT NULL,
    [MOTIVO] varchar NOT NULL,
    [SUB_MOTIVO] varchar NOT NULL
);

CREATE TABLE [dbo].[PROCESO_LOG_PROCESO_REIT_Y_TRANSF] (
    [FECHA] varchar NOT NULL,
    [FECHA_LOG] datetime NOT NULL,
    [PROCESO] varchar NOT NULL,
    [USUARIO] varchar NOT NULL
);

CREATE TABLE [dbo].[TMP_CTI] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_CTI] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS] int NOT NULL,
    [COPC_TOTAL_TMO] int NOT NULL,
    [COPC_SHORT_CALL] int NOT NULL,
    [COPC_TOTAL_CULP_RELL] int NOT NULL,
    [COPC_TOTAL_CULP_TRX] int NOT NULL,
    [COPC_TMO_MES] int NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_QUARTIL_RELL] int NOT NULL,
    [COPC_QUARTIL_TRX] int NOT NULL,
    [COPC_QUARTIL_TMO] int NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] float NOT NULL,
    [COPC_IND_CULPABLE_TRANS] float NOT NULL,
    [COPC_IND_CULPABLE_SHORT_CALL] float NOT NULL,
    [COPC_CRUCE_LISTA_CALL] varchar NOT NULL,
    [COPC_QUARTIL_RELL_CALL] int NOT NULL,
    [COPC_QUARTIL_TRX_CALL] int NOT NULL,
    [COPC_QUARTIL_TMO_CALL] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[TMP_RESUMEN_AGENTE_REITERADAS] (
    [MES] varchar NOT NULL,
    [MX_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [MX_CALL_CENTER_ORIGEN] varchar NOT NULL,
    [MX_FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [MX_SITE_ORIGEN] varchar NOT NULL,
    [MX_NEGOCIO_ORIGEN] varchar NOT NULL,
    [RELL] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [RANGO] varchar NOT NULL
);

CREATE TABLE [dbo].[TMP_RESUMEN_AGENTE_REITERADAS_CUARTIL] (
    [MES] varchar NOT NULL,
    [MX_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [MX_CALL_CENTER_ORIGEN] varchar NOT NULL,
    [MX_FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [MX_SITE_ORIGEN] varchar NOT NULL,
    [MX_NEGOCIO_ORIGEN] varchar NOT NULL,
    [RELL] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[TMP_RESUMEN_CTI] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_CTI] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS] int NOT NULL,
    [COPC_TOTAL_TMO] int NOT NULL,
    [COPC_SHORT_CALL] int NOT NULL,
    [COPC_TOTAL_CULP_RELL] int NOT NULL,
    [COPC_TOTAL_CULP_TRX] int NOT NULL,
    [COPC_TMO_MES] int NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_QUARTIL_RELL] bigint NOT NULL,
    [COPC_QUARTIL_TRX] bigint NOT NULL,
    [COPC_QUARTIL_TMO] bigint NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] float NOT NULL,
    [COPC_IND_CULPABLE_TRANS] float NOT NULL,
    [COPC_IND_CULPABLE_SHORT_CALL] float NOT NULL,
    [COPC_CRUCE_LISTA_CALL] varchar NOT NULL,
    [COPC_QUARTIL_RELL_CALL] bigint NOT NULL,
    [COPC_QUARTIL_TRX_CALL] bigint NOT NULL,
    [COPC_QUARTIL_TMO_CALL] bigint NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [COPC_MAXIMO_Q1_RELLAMADAS] decimal NOT NULL,
    [COPC_MAXIMO_Q1_TRANSF] decimal NOT NULL,
    [EXCEDENTE_RELL] float NOT NULL,
    [EXCEDENTE_TRANS] float NOT NULL
);

CREATE TABLE [dbo].[TMP_RESUMEN_Q_RELL] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_QUARTIL_RELL] bigint NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] float NOT NULL
);

CREATE TABLE [dbo].[TMP_RESUMEN_Q_TRX] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_QUARTIL_TRX] bigint NOT NULL,
    [COPC_IND_CULPABLE_TRANS] float NOT NULL
);

CREATE TABLE [dbo].[TMP_T_RESUMEN_AGENTE_TRANSF_CUARTIL] (
    [MES] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [SITE_ORIGEN] varchar NOT NULL,
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [CANT_TRX] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[TMP_T_RESUMEN_AGENTE_TRX] (
    [MES] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [SITE_ORIGEN] varchar NOT NULL,
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [CANT_TRX] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_DETALLE_RELLAMADORES_ENTRANTES] (
    [ANI] varchar NOT NULL,
    [MES] varchar NOT NULL,
    [SEGMENTO] varchar NOT NULL,
    [RANGO_LLAMADAS] varchar NOT NULL,
    [NEGOCIO_ANI] varchar NOT NULL,
    [LLAMADAS_ENTRANTES] int NOT NULL,
    [LLAMADAS_ATENDIDAS] int NOT NULL,
    [FECHA_ACTUALIZACION] date NOT NULL
);

CREATE TABLE [dbo].[T_DETALLE_RELLAMADORES_ENTRANTES_X_PLATAF] (
    [ANI] varchar NOT NULL,
    [MES] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [LLAMADAS_ATENDIDAS] int NOT NULL,
    [LLAMADAS_ENTRANTES] int NOT NULL,
    [SEGMENTO] varchar NOT NULL,
    [RANGO_LLAMADAS] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [TIPO_NEGOCIO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_DETALLE_RELLAMADORES_EN_20D] (
    [ANI] varchar NOT NULL,
    [CANT_ACCESOS] int NOT NULL,
    [CANT_ENTRANTES] int NOT NULL,
    [Fecha_Actualizacion] date NOT NULL,
    [RANGO_LLAM_IVR] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [TELEFONO_LLAMANTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_DETALLE_TRANSFERENCIAS_MISMO_RP] (
    [FECHA_LLAM] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [DNI_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [RP_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [DNI_DESTINO] varchar NOT NULL,
    [PLATAFORMA_DESTINO] varchar NOT NULL,
    [RP_DESTINO] varchar NOT NULL,
    [CALL_CENTER_DESTINO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_DETALLE_TRANSFERENCIAS_MISMO_RP_2] (
    [FECHA_LLAM] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [DNI_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [RP_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [DNI_DESTINO] varchar NOT NULL,
    [PLATAFORMA_DESTINO] varchar NOT NULL,
    [RP_DESTINO] varchar NOT NULL,
    [CALL_CENTER_DESTINO] varchar NOT NULL,
    [CANT_TRANSF] int NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_AGENTE_REIT_DIA] (
    [MX_FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [MX_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [MX_CALL_CENTER_ORIGEN] varchar NOT NULL,
    [MX_FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [MX_SITE_ORIGEN] varchar NOT NULL,
    [MX_NEGOCIO_ORIGEN] varchar NOT NULL,
    [RELL] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_AGENTE_TRANSF_DIA] (
    [FECHA_LLAM_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [FIRST_LOGIN_ORIGEN] varchar NOT NULL,
    [SITE_ORIGEN] varchar NOT NULL,
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [CANT_TRX] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_BLANCA_RELLAMADORES_AURA] (
    [CDR_ANI] varchar NOT NULL,
    [CDR_PRODUCTO] varchar NOT NULL,
    [Q_LLAM] int NOT NULL,
    [MES_NUM] int NOT NULL,
    [MES] nvarchar NOT NULL,
    [FECHA_ACTUALIZACION] smalldatetime NOT NULL,
    [SEGMENTO] varchar NOT NULL,
    [PROM_DURACION_LLAM] int NOT NULL,
    [ANIO] int NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_CTI_ATENDIDAS_TMO] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_CTI] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS] int NOT NULL,
    [COPC_TOTAL_ATENDIDAS_PARA_REITERADAS] int NOT NULL,
    [COPC_TOTAL_TMO] int NOT NULL,
    [COPC_SHORT_CALL] int NOT NULL,
    [COPC_TOTAL_CULP_RELL] int NOT NULL,
    [COPC_TOTAL_CULP_TRX] int NOT NULL,
    [COPC_TMO_MES] int NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_QUARTIL_RELL] int NOT NULL,
    [COPC_QUARTIL_TRX] int NOT NULL,
    [COPC_QUARTIL_TMO] int NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] float NOT NULL,
    [COPC_IND_CULPABLE_TRANS] float NOT NULL,
    [COPC_IND_CULPABLE_SHORT_CALL] float NOT NULL,
    [COPC_CRUCE_LISTA_CALL] varchar NOT NULL,
    [COPC_QUARTIL_RELL_CALL] int NOT NULL,
    [COPC_QUARTIL_TRX_CALL] int NOT NULL,
    [COPC_QUARTIL_TMO_CALL] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [COPC_TOTAL_CULP_RELL_30MIN] int NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS_30MIN] float NOT NULL,
    [COPC_QUARTIL_RELL_30MIN] int NOT NULL,
    [COPC_QUARTIL_RELL_30MIN_CALL] int NOT NULL
);

CREATE TABLE [dbo].[T_LISTA_RETIRAR_RPS_CLIENTES_NO_MIGRADOS] (
    [RETIRAR_RP] varchar NOT NULL,
    CONSTRAINT [PK_T_LISTA_RETIRAR_RPS_CLIENTES_NO_MIGRADOS] PRIMARY KEY ([RETIRAR_RP])
);

CREATE TABLE [dbo].[T_LISTA_RETIRAR_RPS_CLIENTES_NO_MIGRADOS_20241022] (
    [RETIRAR_RP] varchar NOT NULL
);

CREATE TABLE [dbo].[T_LOG_BASE_NPS_AVISO_CORTE] (
    [TELEFONO] varchar NOT NULL,
    [FECHA_SISTEMA] datetime NOT NULL,
    [Q_CANTIDAD_BASE] int NOT NULL,
    [SEGMENTO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_METRICAS_REIT_TRANSF_AMELIA] (
    [NEGOCIO] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [MES] varchar NOT NULL,
    [SEMANA] varchar NOT NULL,
    [IVR] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [INDICADOR] varchar NOT NULL,
    [GENERA] int NOT NULL,
    [ATIENDE] int NOT NULL
);

CREATE TABLE [dbo].[T_METRICAS_TRANSFERENCIAS_DIA_CURSO] (
    [FECHA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [MES] varchar NOT NULL,
    [INDICADOR] varchar NOT NULL,
    [ATENDIDAS] varchar NOT NULL,
    [TRANSFERENCIAS] varchar NOT NULL,
    [PORCENTAJE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_REPORTE_CTI_DIARIO] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_CTI] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS] int NOT NULL,
    [COPC_TOTAL_ATENDIDAS_PARA_REITERADAS] int NOT NULL,
    [TMO] int NOT NULL,
    [COPC_SHORT_CALL] int NOT NULL,
    [COPC_TOTAL_CULP_RELL] int NOT NULL,
    [COPC_TOTAL_CULP_TRX] int NOT NULL,
    [COPC_TMO_DIA] int NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_QUARTIL_RELL] int NOT NULL,
    [COPC_QUARTIL_TRX] int NOT NULL,
    [COPC_QUARTIL_TMO] int NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] float NOT NULL,
    [COPC_IND_CULPABLE_TRANS] float NOT NULL,
    [COPC_IND_CULPABLE_SHORT_CALL] float NOT NULL,
    [COPC_CRUCE_LISTA_CALL] varchar NOT NULL,
    [COPC_QUARTIL_RELL_CALL] int NOT NULL,
    [COPC_QUARTIL_TRX_CALL] int NOT NULL,
    [COPC_QUARTIL_TMO_CALL] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_REPORTE_CTI_MENSUAL] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_CTI] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS] int NOT NULL,
    [COPC_TOTAL_ATENDIDAS_PARA_REITERADAS] int NOT NULL,
    [COPC_TOTAL_TMO] int NOT NULL,
    [COPC_SHORT_CALL] int NOT NULL,
    [COPC_TOTAL_CULP_RELL] int NOT NULL,
    [COPC_TOTAL_CULP_TRX] int NOT NULL,
    [COPC_TMO_MES] int NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_QUARTIL_RELL] bigint NOT NULL,
    [COPC_QUARTIL_TRX] bigint NOT NULL,
    [COPC_QUARTIL_TMO] bigint NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] float NOT NULL,
    [COPC_IND_CULPABLE_TRANS] float NOT NULL,
    [COPC_IND_CULPABLE_SHORT_CALL] float NOT NULL,
    [COPC_CRUCE_LISTA_CALL] varchar NOT NULL,
    [COPC_QUARTIL_RELL_CALL] bigint NOT NULL,
    [COPC_QUARTIL_TRX_CALL] bigint NOT NULL,
    [COPC_QUARTIL_TMO_CALL] bigint NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [COPC_MAXIMO_Q1_RELLAMADAS] float NOT NULL,
    [COPC_MAXIMO_Q1_TRANSF] float NOT NULL,
    [EXCEDENTE_RELL] float NOT NULL,
    [EXCEDENTE_TRANS] float NOT NULL,
    [COPC_PROMEDIO_Q2_RELLAMADAS] float NOT NULL,
    [COPC_PROMEDIO_Q2_TRANSF] float NOT NULL,
    [COPC_TOTAL_CULP_RELL_30MIN] int NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS_30MIN] float NOT NULL,
    [COPC_QUARTIL_RELL_30MIN] int NOT NULL,
    [COPC_QUARTIL_RELL_30MIN_CALL] int NOT NULL,
    [EXCEDENTE_RELL_30MIN] float NOT NULL,
    [COPC_PROMEDIO_Q2_RELLAMADAS_30MIN] float NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_COPC_72HR_ATENDIDAS] (
    [NEGOCIO] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PLATAFORMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] int NOT NULL,
    [COPC_GENERA] varchar NOT NULL,
    [COPC_GENERA_MIXTO] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_COPC_72HR_ATENDIDAS_BU] (
    [NEGOCIO] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PLATAFORMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] int NOT NULL,
    [COPC_GENERA] varchar NOT NULL,
    [COPC_GENERA_MIXTO] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_COPC_72_HR_GENERA] (
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PLATAFORMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] varchar NOT NULL,
    [COPC_GENERA] int NOT NULL,
    [COPC_GENERA_MIXTO] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [COPC_GENERA_MIXTO_V2] int NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_COPC_72_HR_GENERA_BU] (
    [NEGOCIO_ORIGEN] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PLATAFORMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] varchar NOT NULL,
    [COPC_GENERA] int NOT NULL,
    [COPC_GENERA_MIXTO] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [COPC_GENERA_MIXTO_V2] int NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_COPC_ORI_DES_72HR] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_PROGRAMA_ORIGEN] varchar NOT NULL,
    [COPC_PROGRAMA_DESTINO] varchar NOT NULL,
    [COPC_CALL_ORIGEN] varchar NOT NULL,
    [COPC_CALL_DESTINO] varchar NOT NULL,
    [COPC_SITE_ORIGEN] varchar NOT NULL,
    [COPC_SITE_DESTINO] varchar NOT NULL,
    [COPC_CDN_ORIGEN] varchar NOT NULL,
    [COPC_CDN_DESTINO] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_GENERA] varchar NOT NULL,
    [COPC_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [COPC_PLATAFORMA_DESTINO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_CTI_72HR] (
    [RESCTI_NEGOCIO] varchar NOT NULL,
    [RESCTI_FECHA] varchar NOT NULL,
    [RESCTI_CAL] varchar NOT NULL,
    [RESCTI_CTI] varchar NOT NULL,
    [RESCTI_TOTAL_ATENDIDAS] varchar NOT NULL,
    [RESCTI_TOTAL_ATENDIDAS_PARA_REITERADAS] int NOT NULL,
    [RESCTI_TOTAL_TMO] varchar NOT NULL,
    [RESCTI_SHORT_CALL] varchar NOT NULL,
    [RESCTI_TOTAL_CULP_RELL] varchar NOT NULL,
    [RESCTI_TOTAL_CULP_TRX] varchar NOT NULL,
    [RESCTI_TMO_MES] varchar NOT NULL,
    [RESCTI_PLATAFORMA] varchar NOT NULL,
    [RESCTI_SITE] varchar NOT NULL,
    [RESCTI_QUARTIL_RELL] varchar NOT NULL,
    [RESCTI_QUARTIL_TRX] varchar NOT NULL,
    [RESCTI_QUARTIL_TMO] varchar NOT NULL,
    [RESCTI_IND_CULPABLE_RELLAMADAS] varchar NOT NULL,
    [RESCTI_IND_CULPABLE_TRANS] varchar NOT NULL,
    [RESCTI_IND_CULPABLE_SHORT_CALL] varchar NOT NULL,
    [RESCTI_CRUCE_LISTA_CALL] varchar NOT NULL,
    [RESCTI_QUARTIL_RELL_CALL] varchar NOT NULL,
    [RESCTI_QUARTIL_TRX_CALL] varchar NOT NULL,
    [RESCTI_QUARTIL_TMO_CALL] varchar NOT NULL,
    [RESCTI_GRUPO_REPORTE] varchar NOT NULL,
    [RESCTI_MAXIMO_Q1_RELLAMADAS] varchar NOT NULL,
    [RESCTI_MAXIMO_Q1_TRANSF] varchar NOT NULL,
    [RESCTI_EXCEDENTE_RELL] varchar NOT NULL,
    [RESCTI_EXCEDENTE_TRANS] varchar NOT NULL,
    [RESCTI_PROMEDIO_Q2_RELLAMADAS] varchar NOT NULL,
    [RESCTI_PROMEDIO_Q2_TRANSF] varchar NOT NULL,
    [RESCTI_TOTAL_CULP_RELL_30MIN] int NOT NULL,
    [RESCTI_IND_CULPABLE_RELLAMADAS_30MIN] float NOT NULL,
    [RESCTI_QUARTIL_RELL_30MIN] int NOT NULL,
    [RESCTI_QUARTIL_RELL_30MIN_CALL] int NOT NULL,
    [RESCTI_EXCEDENTE_RELL_30MIN] float NOT NULL,
    [RESCTI_COPC_PROMEDIO_Q2_RELLAMADAS_30MIN] float NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_CTI_72HR_FACTURACION] (
    [RESCTI_NEGOCIO] varchar NOT NULL,
    [RESCTI_FECHA] varchar NOT NULL,
    [RESCTI_CAL] varchar NOT NULL,
    [RESCTI_CTI] varchar NOT NULL,
    [RESCTI_TOTAL_ATENDIDAS] varchar NOT NULL,
    [RESCTI_TOTAL_ATENDIDAS_PARA_REITERADAS] int NOT NULL,
    [RESCTI_TOTAL_TMO] varchar NOT NULL,
    [RESCTI_SHORT_CALL] varchar NOT NULL,
    [RESCTI_TOTAL_CULP_RELL] varchar NOT NULL,
    [RESCTI_TOTAL_CULP_TRX] varchar NOT NULL,
    [RESCTI_TMO_MES] varchar NOT NULL,
    [RESCTI_PLATAFORMA] varchar NOT NULL,
    [RESCTI_SITE] varchar NOT NULL,
    [RESCTI_QUARTIL_RELL] varchar NOT NULL,
    [RESCTI_QUARTIL_TRX] varchar NOT NULL,
    [RESCTI_QUARTIL_TMO] varchar NOT NULL,
    [RESCTI_IND_CULPABLE_RELLAMADAS] varchar NOT NULL,
    [RESCTI_IND_CULPABLE_TRANS] varchar NOT NULL,
    [RESCTI_IND_CULPABLE_SHORT_CALL] varchar NOT NULL,
    [RESCTI_CRUCE_LISTA_CALL] varchar NOT NULL,
    [RESCTI_QUARTIL_RELL_CALL] varchar NOT NULL,
    [RESCTI_QUARTIL_TRX_CALL] varchar NOT NULL,
    [RESCTI_QUARTIL_TMO_CALL] varchar NOT NULL,
    [RESCTI_GRUPO_REPORTE] varchar NOT NULL,
    [RESCTI_MAXIMO_Q1_RELLAMADAS] varchar NOT NULL,
    [RESCTI_MAXIMO_Q1_TRANSF] varchar NOT NULL,
    [RESCTI_EXCEDENTE_RELL] varchar NOT NULL,
    [RESCTI_EXCEDENTE_TRANS] varchar NOT NULL,
    [RESCTI_PROMEDIO_Q2_RELLAMADAS] varchar NOT NULL,
    [RESCTI_PROMEDIO_Q2_TRANSF] varchar NOT NULL,
    [RESCTI_TOTAL_CULP_RELL_30MIN] int NOT NULL,
    [RESCTI_IND_CULPABLE_RELLAMADAS_30MIN] float NOT NULL,
    [RESCTI_QUARTIL_RELL_30MIN] int NOT NULL,
    [RESCTI_QUARTIL_RELL_30MIN_CALL] int NOT NULL,
    [RESCTI_EXCEDENTE_RELL_30MIN] float NOT NULL,
    [RESCTI_COPC_PROMEDIO_Q2_RELLAMADAS_30MIN] float NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_CTI_DIARIO] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [COPC_CAL] varchar NOT NULL,
    [COPC_CTI] varchar NOT NULL,
    [COPC_TOTAL_ATENDIDAS] varchar NOT NULL,
    [COPC_TOTAL_TMO] varchar NOT NULL,
    [COPC_SHORT_CALL] varchar NOT NULL,
    [COPC_TOTAL_CULP_RELL] varchar NOT NULL,
    [COPC_TOTAL_CULP_TRX] varchar NOT NULL,
    [COPC_TMO_DIA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_IND_CULPABLE_RELL] varchar NOT NULL,
    [COPC_IND_CULPABLE_TRANS] varchar NOT NULL,
    [COPC_IND_CULPABLE_SHORT_CALL] varchar NOT NULL,
    [COPC_CRUCE_LISTA_CALL] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_CUARTILES] (
    [MES] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [TMO] int NOT NULL,
    [ATENDIDAS] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [RELL] int NOT NULL,
    [TRANSF] int NOT NULL,
    [IND_RELL] float NOT NULL,
    [IND_TRANSF] float NOT NULL,
    [IND_TMO] int NOT NULL,
    [COPC_QUARTIL_RELL] int NOT NULL,
    [COPC_QUARTIL_TRX] int NOT NULL,
    [COPC_QUARTIL_TMO] int NOT NULL,
    [COPC_QUARTIL_RELL_CALL] int NOT NULL,
    [COPC_QUARTIL_TRX_CALL] int NOT NULL,
    [COPC_QUARTIL_TMO_CALL] int NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_CUARTILES_FINAL] (
    [MES] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [TMO] int NOT NULL,
    [ATENDIDAS] int NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [RELL] int NOT NULL,
    [TRANSF] int NOT NULL,
    [IND_RELL] float NOT NULL,
    [IND_TRANSF] float NOT NULL,
    [IND_TMO] int NOT NULL,
    [QUARTIL_RELL] bigint NOT NULL,
    [QUARTIL_TRANSF] bigint NOT NULL,
    [QUARTIL_TMO] bigint NOT NULL,
    [QUARTIL_RELL_CALL] bigint NOT NULL,
    [QUARTIL_TRANSF_CALL] bigint NOT NULL,
    [QUARTIL_TMO_CALL] bigint NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_METRICAS_PLATAFORMA] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PROGRAMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] date NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] varchar NOT NULL,
    [COPC_GENERA] varchar NOT NULL,
    [COPC_CALCULO] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL,
    [SEGMENTO] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_METRICAS_REITERADAS_TRX_ODS] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PROGRAMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] varchar NOT NULL,
    [COPC_GENERA] varchar NOT NULL,
    [COPC_CALCULO] varchar NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_ORIGEN_DESTINO_PRUEBA] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_PROGRAMA_ORIGEN] varchar NOT NULL,
    [COPC_PROGRAMA_DESTINO] varchar NOT NULL,
    [COPC_CALL_ORIGEN] varchar NOT NULL,
    [COPC_CALL_DESTINO] varchar NOT NULL,
    [COPC_SITE_ORIGEN] varchar NOT NULL,
    [COPC_SITE_DESTINO] varchar NOT NULL,
    [COPC_CDN_ORIGEN] varchar NOT NULL,
    [COPC_CDN_DESTINO] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_GENERA] varchar NOT NULL,
    [COPC_PLATAFORMA_ORIGEN] varchar NOT NULL,
    [COPC_PLATAFORMA_DESTINO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_QUARTIL_RELL] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_QUARTIL_RELL] bigint NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS] float NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_QUARTIL_RELL_30MIN] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_QUARTIL_RELL_30MIN] bigint NOT NULL,
    [COPC_IND_CULPABLE_RELLAMADAS_30MIN] float NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_QUARTIL_TRANS] (
    [COPC_NEGOCIO] varchar NOT NULL,
    [COPC_FECHA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [COPC_QUARTIL_TRX] bigint NOT NULL,
    [COPC_IND_CULPABLE_TRANS] float NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_RANGO_RELLAMADORES_EN_IVR] (
    [RANGO_LLAM_IVR] varchar NOT NULL,
    [CLIENTES] int NOT NULL,
    [CANT_LLAM_IVR] int NOT NULL,
    [Fecha_Actualizacion] date NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_REITERADAS_TRXS] (
    [NEGOCIO] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PLATAFORMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] int NOT NULL,
    [COPC_GENERA] int NOT NULL,
    [COPC_CALCULO] decimal NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_REITERADAS_TRXS_BU] (
    [NEGOCIO] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [COPC_MES] varchar NOT NULL,
    [COPC_SEMANA] varchar NOT NULL,
    [COPC_PLATAFORMA] varchar NOT NULL,
    [COPC_CALL] varchar NOT NULL,
    [COPC_SITE] varchar NOT NULL,
    [COPC_TIEMPO] varchar NOT NULL,
    [COPC_INDICADOR] varchar NOT NULL,
    [COPC_ATIENDE] int NOT NULL,
    [COPC_GENERA] int NOT NULL,
    [COPC_CALCULO] decimal NOT NULL,
    [GRUPO_REPORTE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RESUMEN_TRANSFERENCIAS_MISMP_RP] (
    [FECHA_LLAM] varchar NOT NULL,
    [DNI_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [RP_ORIGEN] varchar NOT NULL,
    [CALL_CENTER_ORIGEN] varchar NOT NULL,
    [DNI_DESTINO] varchar NOT NULL,
    [PLATAFORMA_DESTINO] varchar NOT NULL,
    [RP_DESTINO] varchar NOT NULL,
    [CALL_CENTER_DESTINO] varchar NOT NULL,
    [CANTIDAD_TRANSFERENCIAS] varchar NOT NULL
);

CREATE TABLE [dbo].[T_RES_ANALISIS_CLIENTES_TEC_FIJA] (
    [TIPO_PRODUCTO] varchar NOT NULL,
    [DEPARTAMENTO] varchar NOT NULL,
    [PROVINCIA] varchar NOT NULL,
    [DISTRITO] varchar NOT NULL,
    [ZONA_PRIORIZADA] varchar NOT NULL,
    [MOTIVO] varchar NOT NULL,
    [SUB_MOTIVO] varchar NOT NULL,
    [LLAMADAS_ENTRANTES] int NOT NULL
);

CREATE TABLE [dbo].[T_RES_INDICADOR_REIT_DIARIO] (
    [COPC_MES] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [CALL_SITE] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [INDICADOR] varchar NOT NULL,
    [ATENDIDAS] int NOT NULL,
    [CULP_REITERADAS] int NOT NULL
);

CREATE TABLE [dbo].[T_Resumen_Reiteracion_IVR] (
    [FECHA] varchar NOT NULL,
    [PRODUCTO] varchar NOT NULL,
    [REITERADAS] varchar NOT NULL,
    [ATENDIDAS] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TABLA_RESUMEN_REPETICIONES] (
    [FECHA_LLAMADA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [LLAMADAS_ATENDIDAS] int NOT NULL,
    [ANIS_UNICOS] int NOT NULL,
    [LOGICA] varchar NOT NULL,
    [VISTA] varchar NOT NULL,
    [FECHA_ACTUALIZACION] date NOT NULL
);

CREATE TABLE [dbo].[T_TMP_DETALLE] (
    [ID] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [SEMANA_ANIO] int NOT NULL,
    [CDN] varchar NOT NULL,
    [SKILL] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CONNID] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [SERVICE TYPE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_DETALLE_DIARIO] (
    [ID] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [SEMANA_ANIO] int NOT NULL,
    [CDN] varchar NOT NULL,
    [SKILL] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CONNID] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_DETALLE_DIA_CURSO] (
    [ID] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [SEMANA_ANIO] int NOT NULL,
    [CDN] varchar NOT NULL,
    [SKILL] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [SITE] varchar NOT NULL,
    [NEGOCIO] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CONNID] varchar NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_DETALLE_TRAFICO] (
    [ID_UNICO_LLAMADA] varchar NOT NULL,
    [ID_INTERACCION] varchar NOT NULL,
    [TIPO_INTERACCION] varchar NOT NULL,
    [TIPO_LLAMADA] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAMADA] varchar NOT NULL,
    [COLA] varchar NOT NULL,
    [PROGRAMA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [IVR_CONNID] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [FLAG_ABANDONO_PREVIO] varchar NOT NULL,
    [CALL_RETRY_ABANDONO] varchar NOT NULL,
    [CALL_RETRY_ATENDIDO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_DETALLE_TRAFICO_TRANSFERENCIAS] (
    [ID_UNICO_LLAMADA] varchar NOT NULL,
    [ID_INTERACCION] varchar NOT NULL,
    [TIPO_INTERACCION] varchar NOT NULL,
    [TIPO_LLAMADA] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAMADA_INICIO] varchar NOT NULL,
    [FECHA_LLAMADA_FIN] varchar NOT NULL,
    [COLA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [IVR_CONNID] varchar NOT NULL,
    [SERVICE TYPE] varchar NOT NULL,
    [TECHNICAL RESULT] varchar NOT NULL,
    [Technical Result Resource Role] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [FLAG_ABANDONO_PREVIO] varchar NOT NULL,
    [CALL_RETRY_ABANDONO] varchar NOT NULL,
    [CALL_RETRY_ATENDIDO] varchar NOT NULL,
    [ORIGEN_LLAMADA] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_DETALLE_TRAFICO_VENTAS] (
    [ID_UNICO_LLAMADA] varchar NOT NULL,
    [ID_INTERACCION] varchar NOT NULL,
    [TIPO_INTERACCION] varchar NOT NULL,
    [TIPO_LLAMADA] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAMADA] varchar NOT NULL,
    [COLA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [IVR_CONNID] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [FLAG_ABANDONO_PREVIO] varchar NOT NULL,
    [CALL_RETRY_ABANDONO] varchar NOT NULL,
    [CALL_RETRY_ATENDIDO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_DETALLE_TRANSFERENCIAS] (
    [ID_UNICO_LLAMADA] varchar NOT NULL,
    [ID_INTERACCION] varchar NOT NULL,
    [TIPO_INTERACCION] varchar NOT NULL,
    [ORIGEN_LLAMADA] varchar NOT NULL,
    [SERVICE TYPE] varchar NOT NULL,
    [TIPO_LLAMADA] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAMADA_INICIO] varchar NOT NULL,
    [FECHA_LLAMADA_FIN] varchar NOT NULL,
    [COLA] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [CALL_CENTER] varchar NOT NULL,
    [TMO] int NOT NULL,
    [CALL_RETRY_1] varchar NOT NULL,
    [FIRST_LOGIN] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [ANI_COMBINADO] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [IVR_CONNID] varchar NOT NULL,
    [CALL_RETRY_TRX] varchar NOT NULL,
    [FLAG_ABANDONO_PREVIO] varchar NOT NULL,
    [CALL_RETRY_ABANDONO] varchar NOT NULL,
    [CALL_RETRY_ATENDIDO] varchar NOT NULL,
    [FLAG_TRANSFERENCIA] int NOT NULL,
    [FLAG_TRANSFERENCIA_CROSS] int NOT NULL,
    [CULP_TRANSFERENCIA_ID_UNICO_LLAMADA] varchar NOT NULL,
    [CULP_TRANSFERENCIA_ID_INTERACCION] varchar NOT NULL,
    [CULP_TRANSFERENCIA_TIPO_INTERACCION] varchar NOT NULL,
    [CULP_TRANSFERENCIA_TIPO_LLAMADA] varchar NOT NULL,
    [CULP_TRANSFERENCIA_FECHA_LLAMADA_INICIO] varchar NOT NULL,
    [CULP_TRANSFERENCIA_FECHA_LLAMADA_FIN] varchar NOT NULL,
    [CULP_TRANSFERENCIA_COLA] varchar NOT NULL,
    [CULP_TRANSFERENCIA_PROGRAMA] varchar NOT NULL,
    [CULP_TRANSFERENCIA_PLATAFORMA] varchar NOT NULL,
    [CULP_TRANSFERENCIA_CALL_CENTER] varchar NOT NULL,
    [CULP_TRANSFERENCIA_TMO] varchar NOT NULL,
    [CULP_TRANSFERENCIA_CALL_RETRY_1] varchar NOT NULL,
    [CULP_TRANSFERENCIA_FIRST_LOGIN] varchar NOT NULL,
    [CULP_TRANSFERENCIA_INTERACTION_TYPE] varchar NOT NULL,
    [CULP_TRANSFERENCIA_IVR_CONNID] varchar NOT NULL,
    [CULP_TRANSFERENCIA_CALL_RETRY_TRX] varchar NOT NULL,
    [CULP_TRANSFERENCIA_FLAG_ABANDONO_PREVIO] varchar NOT NULL,
    [CULP_TRANSFERENCIA_CALL_RETRY_ABANDONO] varchar NOT NULL,
    [CULP_TRANSFERENCIA_CALL_RETRY_ATENDIDO] varchar NOT NULL
);

CREATE TABLE [dbo].[T_TMP_LD_CLIENTES_REITERADORES] (
    [TELEFONO_CONSOLIDADO] varchar NOT NULL,
    [MES] nvarchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [LLAMADAS] int NOT NULL
);

CREATE TABLE [dbo].[T_TMP_TMO_REAL] (
    [Mes] varchar NOT NULL,
    [PLATAFORMA] varchar NOT NULL,
    [TMO_Real] numeric NOT NULL
);

CREATE TABLE [dbo].[T_TMP_TRAFICO] (
    [IND] bigint NOT NULL,
    [INTERACTION ID] varchar NOT NULL,
    [Interaction Handling Attempt ID] varchar NOT NULL,
    [INTERACTION TYPE] varchar NOT NULL,
    [Handling Attempt Start] varchar NOT NULL,
    [FROM] varchar NOT NULL,
    [NAC_IVR] varchar NOT NULL,
    [HANDLING RESOURCE] varchar NOT NULL,
    [Handling Resource Type] varchar NOT NULL,
    [PLATAF_DESCRIPCION] varchar NOT NULL,
    [NUEVO_CAMPO_CC] varchar NOT NULL,
    [SITE_MIXTO] varchar NOT NULL,
    [LAST VQUEUE] varchar NOT NULL,
    [TMO] int NOT NULL
);

CREATE TABLE [dbo].[T_TMP_TRAZABILIDAD_CDR__TRANSF_MOVIL_A_FIJA] (
    [REIT_CDR_START_DATETIME] varchar NOT NULL,
    [REIT_CDR_CALL_ID] varchar NOT NULL,
    [REIT_CDR_LAST_USE_CASE] varchar NOT NULL,
    [REIT_CDR_ROUTING_POINT] varchar NOT NULL,
    [CDR_START_DATETIME] varchar NOT NULL,
    [ANI] varchar NOT NULL,
    [CDR_CALL_ID] varchar NOT NULL,
    [CDR_LAST_USE_CASE] varchar NOT NULL,
    [CDR_ROUTING_POINT] varchar NOT NULL,
    [FECHA] varchar NOT NULL,
    [FECHA_LLAM] varchar NOT NULL,
    [IVR_CONNID] varchar NOT NULL,
    [TELEFONO] varchar NOT NULL,
    [TELEFONO_COMBINADO] varchar NOT NULL,
    [PLATAFORMA_ORIGEN] varchar NOT NULL,
    [PLATAFORMA_DESTINO] varchar NOT NULL
);