#!/usr/bin/env bash
# Baut aus den arc42-Markdown-Kapiteln ein PDF (pandoc → HTML → Chrome-Druck), Stil: scripts/pdf.css
# Deckblatt und Inhaltsverzeichnis erzeugt scripts/deckblatt.py.
# Nutzung:  ./scripts/build-pdf.sh        → alle 12 Kapitel
#           ./scripts/build-pdf.sh 4      → nur Kapitel 1–4
# Voraussetzung: pandoc (brew install pandoc), Google Chrome, python3
set -euo pipefail

cd "$(dirname "$0")/.."
command -v pandoc >/dev/null || { echo "pandoc fehlt: brew install pandoc" >&2; exit 1; }
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[[ -x "$chrome" ]] || { echo "Google Chrome nicht gefunden" >&2; exit 1; }

bis="${1:-12}"
files=()
for f in docs/arc42/[0-9][0-9]_*.md; do
  nr=$((10#$(basename "$f" | cut -c1-2)))
  (( nr >= 1 && nr <= bis )) && files+=("$f")   # 00 = Vorspann, steht im Deckblatt
done

mkdir -p build-out/aktuell
html="build-out/aktuell/arc42_Kapitel_1-${bis}.html"
out="build-out/aktuell/arc42_Kapitel_1-${bis}.pdf"
cover="build-out/aktuell/deckblatt.html"

python3 -I scripts/deckblatt.py "$bis" "$cover"   # Deckblatt + Inhaltsverzeichnis

# --columns=9999: keine festen Spaltenbreiten aus den Markdown-Tabellen, Breite passt sich dem Inhalt an
pandoc "${files[@]}" --lua-filter=scripts/ids-nobreak.lua -s -o "$html" \
  --include-before-body="$cover" \
  --columns=9999 --resource-path=docs/arc42:docs --embed-resources --css=scripts/pdf.css \
  --metadata pagetitle="VoltPass – Architekturdokumentation (arc42)" \
  --metadata lang=de-DE

# eigenes Profil, damit Chrome nicht an ein bereits geöffnetes Browserfenster übergibt
profil="$(mktemp -d)"
"$chrome" --headless --disable-gpu --no-pdf-header-footer --user-data-dir="$profil" \
  --print-to-pdf="$PWD/$out" "file://$PWD/$html" 2>/dev/null
rm -rf "$profil"
echo "Erstellt: $out"
