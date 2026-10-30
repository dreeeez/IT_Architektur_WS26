#!/usr/bin/env bash
# Baut aus den arc42-Markdown-Kapiteln ein PDF (pandoc → HTML → Chrome-Druck), Stil: scripts/pdf.css
# Nutzung:  ./scripts/build-pdf.sh        → alle 12 Kapitel
#           ./scripts/build-pdf.sh 4      → nur Kapitel 1–4
# Voraussetzung: pandoc (brew install pandoc), Google Chrome
set -euo pipefail

cd "$(dirname "$0")/.."
command -v pandoc >/dev/null || { echo "pandoc fehlt: brew install pandoc" >&2; exit 1; }
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[[ -x "$chrome" ]] || { echo "Google Chrome nicht gefunden" >&2; exit 1; }

bis="${1:-12}"
files=()
for f in docs/arc42/[0-9][0-9]_*.md; do
  nr=$((10#$(basename "$f" | cut -c1-2)))
  (( nr <= bis )) && files+=("$f")
done

mkdir -p build-out
html="build-out/arc42_Kapitel_1-${bis}.html"
out="build-out/arc42_Kapitel_1-${bis}.pdf"

# --columns=9999: keine festen Spaltenbreiten aus den Markdown-Tabellen, Breite passt sich dem Inhalt an
pandoc "${files[@]}" -s -o "$html" --toc --toc-depth=2 \
  --columns=9999 --resource-path=docs/arc42:docs --embed-resources --css=scripts/pdf.css \
  --metadata title="Digitaler Produktpass – Architekturdokumentation (arc42)" \
  --metadata subtitle="VoltCell GmbH · IT-Architektur WS 2026/27 · HdM Stuttgart" \
  --metadata lang=de-DE

"$chrome" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$PWD/$out" "file://$PWD/$html" 2>/dev/null
echo "Erstellt: $out"
