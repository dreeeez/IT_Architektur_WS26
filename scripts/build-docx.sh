#!/usr/bin/env bash
# Baut aus den arc42-Markdown-Kapiteln ein Word-Dokument.
# Nutzung:  ./scripts/build-docx.sh        → alle 12 Kapitel (PL 2)
#           ./scripts/build-docx.sh 4      → nur Kapitel 1–4 (PL 1)
# Voraussetzung: pandoc (brew install pandoc)
set -euo pipefail

cd "$(dirname "$0")/.."
command -v pandoc >/dev/null || { echo "pandoc fehlt: brew install pandoc" >&2; exit 1; }

bis="${1:-12}"
files=()
for f in docs/arc42/[0-9][0-9]_*.md; do
  nr=$((10#$(basename "$f" | cut -c1-2)))
  (( nr <= bis )) && files+=("$f")
done

mkdir -p build-out
out="build-out/arc42_Kapitel_1-${bis}.docx"
ref=()
[[ -f docs/vorlage.docx ]] && ref=(--reference-doc=docs/vorlage.docx)

# ${ref[@]+...}: leeres Array ist unter macOS-Bash 3.2 mit "set -u" sonst ein Fehler
# --columns=9999: keine festen Spaltenbreiten aus den Markdown-Tabellen, Breite passt sich dem Inhalt an
pandoc "${files[@]}" -o "$out" --toc --columns=9999 --resource-path=docs/arc42:docs \
  --metadata title="Digitaler Produktpass – Architekturdokumentation (arc42)" \
  --metadata subtitle="VoltCell GmbH · IT-Architektur WS 2026/27 · HdM Stuttgart" \
  --metadata lang=de-DE --metadata toc-title="Inhalt" \
  ${ref[@]+"${ref[@]}"}
echo "Erstellt: $out"
