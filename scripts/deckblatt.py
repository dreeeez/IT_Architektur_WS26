#!/usr/bin/env python3
"""Erzeugt Deckblatt und Inhaltsverzeichnis (HTML) für scripts/build-pdf.sh.

Aufruf: python3 scripts/deckblatt.py <bis-Kapitel> <Ausgabedatei>

- Deckblatt: klassisches Hausarbeits-Deckblatt (oben Hochschule/Modul, Mitte Logo aus docs/bilder,
  unten links „Vorgelegt von“ mit dem Team aus docs/team.md, Dozent, Stand).
- Seite 2: Architekturüberblick (docs/arc42/00_architekturueberblick.md),
  darunter das Inhaltsverzeichnis (nur Hauptkapitel).
Titel und Unterkapitel werden direkt aus docs/arc42/NN_*.md gelesen.
"""
import datetime
import glob
import html
import os
import re
import sys

bis = int(sys.argv[1])
ziel = sys.argv[2]
basis = os.path.join(os.path.dirname(__file__), "..", "docs", "arc42")


def pandoc_id(text):
    """Nachbau der automatischen Überschriften-IDs von pandoc."""
    t = re.sub(r"[^\w\s.-]", "", text.lower())
    t = re.sub(r"\s+", "-", t.strip())
    t = re.sub(r"^[^a-zäöüß]+", "", t)
    return t


kapitel = []
vorspann = ""
for pfad in sorted(glob.glob(os.path.join(basis, "[0-9][0-9]_*.md"))):
    nr = int(os.path.basename(pfad)[:2])
    if nr == 0:  # Vorspann „Architekturüberblick“
        text = open(pfad, encoding="utf-8").read()
        vorspann_titel = re.sub(r"\s*\{[^}]*\}", "", text.splitlines()[0][2:]).strip()
        absaetze = [a.strip() for a in text.split("\n\n")[1:] if a.strip()]
        vorspann = (
            f'<div class="vs"><div class="vs-kopf">{html.escape(vorspann_titel)}</div>'
            + "".join(f"<p>{html.escape(a)}</p>" for a in absaetze)
            + "</div>"
        )
        continue
    zeilen = open(pfad, encoding="utf-8").read().splitlines()
    titel = re.sub(r"^#\s+\d+\.\s*", "", next(z for z in zeilen if z.startswith("# ")))
    unter = [z[3:].strip() for z in zeilen if z.startswith("## ")]
    kapitel.append((nr, titel, unter))

# Team aus docs/team.md (ein Name je Listenpunkt), auf dem Deckblatt in einer Zeile
team = []
team_datei = os.path.join(basis, "..", "team.md")
if os.path.exists(team_datei):
    team = [z[2:].strip() for z in open(team_datei, encoding="utf-8").read().splitlines() if z.startswith("- ")]
team_html = "<br>".join(html.escape(n) for n in team)

stand = datetime.date.today().strftime("%d.%m.%Y")
umfang = f"Kapitel 1–{bis}" if bis < 12 else "Kapitel 1–12 (vollständig)"

deckblatt = f"""
<section class="deckblatt">
  <div class="db-kopf">
    <div>Hochschule der Medien Stuttgart</div>
    <div>Modul IT-Architektur</div>
    <div>Wintersemester 2026/27</div>
  </div>
  <div class="db-mitte">
    <img class="db-logo" src="docs/bilder/voltpass_logo.png" alt="VoltPass">
    <div class="db-art">Architekturdokumentation nach arc42 zum Thema:</div>
    <div class="db-unter">Digitaler Batteriepass für E-Bike-Akkus und Speichersysteme</div>
  </div>
  <div class="db-angaben">
    <p><b>Vorgelegt von:</b></p>
    <p>{team_html}</p>
    <p><b>Dozent:</b> Dominic Hübsch<br><b>Stand:</b> {stand}</p>
  </div>
</section>
"""

eintraege = []
for nr, titel, unter in kapitel:
    if nr <= bis:
        anker = pandoc_id(f"{nr}. {titel}")
        eintraege.append(
            f'<li class="ik-kap"><span class="ik-nr">{nr}</span>'
            f'<a class="ik-titel" href="#{anker}">{html.escape(titel)}</a></li>'
        )

inhalt = f"""
<section class="inhalt">
  {vorspann}
  <div class="ik-kopf">Inhalt</div>
  <ol class="ik-liste">{''.join(eintraege)}</ol>
</section>
"""

with open(ziel, "w", encoding="utf-8") as f:
    f.write(deckblatt + inhalt)
