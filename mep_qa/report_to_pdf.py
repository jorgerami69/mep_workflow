#!/usr/bin/env python3
"""
Convert qa_report.md to professionally formatted PDF via Playwright (Chromium).

Uses Markdown -> HTML -> Chromium PDF with full CSS page-break control:
- Headings never orphaned from their content
- Tables never split mid-row
- Proper headers/footers with page numbers

Usage:
    python3 mep_qa/report_to_pdf.py --input qa_reports/MEP_X/qa_report.md
    python3 mep_qa/report_to_pdf.py --input-dir qa_reports/
"""

import argparse
from pathlib import Path

import markdown
from playwright.sync_api import sync_playwright

CSS = """
@page {
    size: A4;
    margin: 20mm 22mm 25mm 22mm;
}

body {
    font-family: 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
    font-size: 9.5pt;
    line-height: 1.55;
    color: #1a1a1a;
    max-width: 100%;
}

/* ── Headings with page-break control ── */

h1 {
    font-size: 20pt;
    color: #0d1b2a;
    border-bottom: 3px solid #1b4965;
    padding-bottom: 6px;
    margin: 0 0 12px 0;
    page-break-after: avoid;
}

h2 {
    font-size: 13pt;
    color: #1b4965;
    border-bottom: 1.5px solid #bee9e8;
    padding-bottom: 4px;
    margin: 22px 0 8px 0;
    page-break-after: avoid;   /* heading stays with content */
    break-after: avoid;
}

h3 {
    font-size: 11pt;
    color: #2c6975;
    margin: 16px 0 6px 0;
    page-break-after: avoid;
    break-after: avoid;
}

h4 {
    font-size: 10pt;
    color: #444;
    margin: 12px 0 4px 0;
    page-break-after: avoid;
    break-after: avoid;
}

/* Force headings to pull at least 3 lines of content with them */
h2 + *, h3 + *, h4 + * {
    page-break-before: avoid;
    break-before: avoid;
}

/* ── Tables with page-break control ── */

table {
    width: 100%;
    border-collapse: collapse;
    margin: 8px 0 14px 0;
    font-size: 8.5pt;
    page-break-inside: auto;   /* allow table to span pages */
}

thead {
    display: table-header-group; /* repeat header on each page */
}

tbody {
    display: table-row-group;
}

tr {
    page-break-inside: avoid;  /* never split a row */
    break-inside: avoid;
}

th {
    background-color: #1b4965;
    color: white;
    padding: 5px 7px;
    text-align: left;
    font-weight: 600;
    font-size: 8pt;
    text-transform: uppercase;
    letter-spacing: 0.3px;
    border: 1px solid #15384f;
}

td {
    padding: 4px 7px;
    border: 1px solid #dde1e5;
    vertical-align: top;
    word-wrap: break-word;
    max-width: 250px;
}

tr:nth-child(even) td {
    background-color: #f7f8fa;
}

/* Small tables (< 6 rows) should never split */
table:has(tr:nth-child(6):last-child) {
    page-break-inside: avoid;
    break-inside: avoid;
}

/* ── Status color coding ── */

td {
    color: #1a1a1a;
}

/* Color coding via content matching (post-processed in HTML) */
.status-fail {
    color: #c0392b;
    font-weight: 700;
}
.status-warn {
    color: #d35400;
    font-weight: 600;
}
.status-ok {
    color: #27ae60;
    font-weight: 600;
}
.status-na {
    color: #7f8c8d;
    font-style: italic;
}
.status-pending {
    color: #8e44ad;
}

/* Score/grade emphasis */
td strong, th strong {
    color: #1b4965;
}

/* ── Code ── */

code {
    background-color: #f0f2f5;
    padding: 1px 4px;
    border-radius: 3px;
    font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;
    font-size: 8pt;
    color: #c0392b;
}

pre {
    background-color: #f5f6f8;
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 10px 12px;
    font-size: 7.5pt;
    overflow-wrap: break-word;
    white-space: pre-wrap;
    page-break-inside: avoid;
    break-inside: avoid;
}

/* ── Lists ── */

ul, ol {
    padding-left: 18px;
    margin: 4px 0;
}

li {
    margin-bottom: 2px;
    page-break-inside: avoid;
}

/* ── Blockquotes ── */

blockquote {
    border-left: 3px solid #1b4965;
    margin: 8px 0;
    padding: 6px 14px;
    background-color: #f0f7ff;
    font-style: italic;
    color: #333;
    page-break-inside: avoid;
}

/* ── Other ── */

p {
    margin: 5px 0;
    orphans: 3;    /* min lines at bottom of page */
    widows: 3;     /* min lines at top of page */
}

hr {
    border: none;
    border-top: 1px solid #ccc;
    margin: 16px 0;
}

strong {
    color: #1b4965;
}

/* ── Header/Footer (via running elements) ── */

.page-header {
    position: running(header);
    font-size: 7pt;
    color: #999;
    text-align: right;
    padding-bottom: 4px;
    border-bottom: 0.5px solid #ddd;
}

.page-footer {
    position: running(footer);
    font-size: 7pt;
    color: #999;
    text-align: center;
}

@page {
    @top-right {
        content: element(header);
    }
    @bottom-center {
        content: element(footer);
    }
}

/* ── Section break control ── */

/* Each h2 section wrapped in <section class="report-section"> */
section.report-section {
    page-break-before: auto;
    page-break-inside: auto;
}

/* Subsections (h3/h4 + content) should not split */
div.subsection {
    page-break-inside: avoid;
    break-inside: avoid;
}

/* If a section has very little content, don't split it */
section.report-section:has(> :nth-child(-n+4):last-child) {
    page-break-inside: avoid;
    break-inside: avoid;
}

/* Sections 1-10 should start cleanly */
h2:not(:first-of-type) {
    margin-top: 28px;
}

/* The score table and info table should never split */
h2 + table {
    page-break-inside: avoid;
    break-inside: avoid;
}

/* Bold subtitles (like "Observaciones de seguridad:") must stay with content */
p > strong:only-child {
    page-break-after: avoid;
    break-after: avoid;
}

/* A bold line followed by a list should stay together */
p:has(> strong:only-child) {
    page-break-after: avoid;
    break-after: avoid;
}
p:has(> strong:only-child) + ul,
p:has(> strong:only-child) + ol {
    page-break-before: avoid;
    break-before: avoid;
}

/* HR should prefer to be at the bottom of a page, not top */
hr {
    page-break-after: avoid;
    break-after: avoid;
}
"""


