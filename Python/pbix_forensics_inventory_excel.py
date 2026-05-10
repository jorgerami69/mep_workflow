import argparse
import csv
import datetime as dt
import html
import json
import os
import re
import zipfile
from collections import OrderedDict
from pathlib import Path
from xml.etree import ElementTree as ET


DEFAULT_INPUT_FOLDER = r"C:\data\workspace\PbixMetadataOut"
DEFAULT_OUTPUT_FILE = r"C:\data\workspace\pbix_forensics_inventory.xlsx"


INVALID_XML_RE = re.compile(
    r"[\x00-\x08\x0B\x0C\x0E-\x1F]"
)


def clean_text(value):
    if value is None:
        return ""
    if isinstance(value, bool):
        return "TRUE" if value else "FALSE"
    if isinstance(value, (int, float)):
        return value
    if isinstance(value, (dict, list)):
        value = json.dumps(value, ensure_ascii=False, sort_keys=True)
    return INVALID_XML_RE.sub("", str(value))


def json_text(value):
    if value in (None, "", [], {}):
        return ""
    return clean_text(json.dumps(value, ensure_ascii=False, sort_keys=True))


def safe_sheet_name(name):
    name = re.sub(r"[\[\]\*:/\\?]", "_", name)
    return name[:31] or "Sheet"


def find_forensics_json(input_folder):
    root = Path(input_folder)
    return sorted(
        root.rglob("*_forensics.json"),
        key=lambda p: str(p).lower()
    )


