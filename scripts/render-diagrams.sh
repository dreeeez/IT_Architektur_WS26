#!/usr/bin/env bash
# Rendert alle D2-Diagramme in docs/diagramme/ zu PNG (für Markdown-Vorschau und .docx).
# Ablauf: D2 → SVG → Masken hinter Verbindungsbeschriftungen entfernen (Linie läuft durch, wie bei UML-Werkzeugen)
#         → PNG über Chrome im Headless-Modus (doppelte Auflösung).
# Nutzung: ./scripts/render-diagrams.sh   ·   Voraussetzung: d2 (brew install d2), Google Chrome, python3
set -euo pipefail

cd "$(dirname "$0")/../docs/diagramme"
command -v d2 >/dev/null || { echo "d2 fehlt: brew install d2" >&2; exit 1; }
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[[ -x "$chrome" ]] || { echo "Google Chrome nicht gefunden" >&2; exit 1; }

for f in [!_]*.d2; do
  name="${f%.d2}"
  # Kompakte ELK-Abstände, damit die Diagramme auf A4 lesbar bleiben
  # Abstand zwischen den Ebenen: Standard 40, pro Diagramm änderbar mit einer Zeile „# elk-abstand: N“
  abstand=$(sed -n 's/^# elk-abstand: *\([0-9]*\).*/\1/p' "$f" | head -1)
  rand=$(sed -n 's/^# elk-rand: *\(\[.*\]\).*/\1/p' "$f" | head -1)
  d2 --elk-nodeNodeBetweenLayers "${abstand:-40}" --elk-edgeNodeBetweenLayers "${abstand:-15}" \
    --elk-padding "${rand:-[top=70,left=60,bottom=60,right=60]}" "$f" "$name.svg"
  groesse=$(python3 -I - "$name.svg" <<'PY'
import re, sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
s = re.sub(r'\s+mask="url\(#[^)]*\)"', "", s)   # Linien nicht mehr hinter Beschriftungen ausblenden
# Beschriftungen mit «flow» wie in UML-Werkzeugen: Text über der Linie, «flow» darunter
def flow(m):
    block = m.group(0)
    if "«flow»" not in block:
        return block
    block = re.sub(r'(<text x="[^"]*" y=")([\d.]+)', lambda n: n.group(1) + str(float(n.group(2)) - 11), block, count=1)
    return re.sub(r'(<tspan x="[^"]*" dy=")([\d.]+)(">«flow»)', lambda n: n.group(1) + str(float(n.group(2)) + 11) + n.group(3), block)
s = re.sub(r"<text [^>]*>.*?</text>", flow, s, flags=re.S)
# Übrige Verbindungsbeschriftungen (ohne «flow») komplett über die Linie setzen.
import base64
def ueber_linie(m):
    klasse, inhalt = m.group(1), m.group(2)
    try:
        name = base64.b64decode(klasse + "=" * (-len(klasse) % 4)).decode("utf-8", "ignore")
    except Exception:
        return m.group(0)
    if not re.search(r"(->|<-|--|-&gt;|&lt;-)", name) or "«flow»" in inhalt or "<text" not in inhalt:
        return m.group(0)
    # Laufrichtung der Linie aus Start- und Endpunkt des Pfads bestimmen
    pfad = re.search(r'<path d="M\s*([-\d.]+)[ ,]+([-\d.]+)(.*?)"', inhalt, flags=re.S)
    senkrecht = False
    if pfad:
        zahlen = re.findall(r"[-\d.]+", pfad.group(3))
        if len(zahlen) >= 2:
            dx = abs(float(zahlen[-2]) - float(pfad.group(1)))
            dy = abs(float(zahlen[-1]) - float(pfad.group(2)))
            senkrecht = dy > dx
    def hoch(n):
        block = n.group(0)
        if senkrecht:
            # senkrechte Linie: Beschriftung rechts neben die Linie, linksbündig
            block = re.sub(r'( x=")([-\d.]+)', lambda k: k.group(1) + str(float(k.group(2)) + 8), block)
            return block.replace("text-anchor:middle", "text-anchor:start")
        zeilen = max(1, block.count("<tspan"))
        return re.sub(r'(<text [^>]*?y=")([\d.]+)', lambda k: k.group(1) + str(float(k.group(2)) - (7.5 * zeilen + 5)), block, count=1)
    inhalt = re.sub(r"<text [^>]*>.*?</text>", hoch, inhalt, flags=re.S)
    return f'<g class="{klasse}">{inhalt}</g>'
s = re.sub(r'<g class="([A-Za-z0-9+/=]+)">(.*?)</g>', ueber_linie, s, flags=re.S)
# Schnittstellen-Kästchen (Linienende „box“ mit Beschriftung S1, S2 …): größeres Kästchen am Rand, Nummer darin
def port_kaestchen(m):
    block = m.group(0)
    nummer = re.search(r'<text [^>]*class="text-italic fill-N1"[^>]*>(S\d+)</text>', block)
    box = re.search(r'class="connection fill-N7" style="stroke-width:0;" transform="translate\(([-\d.]+) ([-\d.]+)\) rotate\(([-\d.]+)\)"', block)
    if not (nummer and box):
        return block
    x, y, r = float(box.group(1)), float(box.group(2)), float(box.group(3))
    b, h = 34, 26
    oben = r > 0   # Linie kommt von oben auf den Rand zu
    ry = y - h if oben else y
    neu = (f'<rect x="{x - b / 2}" y="{ry}" width="{b}" height="{h}" fill="#ffffff" stroke="#1a1a1a" stroke-width="1.3"/>'
           f'<text x="{x}" y="{ry + h / 2 + 5}" fill="#1a1a1a" class="text-bold" style="text-anchor:middle;font-size:13px">{nummer.group(1)}</text>')
    block = block.replace(nummer.group(0), "")
    return block[:-4] + neu + "</g>"
s = re.sub(r'<g class="[A-Za-z0-9+/=]+">.*?</g>', port_kaestchen, s, flags=re.S)
# Strategie-Marker: letzte Zeile einer Beschriftung „ST-1“ oder „ST-4, ST-5“ wird zu schwarzen Plaketten (wie (a)–(f) bei DokChess)
def marker(m):
    kopf, x, y, inhalt = m.group(1), float(m.group(2)), float(m.group(3)), m.group(4)
    zeilen = re.findall(r'<tspan x="[^"]*" dy="([-\d.]+)">([^<]*)</tspan>', inhalt)
    if len(zeilen) < 2 or not re.fullmatch(r"ST-\d+(, ST-\d+)*", zeilen[-1][1]):
        return m.group(0)
    hoehe_y = y + sum(float(d) for d, _ in zeilen)
    rest = "".join(f'<tspan x="{x}" dy="{d}">{z}</tspan>' for d, z in zeilen[:-1])
    namen = zeilen[-1][1].split(", ")
    b, h, luecke = 46, 22, 6
    start = x - (len(namen) * b + (len(namen) - 1) * luecke) / 2
    plaketten = ""
    for i, n in enumerate(namen):
        px = start + i * (b + luecke)
        py = hoehe_y - 12
        plaketten += (f'<rect x="{px}" y="{py}" width="{b}" height="{h}" rx="11" fill="#1a1a1a"/>'
                      f'<text x="{px + b / 2}" y="{py + 15.5}" fill="#ffffff" class="text-bold" style="text-anchor:middle;font-size:13px">{n}</text>')
    return kopf + rest + "</text>" + plaketten
s = re.sub(r'(<text x="([-\d.]+)" y="([-\d.]+)"[^>]*>)(.*?)</text>', marker, s, flags=re.S)
# Diagrammtitel oben links („cmp …“, „deployment …“) als UML-Reiter mit farbigem Hintergrund
def titel_reiter(m):
    x, y, groesse, text = float(m.group(1)), float(m.group(2)), float(m.group(3)), m.group(4)
    breite = len(text) * groesse * 0.55 + 20
    x0, y0, hoehe = x - breite / 2, y - groesse - 9, groesse + 18
    ecke = 9
    punkte = f"{x0},{y0} {x0 + breite},{y0} {x0 + breite},{y0 + hoehe - ecke} {x0 + breite - ecke},{y0 + hoehe} {x0},{y0 + hoehe}"
    return (f'<polygon points="{punkte}" fill="#fde9d2" stroke="#1a1a1a" stroke-width="1.2"/>' + m.group(0))
s = re.sub(r'<text x="([-\d.]+)" y="([-\d.]+)"[^>]*font-size:([\d.]+)px">((?:cmp|deployment) [^<]+)</text>', titel_reiter, s, count=1)
open(p, "w", encoding="utf-8").write(s)
m = re.search(r'<svg[^>]*?width="(\d+)"[^>]*?height="(\d+)"', s)
print(f"{m.group(1)},{m.group(2)}")
PY
)
  profil="$(mktemp -d)"
  "$chrome" --headless --disable-gpu --user-data-dir="$profil" --hide-scrollbars \
    --force-device-scale-factor=2 --default-background-color=FFFFFFFF \
    --window-size="$groesse" --screenshot="$PWD/$name.png" "file://$PWD/$name.svg" 2>/dev/null
  rm -rf "$profil"
  echo "Erstellt: docs/diagramme/$name.png"
done