def colorize_status_cells(html: str) -> str:
    """Post-process HTML to add color classes to status values in table cells."""
    import re

    # Match td cells with exact status values
    replacements = [
        (r"<td>\s*(FAIL|QA-Failed|RECHAZADO)\s*</td>", r'<td class="status-fail">\1</td>'),
        (r"<td>\s*(WARN)\s*</td>", r'<td class="status-warn">\1</td>'),
        (r"<td>\s*(OK|PASS|Accepted|Aprobado[^<]*)</td>", r'<td class="status-ok">\1</td>'),
        (r"<td>\s*(N/A|SKIP)\s*</td>", r'<td class="status-na">\1</td>'),
        (r"<td>\s*(Pendiente)\s*</td>", r'<td class="status-pending">\1</td>'),
        (r"<td>\s*(Critica|Cr[ií]tica)\s*</td>", r'<td class="status-fail">\1</td>'),
        (r"<td>\s*(Alta)\s*</td>", r'<td class="status-warn">\1</td>'),
        (r"<td>\s*(Baja|Ninguna)\s*</td>", r'<td class="status-na">\1</td>'),
    ]

    for pattern, replacement in replacements:
        html = re.sub(pattern, replacement, html, flags=re.IGNORECASE)

    return html


def wrap_sections(html: str) -> str:
    """Wrap each h2 section in a <section> tag for page-break control.

    Also wraps h3/h4 with their following content in a <div class="subsection">
    so headings are never orphaned from their content.
    """
    import re

    # Step 1: Wrap h3/h4 + following content in subsection divs
    # Match h3/h4 followed by content until next h2/h3/h4 or end
    html = re.sub(
        r'(<h[34][^>]*>.*?</h[34]>)',
        r'</div>\n<div class="subsection">\1',
        html,
    )

    # Step 2: Wrap each h2 section
    # Split by h2 tags, wrap each chunk
    parts = re.split(r'(<h2[^>]*>)', html)
    result = parts[0]  # content before first h2

    i = 1
    while i < len(parts):
        if parts[i].startswith('<h2'):
            # Close previous section, open new one
            content = parts[i + 1] if i + 1 < len(parts) else ""
            result += f'<section class="report-section">{parts[i]}{content}</section>\n'
            i += 2
        else:
            result += parts[i]
            i += 1

    # Clean up empty/orphaned divs
    result = result.replace('<div class="subsection"></div>', '')
    result = re.sub(r'</div>\s*<div class="subsection">', '<div class="subsection">', result, count=1)

    return result


