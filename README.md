# 🔋 Digitaler Produktpass – IT-Architektur WS 2026/27

Studienprojekt im Modul **IT-Architektur** an der HdM Stuttgart (Dozent: Dominic Hübsch).
Wir dokumentieren für **Fall 02 – Batteriehersteller VoltCell** eine Lösungsarchitektur nach **arc42** und zeigen mit einem **lauffähigen Prototyp**, dass sie trägt.

![Fall 02 – Digitaler Produktpass auf einen Blick](docs/referenz/fall02_bigpicture.png)

## Worum geht's?

VoltCell stellt Batterien für E-Bikes und Speichersysteme her. Nach der EU-Batterieverordnung braucht jede Batterie einen **digitalen Produktpass per QR-Code** mit Angaben zu Rohstoffherkunft, CO₂-Fußabdruck, Zustand und Recycling.

> **Architekturauftrag:** Aus unzuverlässigen Zulieferdaten einen verlässlichen Pass machen, der jedem genau das zeigt, was er sehen darf, und das noch in vielen Jahren.

Die schwierigen Stellen sind schlechte Datenformate mit KI-Extraktion, Rollen mit unterschiedlichen Rechten, ein lückenloser Audit-Trail und eine Erreichbarkeit von über 10 Jahren. Details mit IDs (K-x, R-x) und offene Fragen stehen in **[`docs/fall.md`](docs/fall.md)**, das ist der Startpunkt für alle.

## Stand & nächste Schritte

