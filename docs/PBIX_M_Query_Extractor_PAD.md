# PBIX_M_Query_Extractor con Power Automate Desktop

Objetivo: abrir PBIX en Power BI Desktop, entrar a Power Query, abrir Editor avanzado, copiar el script M y guardarlo como TXT.

## 1. Validar instalacion correcta

En PowerShell:

```powershell
Get-StartApps | Where-Object { $_.Name -like '*Power Automate*' }
Get-Command PAD.Console.Host.exe -ErrorAction SilentlyContinue
```

Si no aparece `Power Automate for desktop` o `PAD.Console.Host.exe`, instala Power Automate Desktop.

Microsoft recomienda elegir una sola instalacion:

- Microsoft Store: no requiere permisos de administrador y se actualiza automaticamente.
- MSI: requiere permisos de administrador y permite instalar tambien el runtime de maquina.

## 2. Crear carpetas

```powershell
New-Item -ItemType Directory -Force -Path "C:\data\workspace\Data_Artifacts\PbixLake"
New-Item -ItemType Directory -Force -Path "C:\data\workspace\PbixRPA_Output"
```

Coloca los `.pbix` en:

```text
C:\data\workspace\Data_Artifacts\PbixLake
```

## 3. Crear flujo PAD

Nombre:

```text
PBIX_M_Query_Extractor
```

## 4. Variables del flujo

Accion: `Establecer variable`

```text
PBIX_FOLDER = C:\data\workspace\Data_Artifacts\PbixLake
OUTPUT_FOLDER = C:\data\workspace\PbixRPA_Output
```

Estas variables van dentro de PAD. No son variables de entorno de Windows.

Importante si tu flujo dice `Power Fx esta habilitado`:

```text
Usa PBIX_FOLDER, OUTPUT_FOLDER y PBIX_FILES como variables.
No escribas 'PBIX_FILES' con comillas.
No escribas "%PBIX_FILES%" dentro del For each.
```

Las comillas convierten el nombre en texto. El `For each` necesita la variable tipo lista.

## 5. Acciones PAD

### Preparar salida

Accion: `Crear carpeta`

```text
Carpeta: %OUTPUT_FOLDER%
Si la carpeta existe: No hacer nada
```

### Obtener PBIX

Accion: `Obtener archivos en carpeta`

```text
Carpeta: PBIX_FOLDER
Filtro de archivo: *.pbix
Incluir subcarpetas: No
Guardar archivos en: PBIX_FILES
```

`PBIX_FILES` no queda guardado como archivo en una carpeta. Es una variable interna de PAD en memoria.
La carpeta donde deben estar fisicamente los PBIX es:

```text
C:\data\workspace\Data_Artifacts\PbixLake
```

Si tus PBIX estan en otra ruta, cambia el valor de `PBIX_FOLDER`.

### Loop

Accion: `Para cada`

```text
Valor para iterar: PBIX_FILES
Guardar en: CurrentPBIX
```

Si ves este error:

```text
La expresion "PBIX_FILES" debe ser una lista, una tabla de datos o una fila de datos.
```

normalmente es porque se escribio `'PBIX_FILES'` con comillas, o porque la accion `Obtener archivos en carpeta` no esta guardando el resultado en la variable `PBIX_FILES`.

Dentro del loop:

### Abrir Power BI Desktop

Accion: `Ejecutar aplicacion`

```text
Ruta de aplicacion:
C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe

Argumentos de linea de comandos:
=CurrentPBIX.FullName

Estilo de ventana:
Maximizada
```

Si el PBIX tiene espacios o tildes en el nombre, usa argumentos entre comillas desde Power Fx:

```text
="""" & CurrentPBIX.FullName & """"
```

Si Power BI muestra este error:

```text
No se ha podido abrir el archivo %CurrentPBIX.FullName%
```

significa que PAD esta enviando el texto literal `%CurrentPBIX.FullName%`.
En flujos con Power Fx habilitado no uses `%CurrentPBIX.FullName%` en los argumentos.

Para comprobar que el loop esta leyendo bien, agrega temporalmente una accion:

```text
Mostrar mensaje
Mensaje: =CurrentPBIX.FullName
```

o escribe un log:

```text
Escribir texto en archivo
Ruta: C:\data\workspace\PbixRPA_Output\debug_pbix_actual.txt
Texto: =CurrentPBIX.FullName
```

### Esperar carga

Accion: `Esperar`

```text
Duracion: 120 segundos
```

Para PBIX pesados o thin reports, sube a 180 o 240 segundos.

### Click Transformar datos

Accion: `Hacer clic en elemento UI de ventana`

Captura con la grabadora el boton:

```text
Transformar datos
```

Usa elemento UI, no coordenadas.

### Esperar Power Query

Accion: `Esperar ventana`

```text
Titulo de ventana contiene: Power Query
```

### Seleccionar primera consulta

Accion: `Hacer clic en elemento UI de ventana`

Captura con grabadora la primera consulta de la lista izquierda.

Primer objetivo: una sola consulta. Despues se automatiza la lista completa.

### Abrir Editor avanzado

Accion: `Hacer clic en elemento UI de ventana`

Captura con grabadora:

```text
Editor avanzado
```

### Copiar M Query

Accion: `Enviar teclas`

```text
^a
```

Accion: `Enviar teclas`

```text
^c
```

Accion: `Obtener texto del portapapeles`

```text
Guardar en: M_QUERY
```

### Guardar TXT

Accion: `Escribir texto en archivo`

```text
Ruta:
%OUTPUT_FOLDER%\%CurrentPBIX.Name%.txt

Texto:
%M_QUERY%

Si el archivo existe:
Sobrescribir
```

Nota: `%CurrentPBIX.Name%` incluye `.pbix`. Si quieres limpiar el nombre despues, se puede agregar una accion de reemplazo.

### Cerrar Editor avanzado

Accion: `Enviar teclas`

```text
{Escape}
```

Si Escape no cierra, captura el boton `Cancelar` o `X` con elemento UI.

### Cerrar Power Query y Power BI

Para la primera prueba, hazlo manual o agrega:

Accion: `Enviar teclas`

```text
%{F4}
```

Si pregunta guardar cambios:

```text
{Right}{Enter}
```

Valida esto manualmente antes de correr multiples PBIX.

## 6. Configuracion recomendada de Windows

Antes de grabar y correr:

```text
Escala Windows: 100%
Resolucion: fija
Power BI: maximizado
Power Query: maximizado
Idioma UI: estable
```

## 7. Fase 1

No intentes todas las queries todavia.

Primera meta:

```text
1 PBIX
1 Query
1 TXT con M script
```

Cuando eso quede estable, se escala a:

```text
1 PBIX -> multiples queries
multiples PBIX -> multiples queries
parser Python -> IP, DB, schema, vista, query
```