def load_json(path):
    with open(path, "r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def add_base(row, json_path, payload):
    report_folder = json_path.parent.name
    row["pbix"] = payload.get("pbix", "")
    row["pbix_type"] = payload.get("type", "")
    row["report_folder"] = report_folder
    row["source_json"] = str(json_path)
    return row


def split_known_extra(item, known_keys):
    extra = OrderedDict()
    for key, value in item.items():
        if key not in known_keys:
            extra[key] = value
    return extra


def make_inventory_row(json_path, payload, artifact_type, **fields):
    row = OrderedDict()
    add_base(row, json_path, payload)
    row["artifact_type"] = artifact_type
    row["table_name"] = fields.get("table_name", "")
    row["object_name"] = fields.get("object_name", "")
    row["object_kind"] = fields.get("object_kind", "")
    row["field_type"] = fields.get("field_type", "")
    row["data_type"] = fields.get("data_type", "")
    row["hidden"] = fields.get("hidden", "")
    row["active"] = fields.get("active", "")
    row["expression"] = fields.get("expression", "")
    row["source"] = fields.get("source", "")
    row["from_table"] = fields.get("from_table", "")
    row["to_table"] = fields.get("to_table", "")
    row["property"] = fields.get("property", "")
    row["value_json"] = fields.get("value_json", "")
    return row


def collect_rows(forensics_files):
    sheets = {
        "Resumen": [],
        "Inventario_Todo": [],
        "Columnas": [],
        "Tablas": [],
        "Medidas": [],
        "Relaciones": [],
        "Particiones": [],
        "Datasources": [],
        "Connections": [],
        "DataMashup": [],
        "ForensicsStrings": [],
        "Errores": [],
    }

    for json_path in forensics_files:
        try:
            payload = load_json(json_path)
        except Exception as exc:
            sheets["Errores"].append(OrderedDict([
                ("source_json", str(json_path)),
                ("error", str(exc)),
            ]))
            continue

        tom = payload.get("tom") or {}
        tables = tom.get("tables") or []
        relationships = tom.get("relationships") or []
        measures = tom.get("measures") or []
        datasources = tom.get("datasources") or []
        datamashup = payload.get("datamashup") or []
        forensics_strings = payload.get("forensics_strings") or []
        connections = payload.get("connections") or {}

        column_count = sum(len(table.get("columns") or []) for table in tables)
        partition_count = sum(len(table.get("partitions") or []) for table in tables)

        summary = OrderedDict()
        add_base(summary, json_path, payload)
        summary["tables"] = len(tables)
        summary["columns"] = column_count
        summary["measures"] = len(measures)
        summary["relationships"] = len(relationships)
        summary["partitions"] = partition_count
        summary["datasources"] = len(datasources)
        summary["datamashup_items"] = len(datamashup)
        summary["forensics_strings"] = len(forensics_strings)
        summary["tom_error"] = payload.get("tom_error", "") or tom.get("error", "")
        summary["tom_warning"] = tom.get("warning", "") or tom.get("datasource_warning", "")
        sheets["Resumen"].append(summary)

        if payload.get("tom_error"):
            error_row = OrderedDict()
            add_base(error_row, json_path, payload)
            error_row["scope"] = "tom_error"
            error_row["error"] = payload.get("tom_error")
            sheets["Errores"].append(error_row)
        if tom.get("error"):
            error_row = OrderedDict()
            add_base(error_row, json_path, payload)
            error_row["scope"] = "tom.error"
            error_row["error"] = tom.get("error")
            sheets["Errores"].append(error_row)

        for table in tables:
            table_name = table.get("name", "")
            table_known = {"name", "columns", "partitions"}
            table_row = OrderedDict()
            add_base(table_row, json_path, payload)
            table_row["table_name"] = table_name
            table_row["columns"] = len(table.get("columns") or [])
            table_row["partitions"] = len(table.get("partitions") or [])
            table_row["extra_json"] = json_text(split_known_extra(table, table_known))
            sheets["Tablas"].append(table_row)
            sheets["Inventario_Todo"].append(
                make_inventory_row(
                    json_path,
                    payload,
                    "table",
                    table_name=table_name,
                    object_name=table_name,
                    object_kind="table",
                    value_json=json_text(split_known_extra(table, table_known)),
                )
            )

            for column in table.get("columns") or []:
                column_known = {"name", "datatype", "dataType", "hidden", "isHidden"}
                data_type = column.get("datatype", column.get("dataType", ""))
                hidden = column.get("hidden", column.get("isHidden", ""))
                col_row = OrderedDict()
                add_base(col_row, json_path, payload)
                col_row["table_name"] = table_name
                col_row["column_name"] = column.get("name", "")
                col_row["data_type"] = data_type
                col_row["hidden"] = hidden
                col_row["extra_json"] = json_text(split_known_extra(column, column_known))
                sheets["Columnas"].append(col_row)
                sheets["Inventario_Todo"].append(
                    make_inventory_row(
                        json_path,
                        payload,
                        "column",
                        table_name=table_name,
                        object_name=column.get("name", ""),
                        object_kind="field",
                        field_type="column",
                        data_type=data_type,
                        hidden=hidden,
                        value_json=json_text(split_known_extra(column, column_known)),
                    )
                )

            for partition in table.get("partitions") or []:
                part_known = {"name", "source"}
                part_row = OrderedDict()
                add_base(part_row, json_path, payload)
                part_row["table_name"] = table_name
                part_row["partition_name"] = partition.get("name", "")
                part_row["source"] = partition.get("source", "")
                part_row["extra_json"] = json_text(split_known_extra(partition, part_known))
                sheets["Particiones"].append(part_row)
                sheets["Inventario_Todo"].append(
                    make_inventory_row(
                        json_path,
                        payload,
                        "partition",
                        table_name=table_name,
                        object_name=partition.get("name", ""),
                        object_kind="partition",
                        source=partition.get("source", ""),
                        value_json=json_text(split_known_extra(partition, part_known)),
                    )
                )

        for measure in measures:
            measure_known = {"table", "name", "expression"}
            measure_row = OrderedDict()
            add_base(measure_row, json_path, payload)
            measure_row["table_name"] = measure.get("table", "")
            measure_row["measure_name"] = measure.get("name", "")
            measure_row["expression"] = measure.get("expression", "")
            measure_row["extra_json"] = json_text(split_known_extra(measure, measure_known))
            sheets["Medidas"].append(measure_row)
            sheets["Inventario_Todo"].append(
                make_inventory_row(
                    json_path,
                    payload,
                    "measure",
                    table_name=measure.get("table", ""),
                    object_name=measure.get("name", ""),
                    object_kind="measure",
                    field_type="measure",
                    expression=measure.get("expression", ""),
                    value_json=json_text(split_known_extra(measure, measure_known)),
                )
            )

        for relationship in relationships:
            rel_known = {"name", "fromTable", "toTable", "active"}
            rel_row = OrderedDict()
            add_base(rel_row, json_path, payload)
            rel_row["relationship_name"] = relationship.get("name", "")
            rel_row["from_table"] = relationship.get("fromTable", "")
            rel_row["to_table"] = relationship.get("toTable", "")
            rel_row["active"] = relationship.get("active", "")
            rel_row["extra_json"] = json_text(split_known_extra(relationship, rel_known))
            sheets["Relaciones"].append(rel_row)
            sheets["Inventario_Todo"].append(
                make_inventory_row(
                    json_path,
                    payload,
                    "relationship",
                    object_name=relationship.get("name", ""),
                    object_kind="relationship",
                    active=relationship.get("active", ""),
                    from_table=relationship.get("fromTable", ""),
                    to_table=relationship.get("toTable", ""),
                    value_json=json_text(split_known_extra(relationship, rel_known)),
                )
            )

        for datasource in datasources:
            ds_known = {"name", "type", "description"}
            ds_row = OrderedDict()
            add_base(ds_row, json_path, payload)
            ds_row["datasource_name"] = datasource.get("name", "")
            ds_row["datasource_type"] = datasource.get("type", "")
            ds_row["description"] = datasource.get("description", "")
            ds_row["extra_json"] = json_text(split_known_extra(datasource, ds_known))
            sheets["Datasources"].append(ds_row)
            sheets["Inventario_Todo"].append(
                make_inventory_row(
                    json_path,
                    payload,
                    "datasource",
                    object_name=datasource.get("name", ""),
                    object_kind="datasource",
                    field_type=datasource.get("type", ""),
                    value_json=json_text(datasource),
                )
            )

        for key, value in connections.items():
            conn_row = OrderedDict()
            add_base(conn_row, json_path, payload)
            conn_row["connection_property"] = key
            conn_row["connection_value"] = json_text(value) if isinstance(value, (dict, list)) else clean_text(value)
            sheets["Connections"].append(conn_row)
            sheets["Inventario_Todo"].append(
                make_inventory_row(
                    json_path,
                    payload,
                    "connection",
                    object_kind="connection",
                    property=key,
                    value_json=json_text(value) if isinstance(value, (dict, list)) else clean_text(value),
                )
            )

        for index, item in enumerate(datamashup, start=1):
            mashup_row = OrderedDict()
            add_base(mashup_row, json_path, payload)
            mashup_row["item_number"] = index
            if isinstance(item, dict):
                for key, value in item.items():
                    mashup_row[key] = json_text(value) if isinstance(value, (dict, list)) else clean_text(value)
                value_for_inventory = json_text(item)
            else:
                mashup_row["value"] = clean_text(item)
                value_for_inventory = clean_text(item)
            sheets["DataMashup"].append(mashup_row)
            sheets["Inventario_Todo"].append(
                make_inventory_row(
                    json_path,
                    payload,
                    "datamashup",
                    object_name=f"DataMashup {index}",
                    object_kind="datamashup",
                    value_json=value_for_inventory,
                )
            )

        for index, item in enumerate(forensics_strings, start=1):
            fs_row = OrderedDict()
            add_base(fs_row, json_path, payload)
            fs_row["item_number"] = index
            if isinstance(item, dict):
                for key, value in item.items():
                    fs_row[key] = json_text(value) if isinstance(value, (dict, list)) else clean_text(value)
                value_for_inventory = json_text(item)
            else:
                fs_row["match"] = clean_text(item)
                value_for_inventory = clean_text(item)
            sheets["ForensicsStrings"].append(fs_row)
            sheets["Inventario_Todo"].append(
                make_inventory_row(
                    json_path,
                    payload,
                    "forensics_string",
                    object_name=f"Forensics string {index}",
                    object_kind="string_match",
                    value_json=value_for_inventory,
                )
            )

    return sheets


def ordered_headers(rows):
    headers = []
    seen = set()
    for row in rows:
        for key in row.keys():
            if key not in seen:
                headers.append(key)
                seen.add(key)
    return headers


def column_letter(index):
    letters = ""
    while index:
        index, remainder = divmod(index - 1, 26)
        letters = chr(65 + remainder) + letters
    return letters


def xlsx_cell(ref, value, style=None):
    attrs = {"r": ref}
    if style:
        attrs["s"] = str(style)
    if isinstance(value, bool):
        return f'<c r="{ref}" t="b"><v>{1 if value else 0}</v></c>'
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return f'<c r="{ref}"><v>{value}</v></c>'
    text = html.escape(clean_text(value), quote=False)
    return (
        f'<c {" ".join(f"{k}=\"{v}\"" for k, v in attrs.items())} t="inlineStr">'
        f"<is><t>{text}</t></is></c>"
    )


def worksheet_xml(headers, rows):
    max_row = max(len(rows) + 1, 1)
    max_col = max(len(headers), 1)
    last_cell = f"{column_letter(max_col)}{max_row}"
    xml = [
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
        'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">',
        '<sheetViews><sheetView workbookViewId="0"><pane ySplit="1" topLeftCell="A2" '
        'activePane="bottomLeft" state="frozen"/></sheetView></sheetViews>',
        "<sheetFormatPr defaultRowHeight=\"15\"/>",
        "<sheetData>",
    ]
    xml.append('<row r="1">')
    for col_idx, header in enumerate(headers, start=1):
        xml.append(xlsx_cell(f"{column_letter(col_idx)}1", header, style=1))
    xml.append("</row>")
    for row_idx, row in enumerate(rows, start=2):
        xml.append(f'<row r="{row_idx}">')
        for col_idx, header in enumerate(headers, start=1):
            xml.append(xlsx_cell(f"{column_letter(col_idx)}{row_idx}", row.get(header, "")))
        xml.append("</row>")
    xml.append("</sheetData>")
    if headers:
        xml.append(f'<autoFilter ref="A1:{last_cell}"/>')
    xml.append("</worksheet>")
    return "".join(xml).encode("utf-8")


def build_xlsx(output_file, sheets):
    output_path = Path(output_file)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    used_sheet_names = set()
    sheet_items = []
    for name, rows in sheets.items():
        sheet_name = safe_sheet_name(name)
        base_name = sheet_name
        counter = 1
        while sheet_name.lower() in used_sheet_names:
            suffix = f"_{counter}"
            sheet_name = f"{base_name[:31 - len(suffix)]}{suffix}"
            counter += 1
        used_sheet_names.add(sheet_name.lower())
        sheet_items.append((sheet_name, rows))

    now = dt.datetime.utcnow().replace(microsecond=0).isoformat() + "Z"

    with zipfile.ZipFile(output_path, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.writestr("[Content_Types].xml", content_types_xml(len(sheet_items)))
        zf.writestr("_rels/.rels", root_rels_xml())
        zf.writestr("docProps/core.xml", core_xml(now))
        zf.writestr("docProps/app.xml", app_xml([name for name, _ in sheet_items]))
        zf.writestr("xl/workbook.xml", workbook_xml([name for name, _ in sheet_items]))
        zf.writestr("xl/_rels/workbook.xml.rels", workbook_rels_xml(len(sheet_items)))
        zf.writestr("xl/styles.xml", styles_xml())
        for index, (_, rows) in enumerate(sheet_items, start=1):
            headers = ordered_headers(rows)
            if not headers:
                headers = ["sin_datos"]
                rows = []
            zf.writestr(f"xl/worksheets/sheet{index}.xml", worksheet_xml(headers, rows))


def content_types_xml(sheet_count):
    overrides = [
        '<Override PartName="/xl/workbook.xml" '
        'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>',
        '<Override PartName="/xl/styles.xml" '
        'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>',
        '<Override PartName="/docProps/core.xml" '
        'ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>',
        '<Override PartName="/docProps/app.xml" '
        'ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>',
    ]
    for index in range(1, sheet_count + 1):
        overrides.append(
            f'<Override PartName="/xl/worksheets/sheet{index}.xml" '
            'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
        )
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
        '<Default Extension="xml" ContentType="application/xml"/>'
        + "".join(overrides)
        + "</Types>"
    )


def root_rels_xml():
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" '
        'Target="xl/workbook.xml"/>'
        '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" '
        'Target="docProps/core.xml"/>'
        '<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" '
        'Target="docProps/app.xml"/>'
        "</Relationships>"
    )


