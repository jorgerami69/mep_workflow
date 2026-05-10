param(
    [string]$InputFolder = "C:\data\workspace\PbixMetadataOut",
    [string]$OutputFile = "C:\data\workspace\PbixMetadataOut\pbix_forensics_inventory.xlsx"
)

$ErrorActionPreference = "Stop"

function Get-Prop($Object, [string]$Name, $Default = "") {
    if ($null -eq $Object) { return $Default }
    $prop = $Object.PSObject.Properties[$Name]
    if ($null -eq $prop) { return $Default }
    if ($null -eq $prop.Value) { return $Default }
    return $prop.Value
}

function Clean-Text($Value) {
    if ($null -eq $Value) { return "" }
    if ($Value -is [bool]) {
        if ($Value) { return "TRUE" }
        return "FALSE"
    }
    $text = [string]$Value
    return [regex]::Replace($text, "[\x00-\x08\x0B\x0C\x0E-\x1F]", "")
}

function Json-Text($Value) {
    if ($null -eq $Value) { return "" }
    return Clean-Text ($Value | ConvertTo-Json -Depth 80 -Compress)
}

function Add-Base($Row, $JsonFile, $Payload) {
    $Row["pbix"] = Clean-Text (Get-Prop $Payload "pbix")
    $Row["pbix_type"] = Clean-Text (Get-Prop $Payload "type")
    $Row["report_folder"] = Clean-Text $JsonFile.Directory.Name
    $Row["source_json"] = Clean-Text $JsonFile.FullName
}

function New-InventoryRow($JsonFile, $Payload, [string]$ArtifactType) {
    $row = [ordered]@{}
    Add-Base $row $JsonFile $Payload
    $row["artifact_type"] = $ArtifactType
    $row["table_name"] = ""
    $row["object_name"] = ""
    $row["object_kind"] = ""
    $row["field_type"] = ""
    $row["data_type"] = ""
    $row["hidden"] = ""
    $row["active"] = ""
    $row["expression"] = ""
    $row["source"] = ""
    $row["from_table"] = ""
    $row["to_table"] = ""
    $row["property"] = ""
    $row["value_json"] = ""
    return $row
}

function Add-Row($List, $Row) {
    [void]$List.Add([pscustomobject]$Row)
}

function Get-Headers($Rows) {
    $headers = New-Object System.Collections.Generic.List[string]
    $seen = @{}
    foreach ($row in $Rows) {
        foreach ($prop in $row.PSObject.Properties) {
            if (-not $seen.ContainsKey($prop.Name)) {
                $seen[$prop.Name] = $true
                [void]$headers.Add($prop.Name)
            }
        }
    }
    if ($headers.Count -eq 0) { [void]$headers.Add("sin_datos") }
    return $headers
}

function Column-Letter([int]$Index) {
    $letters = ""
    while ($Index -gt 0) {
        $Index--
        $letters = [char](65 + ($Index % 26)) + $letters
        $Index = [math]::Floor($Index / 26)
    }
    return $letters
}

function Xml-Escape($Value) {
    return [System.Security.SecurityElement]::Escape((Clean-Text $Value))
}

function Xlsx-Cell([string]$Ref, $Value, [int]$Style = 0) {
    $styleAttr = ""
    if ($Style -gt 0) { $styleAttr = " s=`"$Style`"" }
    if ($Value -is [int] -or $Value -is [long] -or $Value -is [double] -or $Value -is [decimal]) {
        return "<c r=`"$Ref`"$styleAttr><v>$Value</v></c>"
    }
    $text = Xml-Escape $Value
    return "<c r=`"$Ref`"$styleAttr t=`"inlineStr`"><is><t>$text</t></is></c>"
}

