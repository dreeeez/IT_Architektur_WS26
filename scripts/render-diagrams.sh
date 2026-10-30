#!/usr/bin/env bash
# Rendert alle D2-Diagramme in docs/diagramme/ zu PNG (für Markdown-Vorschau und .docx).
# Nutzung: ./scripts/render-diagrams.sh   ·   Voraussetzung: d2 (brew install d2)
set -euo pipefail

cd "$(dirname "$0")/../docs/diagramme"
command -v d2 >/dev/null || { echo "d2 fehlt: brew install d2" >&2; exit 1; }

for f in [!_]*.d2; do
  d2 "$f" "${f%.d2}.png"
done