def core_xml(created_at):
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" '
        'xmlns:dc="http://purl.org/dc/elements/1.1/" '
        'xmlns:dcterms="http://purl.org/dc/terms/" '
        'xmlns:dcmitype="http://purl.org/dc/dcmitype/" '
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        "<dc:creator>pbix_forensics_inventory_excel.py</dc:creator>"
        "<cp:lastModifiedBy>pbix_forensics_inventory_excel.py</cp:lastModifiedBy>"
        f'<dcterms:created xsi:type="dcterms:W3CDTF">{created_at}</dcterms:created>'
        f'<dcterms:modified xsi:type="dcterms:W3CDTF">{created_at}</dcterms:modified>'
        "</cp:coreProperties>"
    )


def app_xml(sheet_names):
    vector = "".join(f"<vt:lpstr>{html.escape(name)}</vt:lpstr>" for name in sheet_names)
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" '
        'xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">'
        "<Application>Microsoft Excel</Application>"
        "<HeadingPairs><vt:vector size=\"2\" baseType=\"variant\">"
        "<vt:variant><vt:lpstr>Worksheets</vt:lpstr></vt:variant>"
        f"<vt:variant><vt:i4>{len(sheet_names)}</vt:i4></vt:variant>"
        "</vt:vector></HeadingPairs>"
        f'<TitlesOfParts><vt:vector size="{len(sheet_names)}" baseType="lpstr">{vector}</vt:vector></TitlesOfParts>'
        "</Properties>"
    )