function Worksheet-Xml($Headers, $Rows) {
    $maxRow = [math]::Max($Rows.Count + 1, 1)
    $maxCol = [math]::Max($Headers.Count, 1)
    $lastCell = "$(Column-Letter $maxCol)$maxRow"
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    [void]$sb.Append('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">')
    [void]$sb.Append('<sheetViews><sheetView workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews>')
    [void]$sb.Append('<sheetData><row r="1">')
    for ($c = 0; $c -lt $Headers.Count; $c++) {
        [void]$sb.Append((Xlsx-Cell "$(Column-Letter ($c + 1))1" $Headers[$c] 1))
    }
    [void]$sb.Append('</row>')
    for ($r = 0; $r -lt $Rows.Count; $r++) {
        $rowNumber = $r + 2
        [void]$sb.Append("<row r=`"$rowNumber`">")
        for ($c = 0; $c -lt $Headers.Count; $c++) {
            $header = $Headers[$c]
            $prop = $Rows[$r].PSObject.Properties[$header]
            $value = ""
            if ($null -ne $prop) { $value = $prop.Value }
            [void]$sb.Append((Xlsx-Cell "$(Column-Letter ($c + 1))$rowNumber" $value))
        }
        [void]$sb.Append('</row>')
    }
    [void]$sb.Append('</sheetData>')
    [void]$sb.Append("<autoFilter ref=`"A1:$lastCell`"/>")
    [void]$sb.Append('</worksheet>')
    return $sb.ToString()
}

function Safe-SheetName([string]$Name) {
    $safe = [regex]::Replace($Name, "[\[\]\*:/\\?]", "_")
    if ($safe.Length -gt 31) { $safe = $safe.Substring(0, 31) }
    if ([string]::IsNullOrWhiteSpace($safe)) { return "Sheet" }
    return $safe
}

function Add-ZipText($Zip, [string]$EntryName, [string]$Text) {
    $entry = $Zip.CreateEntry($EntryName)
    $stream = $entry.Open()
    $writer = New-Object System.IO.StreamWriter($stream, [System.Text.UTF8Encoding]::new($false))
    $writer.Write($Text)
    $writer.Dispose()
    $stream.Dispose()
}

function Build-Xlsx($OutputFile, $Sheets) {
    $outDir = Split-Path -Parent $OutputFile
    if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
    if (Test-Path $OutputFile) { Remove-Item -LiteralPath $OutputFile -Force }

    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $sheetNames = @($Sheets.Keys | ForEach-Object { Safe-SheetName $_ })
    $sheetCount = $sheetNames.Count

    $zip = [System.IO.Compression.ZipFile]::Open($OutputFile, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        $overrides = @(
            '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>',
            '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>',
            '<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>',
            '<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>'
        )
        for ($i = 1; $i -le $sheetCount; $i++) {
            $overrides += "<Override PartName=`"/xl/worksheets/sheet$i.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml`"/>"
        }
        Add-ZipText $zip "[Content_Types].xml" ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/>' + ($overrides -join "") + '</Types>')
        Add-ZipText $zip "_rels/.rels" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/><Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/></Relationships>'
        Add-ZipText $zip "docProps/core.xml" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><dc:creator>pbix_forensics_inventory_excel.ps1</dc:creator></cp:coreProperties>'
        Add-ZipText $zip "docProps/app.xml" ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"><Application>Microsoft Excel</Application></Properties>')

        $sheetsXml = ""
        for ($i = 0; $i -lt $sheetCount; $i++) {
            $sid = $i + 1
            $sheetsXml += "<sheet name=`"$(Xml-Escape $sheetNames[$i])`" sheetId=`"$sid`" r:id=`"rId$sid`"/>"
        }
        Add-ZipText $zip "xl/workbook.xml" ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>' + $sheetsXml + '</sheets></workbook>')

        $rels = ""
        for ($i = 1; $i -le $sheetCount; $i++) {
            $rels += "<Relationship Id=`"rId$i`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet`" Target=`"worksheets/sheet$i.xml`"/>"
        }
        $styleId = $sheetCount + 1
        $rels += "<Relationship Id=`"rId$styleId`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles`" Target=`"styles.xml`"/>"
        Add-ZipText $zip "xl/_rels/workbook.xml.rels" ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' + $rels + '</Relationships>')

        Add-ZipText $zip "xl/styles.xml" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><fonts count="2"><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><name val="Calibri"/></font></fonts><fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills><borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders><cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs><cellXfs count="2"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/><xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/></cellXfs><cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles></styleSheet>'

        $index = 1
        foreach ($key in $Sheets.Keys) {
            $rows = $Sheets[$key]
            $headers = Get-Headers $rows
            Add-ZipText $zip "xl/worksheets/sheet$index.xml" (Worksheet-Xml $headers $rows)
            $index++
        }
    }
    finally {
        $zip.Dispose()
    }
}

$files = @(Get-ChildItem -Path $InputFolder -Recurse -Filter "*_forensics.json" -File)
if ($files.Count -eq 0) {
    throw "No se encontraron archivos *_forensics.json en $InputFolder"
}

$sheets = [ordered]@{
    "Resumen" = New-Object System.Collections.ArrayList
    "Inventario_Todo" = New-Object System.Collections.ArrayList
    "Columnas" = New-Object System.Collections.ArrayList
    "Tablas" = New-Object System.Collections.ArrayList
    "Medidas" = New-Object System.Collections.ArrayList
    "Relaciones" = New-Object System.Collections.ArrayList
    "Particiones" = New-Object System.Collections.ArrayList
    "Datasources" = New-Object System.Collections.ArrayList
    "Connections" = New-Object System.Collections.ArrayList
    "DataMashup" = New-Object System.Collections.ArrayList
    "ForensicsStrings" = New-Object System.Collections.ArrayList
    "Errores" = New-Object System.Collections.ArrayList
}

foreach ($file in $files) {
    try {
        $payload = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    }
    catch {
        Add-Row $sheets["Errores"] ([ordered]@{ source_json = $file.FullName; error = $_.Exception.Message })
        continue
    }

    $tom = Get-Prop $payload "tom" $null
    $tables = @(Get-Prop $tom "tables" @())
    $relationships = @(Get-Prop $tom "relationships" @())
    $measures = @(Get-Prop $tom "measures" @())
    $datasources = @(Get-Prop $tom "datasources" @())
    $datamashup = @(Get-Prop $payload "datamashup" @())
    $strings = @(Get-Prop $payload "forensics_strings" @())
    $connections = Get-Prop $payload "connections" $null

    $columnCount = 0
    $partitionCount = 0
    foreach ($table in $tables) {
        $columnCount += @(Get-Prop $table "columns" @()).Count
        $partitionCount += @(Get-Prop $table "partitions" @()).Count
    }

    $summary = [ordered]@{}
    Add-Base $summary $file $payload
    $summary["tables"] = $tables.Count
    $summary["columns"] = $columnCount
    $summary["measures"] = $measures.Count
    $summary["relationships"] = $relationships.Count
    $summary["partitions"] = $partitionCount
    $summary["datasources"] = $datasources.Count
    $summary["datamashup_items"] = $datamashup.Count
    $summary["forensics_strings"] = $strings.Count
    $summary["tom_error"] = Clean-Text (Get-Prop $payload "tom_error")
    Add-Row $sheets["Resumen"] $summary

    foreach ($table in $tables) {
        $tableName = Clean-Text (Get-Prop $table "name")
        $tableRow = [ordered]@{}
        Add-Base $tableRow $file $payload
        $tableRow["table_name"] = $tableName
        $tableRow["columns"] = @(Get-Prop $table "columns" @()).Count
        $tableRow["partitions"] = @(Get-Prop $table "partitions" @()).Count
        Add-Row $sheets["Tablas"] $tableRow

        $inv = New-InventoryRow $file $payload "table"
        $inv["table_name"] = $tableName
        $inv["object_name"] = $tableName
        $inv["object_kind"] = "table"
        Add-Row $sheets["Inventario_Todo"] $inv

        foreach ($column in @(Get-Prop $table "columns" @())) {
            $columnName = Clean-Text (Get-Prop $column "name")
            $dataType = Clean-Text (Get-Prop $column "datatype" (Get-Prop $column "dataType"))
            $hidden = Clean-Text (Get-Prop $column "hidden" (Get-Prop $column "isHidden"))
            $row = [ordered]@{}
            Add-Base $row $file $payload
            $row["table_name"] = $tableName
            $row["column_name"] = $columnName
            $row["data_type"] = $dataType
            $row["hidden"] = $hidden
            Add-Row $sheets["Columnas"] $row

            $inv = New-InventoryRow $file $payload "column"
            $inv["table_name"] = $tableName
            $inv["object_name"] = $columnName
            $inv["object_kind"] = "field"
            $inv["field_type"] = "column"
            $inv["data_type"] = $dataType
            $inv["hidden"] = $hidden
            $inv["value_json"] = Json-Text $column
            Add-Row $sheets["Inventario_Todo"] $inv
        }

        foreach ($partition in @(Get-Prop $table "partitions" @())) {
            $partitionName = Clean-Text (Get-Prop $partition "name")
            $source = Clean-Text (Get-Prop $partition "source")
            $row = [ordered]@{}
            Add-Base $row $file $payload
            $row["table_name"] = $tableName
            $row["partition_name"] = $partitionName
            $row["source"] = $source
            Add-Row $sheets["Particiones"] $row

            $inv = New-InventoryRow $file $payload "partition"
            $inv["table_name"] = $tableName
            $inv["object_name"] = $partitionName
            $inv["object_kind"] = "partition"
            $inv["source"] = $source
            $inv["value_json"] = Json-Text $partition
            Add-Row $sheets["Inventario_Todo"] $inv
        }
    }

    foreach ($measure in $measures) {
        $row = [ordered]@{}
        Add-Base $row $file $payload
        $row["table_name"] = Clean-Text (Get-Prop $measure "table")
        $row["measure_name"] = Clean-Text (Get-Prop $measure "name")
        $row["expression"] = Clean-Text (Get-Prop $measure "expression")
        Add-Row $sheets["Medidas"] $row

        $inv = New-InventoryRow $file $payload "measure"
        $inv["table_name"] = $row["table_name"]
        $inv["object_name"] = $row["measure_name"]
        $inv["object_kind"] = "measure"
        $inv["field_type"] = "measure"
        $inv["expression"] = $row["expression"]
        $inv["value_json"] = Json-Text $measure
        Add-Row $sheets["Inventario_Todo"] $inv
    }

    foreach ($rel in $relationships) {
        $row = [ordered]@{}
        Add-Base $row $file $payload
        $row["relationship_name"] = Clean-Text (Get-Prop $rel "name")
        $row["from_table"] = Clean-Text (Get-Prop $rel "fromTable")
        $row["to_table"] = Clean-Text (Get-Prop $rel "toTable")
        $row["active"] = Clean-Text (Get-Prop $rel "active")
        Add-Row $sheets["Relaciones"] $row

        $inv = New-InventoryRow $file $payload "relationship"
        $inv["object_name"] = $row["relationship_name"]
        $inv["object_kind"] = "relationship"
        $inv["from_table"] = $row["from_table"]
        $inv["to_table"] = $row["to_table"]
        $inv["active"] = $row["active"]
        $inv["value_json"] = Json-Text $rel
        Add-Row $sheets["Inventario_Todo"] $inv
    }

    foreach ($ds in $datasources) {
        $row = [ordered]@{}
        Add-Base $row $file $payload
        $row["datasource_name"] = Clean-Text (Get-Prop $ds "name")
        $row["datasource_type"] = Clean-Text (Get-Prop $ds "type")
        $row["description"] = Clean-Text (Get-Prop $ds "description")
        Add-Row $sheets["Datasources"] $row

        $inv = New-InventoryRow $file $payload "datasource"
        $inv["object_name"] = $row["datasource_name"]
        $inv["object_kind"] = "datasource"
        $inv["field_type"] = $row["datasource_type"]
        $inv["value_json"] = Json-Text $ds
        Add-Row $sheets["Inventario_Todo"] $inv
    }

    if ($null -ne $connections) {
        foreach ($prop in $connections.PSObject.Properties) {
            $row = [ordered]@{}
            Add-Base $row $file $payload
            $row["connection_property"] = $prop.Name
            $row["connection_value"] = Json-Text $prop.Value
            Add-Row $sheets["Connections"] $row

            $inv = New-InventoryRow $file $payload "connection"
            $inv["object_kind"] = "connection"
            $inv["property"] = $prop.Name
            $inv["value_json"] = Json-Text $prop.Value
            Add-Row $sheets["Inventario_Todo"] $inv
        }
    }

    $i = 0
    foreach ($item in $datamashup) {
        $i++
        $row = [ordered]@{}
        Add-Base $row $file $payload
        $row["item_number"] = $i
        $row["value_json"] = Json-Text $item
        Add-Row $sheets["DataMashup"] $row

        $inv = New-InventoryRow $file $payload "datamashup"
        $inv["object_name"] = "DataMashup $i"
        $inv["object_kind"] = "datamashup"
        $inv["value_json"] = Json-Text $item
        Add-Row $sheets["Inventario_Todo"] $inv
    }

    $i = 0
    foreach ($item in $strings) {
        $i++
        $row = [ordered]@{}
        Add-Base $row $file $payload
        $row["item_number"] = $i
        $row["value_json"] = Json-Text $item
        Add-Row $sheets["ForensicsStrings"] $row

        $inv = New-InventoryRow $file $payload "forensics_string"
        $inv["object_name"] = "Forensics string $i"
        $inv["object_kind"] = "string_match"
        $inv["value_json"] = Json-Text $item
        Add-Row $sheets["Inventario_Todo"] $inv
    }
}

Build-Xlsx $OutputFile $sheets

Write-Host "JSON forensics encontrados: $($files.Count)"
Write-Host "PBIX procesados: $($sheets["Resumen"].Count)"
Write-Host "Filas Inventario_Todo: $($sheets["Inventario_Todo"].Count)"
Write-Host "Excel generado: $OutputFile"