- [x] Repo-Struktur, arc42-Gerüst mit Hilfetexten, ADR-Vorlage
- [x] Fall gewählt und aufbereitet ([`docs/fall.md`](docs/fall.md))
- [ ] Offene Fragen an den Dozenten klären ([`docs/fall.md` § 6](docs/fall.md#6-offene-fragen-an-den-dozenten))
- [ ] Stakeholder, fachliche Anforderungen (F-x) und Qualitätsziele (Q-x) festlegen
- [ ] **PL 1:** Kapitel 1–4 schreiben und als .docx abgeben (**26.11.2026**)
- [ ] Prototyp-Slice auswählen und Tech-Stack entscheiden (als ADR)
- [ ] **PL 2:** Kapitel 5–12, Prototyp, Präsentation (**21.01.2027**)

## Schnelleinstieg

| Ich will … | Hier entlang |
|---|---|
| den Fall verstehen | [`docs/fall.md`](docs/fall.md) |
| an der Doku schreiben | [`docs/arc42/`](docs/arc42/) – eine Datei pro Kapitel, PL 1 = [`01`](docs/arc42/01_einfuehrung_und_ziele.md) · [`02`](docs/arc42/02_randbedingungen.md) · [`03`](docs/arc42/03_kontextabgrenzung.md) · [`04`](docs/arc42/04_loesungsstrategie.md) |
| eine Entscheidung festhalten | [`docs/adr/_vorlage.md`](docs/adr/_vorlage.md) kopieren |
| wissen, was der Dozent gesagt hat | [`notes/`](notes/) |
| ins Skript / die Fallbeispiele schauen | [`material/`](material/) |
| am Prototyp arbeiten | [`prototyp/`](prototyp/) |

## Termine & Bewertung

| Was | Wann |
|---|---|
| **PL 1** – arc42 Kapitel 1–4 als .docx über Moodle, danach Feedback | **26.11.2026** |
| **PL 2** – vollständige Doku (vorher in Moodle) + Prototyp-Demo + Vortrag | **21.01.2027** _(Jahr mit Dozent klären)_ |

Note: **Doku 20 %** · **Prototyp 20 %** · **Vortrag inkl. Fragen 60 %** (auch Theoriefragen aus dem Skript).
Vorlesung donnerstags 17:45–19:15 via Zoom.

## Tipps des Dozenten (aus [`notes/`](notes/))

- **Umfang** am Fahrradbeispiel orientieren ([biking.michael-simons.eu/docs](https://biking.michael-simons.eu/docs/)). Implementierungsdetails sind zu viel.
- **Viele Tabellen** verwenden, das hat er klar gesagt.
- **IDs durchziehen:** Jedes Qualitätsziel bekommt eine ID, die sich durch das ganze Dokument zieht.
- **Kapitel 1:** betrieblicher Grund, Use Cases als Tabelle, Anforderungen klären.
- **Kapitel 3:** Schnittstellen im technischen Kontext nummerieren und in einer Tabelle erklären (Protokoll, Port …).
- **Kapitel 4:** Lösungsstrategie als Tabelle mit den Spalten Strategie → bediente Anforderungen und Qualitätsziele.
- Als Architekt **keine eigenen Anforderungen einbringen**, sondern beraten.

## Arbeitsweise

- **In Markdown schreiben**, nicht in Word. Die .docx erzeugen wir erst zur Abgabe (siehe unten).
- **Eine Datei pro Kapitel**, so können mehrere Leute parallel arbeiten.
- **Hilfetexte:** Jedes Kapitel enthält die offiziellen arc42-Hilfetexte als `<!-- arc42-Hilfe: … -->`. Im Editor sind sie sichtbar, in der Vorschau und in der .docx nicht.
- **Entscheidungen als ADR** unter `docs/adr/ADR-00X-titel.md` ablegen und in Kapitel 9 verlinken.
- **Diagramme:** Quelldatei (.drawio, .puml, .mmd) immer mit einchecken, nicht nur das Bild.
- **Branches:** pro Thema ein Branch (z. B. `kap03-kontext`), Merge in `main` per Pull Request mit kurzem Review.
- **Notizen** als `notes/JJJJ-MM-TT.md` ablegen.

<details>
<summary><b>Ordnerstruktur</b></summary>

```
.
├── docs/
│   ├── fall.md       # Fallbeschreibung, IDs, offene Fragen – Startpunkt
│   ├── arc42/        # Die 12 arc42-Kapitel als Markdown
│   ├── adr/          # Architekturentscheidungen (_vorlage.md kopieren)
│   ├── diagramme/    # Diagramm-Quellen + exportierte PNG/SVG
│   └── referenz/     # Hilfsmaterial (arc42 kompakt, Fallübersicht, Big-Picture-Bild)
├── prototyp/         # Code des technischen Prototyps
├── praesentation/    # Folien für PL 2
├── abgabe/PL1, PL2/  # Finale .docx-Abgaben
├── notes/            # Vorlesungsnotizen (JJJJ-MM-TT.md)
├── material/         # Skript, Fallbeispiele, SDD-Exkurs (PDF)
├── scripts/          # Hilfsskripte, z. B. Markdown → .docx
└── CLAUDE.md         # Projektkontext für Claude Code
```
</details>

<details>
<summary><b>Word-Dokument erzeugen</b></summary>

Voraussetzung: [pandoc](https://pandoc.org) (`brew install pandoc`).

```bash
./scripts/build-docx.sh 4    # Kapitel 1–4 für PL 1
./scripts/build-docx.sh      # alle Kapitel für PL 2
```

Die Datei landet in `build-out/` (nicht versioniert). Liegt eine `docs/vorlage.docx` vor, wird sie als Formatvorlage genutzt. Die finale Abgabe kommt nach `abgabe/PL1` bzw. `abgabe/PL2`.
</details>

## Links

- arc42: [arc42.org](https://arc42.org) · [docs.arc42.org](https://docs.arc42.org) · [Praxistipps](https://docs.arc42.org/tips/1-1/)
- Referenzbeispiele: [DokChess](https://www.dokchess.de/en/) · [biking2](https://biking.michael-simons.eu/docs/)
- Qualitätsmodell: [Q42](https://quality.arc42.org)

<sub>Gliederung und Hilfetexte basieren auf dem [arc42-Template](https://github.com/arc42/arc42-template) (DE) von Dr. Peter Hruschka, Dr. Gernot Starke und Mitwirkenden, lizenziert unter [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).</sub>