def workbook_xml(sheet_names):
    sheets_xml = []
    for index, name in enumerate(sheet_names, start=1):
        sheets_xml.append(
            f'<sheet name="{html.escape(name)}" sheetId="{index}" r:id="rId{index}"/>'
        )
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
        'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
        "<sheets>"
        + "".join(sheets_xml)
        + "</sheets></workbook>"
    )


def workbook_rels_xml(sheet_count):
    rels = []
    for index in range(1, sheet_count + 1):
        rels.append(
            f'<Relationship Id="rId{index}" '
            'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" '
            f'Target="worksheets/sheet{index}.xml"/>'
        )
    rels.append(
        f'<Relationship Id="rId{sheet_count + 1}" '
        'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" '
        'Target="styles.xml"/>'
    )
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        + "".join(rels)
        + "</Relationships>"
    )


def styles_xml():
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
        '<fonts count="2"><font><sz val="11"/><name val="Calibri"/></font>'
        '<font><b/><sz val="11"/><name val="Calibri"/></font></fonts>'
        '<fills count="2"><fill><patternFill patternType="none"/></fill>'
        '<fill><patternFill patternType="gray125"/></fill></fills>'
        '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'
        '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
        '<cellXfs count="2"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
        '<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/></cellXfs>'
        '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>'
        "</styleSheet>"
    )