def md_to_pdf(md_path: Path, output_path: Path = None):
    """Convert Markdown to PDF via Playwright Chromium."""
    if output_path is None:
        output_path = md_path.with_suffix(".pdf")

    md_content = md_path.read_text(encoding="utf-8")

    # Convert markdown to HTML
    html_body = markdown.markdown(
        md_content,
        extensions=["tables", "fenced_code", "toc", "nl2br", "sane_lists"],
    )

    # Post-process: color status cells, wrap sections
    html_body = colorize_status_cells(html_body)
    html_body = wrap_sections(html_body)

    full_html = f"""<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title>{md_path.stem}</title>
    <style>{CSS}</style>
</head>
<body>
    <div class="page-header">Assessment 360° — Integratel Peru | Confidencial — Stefanini Group</div>
    {html_body}
</body>
</html>"""

    # Write temp HTML for Chromium
    tmp_html = md_path.with_suffix(".tmp.html")
    tmp_html.write_text(full_html, encoding="utf-8")

    try:
        with sync_playwright() as p:
            browser = p.chromium.launch()
            page = browser.new_page()
            page.goto(f"file://{tmp_html.resolve()}")
            page.pdf(
                path=str(output_path),
                format="A4",
                margin={
                    "top": "20mm",
                    "bottom": "25mm",
                    "left": "22mm",
                    "right": "22mm",
                },
                display_header_footer=True,
                header_template="""
                    <div style="font-size:7pt; color:#999; width:100%; text-align:right; padding-right:22mm;">
                        Assessment 360° — Integratel Peru | Confidencial — Stefanini Group
                    </div>
                """,
                footer_template="""
                    <div style="font-size:7pt; color:#999; width:100%; text-align:center;">
                        Pagina <span class="pageNumber"></span> de <span class="totalPages"></span>
                    </div>
                """,
                print_background=True,
            )
            browser.close()
    finally:
        tmp_html.unlink(missing_ok=True)

    size_kb = output_path.stat().st_size // 1024
    print(f"[PDF] {output_path} ({size_kb} KB)")
    return output_path


def main():
    parser = argparse.ArgumentParser(description="Convert QA reports to PDF")
    parser.add_argument("--input", help="Single .md file to convert")
    parser.add_argument("--input-dir", help="Directory with MEP reports (converts all)")
    args = parser.parse_args()

    if args.input:
        md_to_pdf(Path(args.input))
    elif args.input_dir:
        base = Path(args.input_dir)
        # Use a single Playwright browser instance for all conversions
        files_to_convert = sorted(base.rglob("qa_report*.md"))
        dashboard = base / "dashboard.md"
        if dashboard.exists():
            files_to_convert.append(dashboard)

        if not files_to_convert:
            print("No .md files found")
            return

        with sync_playwright() as p:
            browser = p.chromium.launch()

            for md_file in files_to_convert:
                output_path = md_file.with_suffix(".pdf")
                md_content = md_file.read_text(encoding="utf-8")

                html_body = markdown.markdown(
                    md_content,
                    extensions=["tables", "fenced_code", "toc", "nl2br", "sane_lists"],
                )
                html_body = colorize_status_cells(html_body)

                full_html = f"""<!DOCTYPE html>
<html lang="es">
<head><meta charset="utf-8"><title>{md_file.stem}</title><style>{CSS}</style></head>
<body>{html_body}</body>
</html>"""

                tmp_html = md_file.with_suffix(".tmp.html")
                tmp_html.write_text(full_html, encoding="utf-8")

                try:
                    page = browser.new_page()
                    page.goto(f"file://{tmp_html.resolve()}")
                    page.pdf(
                        path=str(output_path),
                        format="A4",
                        margin={"top": "20mm", "bottom": "25mm", "left": "22mm", "right": "22mm"},
                        display_header_footer=True,
                        header_template='<div style="font-size:7pt;color:#999;width:100%;text-align:right;padding-right:22mm;">Assessment 360° — Integratel Peru | Confidencial — Stefanini Group</div>',
                        footer_template='<div style="font-size:7pt;color:#999;width:100%;text-align:center;">Pagina <span class="pageNumber"></span> de <span class="totalPages"></span></div>',
                        print_background=True,
                    )
                    page.close()
                    size_kb = output_path.stat().st_size // 1024
                    print(f"[PDF] {output_path} ({size_kb} KB)")
                finally:
                    tmp_html.unlink(missing_ok=True)

            browser.close()
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
