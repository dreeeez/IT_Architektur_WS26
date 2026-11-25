# VoltPass – Architekturdokumentation nach arc42

VoltPass ist das System, mit dem die VoltCell GmbH die digitalen Batteriepässe für ihre Batterien erstellt und verwaltet. Dieses Repository enthält die Architekturdokumentation nach [arc42](https://arc42.org) als Docs-as-Code: Markdown und D2-Diagramme, aus denen per Skript ein PDF entsteht.

Studienprojekt im Modul IT-Architektur, HdM Stuttgart, WS 2026/27. Team siehe [`docs/team.md`](docs/team.md).

**Stand:** Kapitel 1–4 (Abgabe PL 1, 26.11.2026). Kapitel 5–12 und der Prototyp folgen mit PL 2.

**PDF der Abgabe:** [VoltPass_arc42_Kapitel_1-4_PL1.pdf](https://github.com/dreeeez/IT_Architektur_WS26/releases/download/pl1/VoltPass_arc42_Kapitel_1-4_PL1.pdf) (Release [`pl1`](../../releases/tag/pl1))

## Inhalt

| Kapitel | Datei |
|---|---|
| Architekturüberblick | [`00_architekturueberblick.md`](docs/arc42/00_architekturueberblick.md) |
| 1. Einführung und Ziele | [`01_einfuehrung_und_ziele.md`](docs/arc42/01_einfuehrung_und_ziele.md) |
| 2. Randbedingungen | [`02_randbedingungen.md`](docs/arc42/02_randbedingungen.md) |
| 3. Kontextabgrenzung | [`03_kontextabgrenzung.md`](docs/arc42/03_kontextabgrenzung.md) |
| 4. Lösungsstrategie | [`04_loesungsstrategie.md`](docs/arc42/04_loesungsstrategie.md) |

## Aufbau

```
docs/
├── arc42/        Kapitel als Markdown, eine Datei je Kapitel
├── diagramme/    D2-Quellen (.d2) und gerenderte Bilder (.png)
├── bilder/       Logo und UML-Symbole für Deckblatt und Diagramme
└── team.md       Namen für das Deckblatt
scripts/
├── build-pdf.sh         PDF bauen (pandoc → HTML → Chrome)
├── render-diagrams.sh   D2-Diagramme neu rendern
├── deckblatt.py         Deckblatt und Inhaltsverzeichnis für das PDF
├── ids-nobreak.lua      pandoc-Filter: IDs, Spaltenbreiten, Listen in Tabellen
└── pdf.css              Layout des PDFs
```

## Dokument bauen

Voraussetzungen: [pandoc](https://pandoc.org), Python 3 und Google Chrome (die Skripte erwarten Chrome unter macOS).

```bash
./scripts/build-pdf.sh 4     # PDF mit Kapitel 1–4
```

Die Ergebnisse landen in `build-out/aktuell/` und werden nicht versioniert. Fertige Fassungen für Abgaben gibt es als [Release](../../releases).

## Diagramme ändern

Die Diagramme liegen als D2-Quelltext in `docs/diagramme/`. Nach einer Änderung neu rendern, dafür wird zusätzlich [D2](https://d2lang.com) benötigt:

```bash
./scripts/render-diagrams.sh
```

Die erzeugten PNG-Dateien werden mit eingecheckt, damit sich das Dokument auch ohne D2 bauen lässt.

## Konventionen

- Jedes Element hat eine ID (z. B. F-01, QZ-1, TR-3, S1, ST-1), damit die Kapitel aufeinander verweisen können.
- Sprache Deutsch, Fachbegriffe wie State of Health im Original.
- Architekturentscheidungen werden in Kapitel 9 als ADR begründet.