def write_csv_backup(output_file, sheets):
    output_dir = Path(output_file).with_suffix("")
    output_dir.mkdir(parents=True, exist_ok=True)
    for sheet_name, rows in sheets.items():
        headers = ordered_headers(rows)
        csv_path = output_dir / f"{safe_sheet_name(sheet_name)}.csv"
        with open(csv_path, "w", encoding="utf-8-sig", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=headers or ["sin_datos"], extrasaction="ignore")
            writer.writeheader()
            writer.writerows(rows)
    return output_dir


def validate_xlsx(path):
    with zipfile.ZipFile(path, "r") as zf:
        required = ["[Content_Types].xml", "xl/workbook.xml", "xl/styles.xml"]
        for name in required:
            if name not in zf.namelist():
                raise RuntimeError(f"No se encontro {name} en el XLSX.")
        ET.fromstring(zf.read("xl/workbook.xml"))


def main():
    parser = argparse.ArgumentParser(
        description="Consolida los *_forensics.json de Power BI en un inventario Excel."
    )
    parser.add_argument(
        "--input",
        default=DEFAULT_INPUT_FOLDER,
        help=f"Carpeta raiz con los JSON forensics. Default: {DEFAULT_INPUT_FOLDER}",
    )
    parser.add_argument(
        "--output",
        default=DEFAULT_OUTPUT_FILE,
        help=f"Archivo XLSX de salida. Default: {DEFAULT_OUTPUT_FILE}",
    )
    parser.add_argument(
        "--csv-backup",
        action="store_true",
        help="Tambien genera una carpeta con CSV por cada hoja.",
    )
    args = parser.parse_args()

    files = find_forensics_json(args.input)
    if not files:
        raise SystemExit(f"No se encontraron archivos *_forensics.json en: {args.input}")

    print(f"JSON forensics encontrados: {len(files)}")
    sheets = collect_rows(files)
    build_xlsx(args.output, sheets)
    validate_xlsx(args.output)
    print(f"Excel generado: {args.output}")
    print(f"Filas inventario total: {len(sheets['Inventario_Todo'])}")
    print(f"PBIX procesados: {len(sheets['Resumen'])}")

    if args.csv_backup:
        csv_dir = write_csv_backup(args.output, sheets)
        print(f"CSV backup generado en: {csv_dir}")


if __name__ == "__main__":
    main()
