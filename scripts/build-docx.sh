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
  (( nr >= 1 && nr <= bis )) && files+=("$f")   # 00 = Architekturüberblick, kommt als abstract
done

mkdir -p build-out/aktuell
out="build-out/aktuell/arc42_Kapitel_1-${bis}.docx"
# Architekturüberblick (00_*.md) als „abstract“: steht in Word unter dem Titel, vor dem Inhaltsverzeichnis
vorspann="build-out/aktuell/vorspann.yaml"
python3 -I - docs/arc42/00_*.md "$vorspann" <<'PY2'
import re, sys
text = open(sys.argv[1], encoding="utf-8").read().strip().splitlines()
titel = re.sub(r"\s*\{[^}]*\}", "", text[0][2:]).strip()
rumpf = "\n".join(text[1:]).strip()
# Team aus docs/team.md als Autoren, in einer Zeile
team = [z[2:].strip() for z in open("docs/team.md", encoding="utf-8").read().splitlines() if z.startswith("- ")]
with open(sys.argv[2], "w", encoding="utf-8") as f:
    namen = team[0] if len(team) == 1 else ", ".join(team[:-1]) + " und " + team[-1]
    f.write("---\nauthor: \"" + namen + "\"\n")
    f.write("abstract-title: \"" + titel + "\"\nabstract: |\n")
    f.write("".join("  " + z + "\n" for z in rumpf.splitlines()))
    f.write("...\n")
PY2

ref=()
[[ -f docs/vorlage.docx ]] && ref=(--reference-doc=docs/vorlage.docx)

# ${ref[@]+...}: leeres Array ist unter macOS-Bash 3.2 mit "set -u" sonst ein Fehler
# --columns=9999: keine festen Spaltenbreiten aus den Markdown-Tabellen, Breite passt sich dem Inhalt an
pandoc "${files[@]}" --lua-filter=scripts/ids-nobreak.lua --metadata-file="$vorspann" -o "$out" --toc --toc-depth=1 --columns=9999 --resource-path=docs/arc42:docs \
  --metadata title="VoltPass" \
  --metadata subtitle="Digitaler Batteriepass – Architekturdokumentation nach arc42" --metadata date="IT-Architektur, Wintersemester 2026/27, Hochschule der Medien Stuttgart – Stand: $(date +%d.%m.%Y)" \
  --metadata lang=de-DE --metadata toc-title="Inhalt" \
  ${ref[@]+"${ref[@]}"}
echo "Erstellt: $out"
