# IT-Architektur WS 2026/27 – Studienprojekt

Modul „IT-Architektur“ an der HdM Stuttgart (Dozent: Dominic Hübsch).
Ziel: für ein Fallbeispiel eine Lösungsarchitektur nach **arc42** dokumentieren und mit einem **Prototyp** zeigen, dass sie trägt.

**Gewählter Fall:** Fall 2 – Batteriehersteller: **Digitaler Produktpass** (VoltCell GmbH), siehe [`docs/fall.md`](docs/fall.md)

## Termine

| Was | Wann |
|---|---|
| PL 1 – arc42 Kapitel 1–4 (.docx, Moodle) | **26.11.2026** |
| PL 2 – vollständige arc42-Doku + Prototyp-Präsentation | **21.01.2027** (mit Dozent klären) |

## Ordnerstruktur

```
.
├── docs/
│   ├── arc42/        # Die 12 arc42-Kapitel als Markdown (eine Datei pro Kapitel)
│   ├── adr/          # Architekturentscheidungen, eine Datei pro ADR (_vorlage.md kopieren)
│   ├── diagramme/    # Diagramme: Quellen (.drawio, .puml, .mmd) + exportierte PNG/SVG
│   └── referenz/     # Hilfsmaterial (arc42 kompakt, Fallbeispiel-Übersicht)
├── prototyp/         # Code des technischen Prototyps
├── praesentation/    # Folien für PL 2
├── abgabe/
│   ├── PL1/          # Finale .docx-Abgabe PL 1
│   └── PL2/          # Finale .docx-Abgabe PL 2
├── notes/            # Vorlesungsnotizen, Dateiname = Datum (JJJJ-MM-TT.md)
├── material/         # Vorlesungsunterlagen (Skript, Fallbeispiele, SDD-Exkurs)
├── scripts/          # Hilfsskripte, z. B. Markdown → .docx
└── CLAUDE.md         # Projektkontext für Claude Code
```

## Arbeitsweise

- **Inhalte in Markdown schreiben**, nicht direkt in Word. So lassen sich Änderungen im Git-Diff nachvollziehen und Merge-Konflikte bleiben klein.
- **Eine Datei pro arc42-Kapitel**, damit mehrere Leute parallel arbeiten können.
- **Hilfetexte**: Jedes Kapitel enthält die offiziellen arc42-Hilfetexte als `<!-- arc42-Hilfe: … -->`-Kommentar. Im Editor sichtbar, in der Vorschau und in der .docx nicht. Können stehen bleiben.
- **Entscheidungen als ADR**: `docs/adr/_vorlage.md` kopieren nach `ADR-00X-kurzer-titel.md` und in Kapitel 9 verlinken.
- **Diagramme**: Quelldatei immer mit einchecken, nicht nur das Bild. Einbinden per `![Kontext](../diagramme/kontext.png)`.
- **Branches**: pro Thema ein Branch (z. B. `kap03-kontext`, `prototyp-sync`), Merge in `main` per Pull Request mit kurzem Review.
- **Notizen**: neue Vorlesungsnotizen als `notes/JJJJ-MM-TT.md`.

## Word-Dokument erzeugen

Voraussetzung: [pandoc](https://pandoc.org) (`brew install pandoc`).

```bash
./scripts/build-docx.sh 4    # Kapitel 1–4 für PL 1
./scripts/build-docx.sh      # alle Kapitel für PL 2
```

Die Datei landet in `build-out/` (nicht versioniert). Liegt eine `docs/vorlage.docx` vor, wird sie als Formatvorlage genutzt. Die finale, nachbearbeitete Abgabe kommt nach `abgabe/PL1` bzw. `abgabe/PL2`.

## Links

- arc42: https://arc42.org · https://docs.arc42.org
- Referenzbeispiel: https://www.dokchess.de/en/

Gliederung und Hilfetexte basieren auf dem [arc42-Template](https://github.com/arc42/arc42-template) (DE) von Dr. Peter Hruschka, Dr. Gernot Starke und Mitwirkenden, lizenziert unter [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
