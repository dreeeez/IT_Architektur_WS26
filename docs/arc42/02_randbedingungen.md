# 2. Randbedingungen

> **Status: Entwurf v0.1.** Paragrafen-Angaben beziehen sich auf VO (EU) 2023/1542 und sind vor der Abgabe am Originaltext (EUR-Lex) zu prüfen.

<!-- arc42-Hilfe:
Randbedingungen und Vorgaben, die die Freiheiten bei Entwurf, Implementierung oder Entwicklungsprozess einschränken.
Form: einfache Tabellen mit Erläuterungen, getrennt nach technisch, organisatorisch/rechtlich und Konventionen.
Mehr: https://docs.arc42.org/section-2/
-->

Die folgenden Vorgaben schränken den Lösungsraum ein. Sie sind nicht verhandelbar, entweder weil sie aus dem Fall stammen oder weil das Gesetz sie vorschreibt.

## 2.1 Technische Randbedingungen

| ID | Randbedingung | Hintergrund / Motivation |
|---|---|---|
| TR-1 | Der QR-Code wird aufgedruckt und ist danach **nicht mehr änderbar**. | Fall R-2. Die im QR-Code codierte Adresse muss über die gesamte Lebensdauer gültig bleiben. |
| TR-2 | Kennung und QR-Code entsprechen **ISO/IEC 15459** (oder gleichwertig). | Art. 77 Abs. 3 |
| TR-3 | Daten in **offenen Standards**, maschinenlesbar, strukturiert und durchsuchbar, **ohne Anbieterbindung** übertragbar. | Art. 77 Abs. 8, Art. 78 lit. a |
| TR-4 | Mengengerüst: rund **200.000 neue Pässe pro Jahr**, nach 10 Jahren also rund 2 Mio. Pässe. | Fall R-1 |
| TR-5 | Zulieferdaten kommen in **uneinheitlichen Formaten**, von der API bis zum PDF-Datenblatt. | Fall K-1 |
| TR-6 | Zulieferer müssen **ohne eigene IT** teilnehmen können, d. h. nur mit einem Browser. | Fall R-3 |
| TR-7 | Der Prototyp läuft auf frei wählbarer Plattform (Free Tier, HdM-Infrastruktur oder eigener Rechner). | Modulvorgabe |

## 2.2 Organisatorische und rechtliche Randbedingungen

| ID | Randbedingung | Hintergrund / Motivation |
|---|---|---|
| OR-1 | **Batteriepass-Pflicht ab 18.02.2027** für LV-Batterien und Industriebatterien über 2 kWh. | Art. 77 Abs. 1 |
| OR-2 | **Drei Zugriffsstufen:** öffentlich, Personen mit berechtigtem Interesse, Behörden und Kommission. Wer genau als „berechtigt“ gilt, legt ein Durchführungsrechtsakt der Kommission fest. | Art. 77 Abs. 2 und 9, Anhang XIII |
| OR-3 | Der Pass muss **verfügbar bleiben, auch wenn VoltCell nicht mehr existiert**. | Fall K-4, Art. 78 lit. e |
| OR-4 | Der Pass wird **gelöscht, sobald die Batterie recycelt ist**. Bei Wiederverwendung entsteht ein neuer Pass, der mit dem alten verknüpft ist. | Art. 77 Abs. 6 und 7 |
| OR-5 | Daten dürfen bei **Dritten** gespeichert werden. Diese dürfen sie aber nicht verkaufen oder anderweitig verwenden. | Art. 78 lit. c, d |
| OR-6 | Die Kennung jedes Passes wird im **EU-Register** für digitale Produktpässe hinterlegt. | Art. 77, VO (EU) 2024/1781 Art. 13 |
| OR-7 | Zugang zum Pass ist für alle Berechtigten **unentgeltlich**. | Art. 78 lit. b |
| OR-8 | **DSGVO**: Nutzerkonten, Ansprechpartner der Zulieferer und die Änderungshistorie enthalten personenbezogene Daten. | VO (EU) 2016/679 |
| OR-9 | Studienprojekt: Team aus Studierenden, kein Budget, Abgaben **26.11.2026** (Kap. 1–4) und **21.01.2027** (vollständig + Prototyp). | Modulvorgabe |

## 2.3 Konventionen

| ID | Konvention | Hintergrund / Motivation |
|---|---|---|
| KV-1 | Dokumentation nach **arc42**, Sprache Deutsch, Abgabe als .docx | Modulvorgabe |
| KV-2 | **Durchgehende IDs**: F-x (Use Cases), QZ-x (Qualitätsziele), SH-x (Stakeholder), TR-/OR-x (Randbedingungen), A-x (Annahmen), S-x (Schnittstellen), ST-x (Strategien) | Rückverfolgbarkeit über alle Kapitel |
| KV-3 | Diagramme als Code mit **D2**, Quelle liegt im Repository | Versionierbar, im Team bearbeitbar |
| KV-4 | Architekturentscheidungen als **ADR** (Kap. 9) | Entscheidungen samt Alternativen nachvollziehbar |

## 2.4 Annahmen

Die Fallbeschreibung lässt einige Punkte offen. Damit wir weiterarbeiten können, treffen wir folgende Annahmen. Die zugehörigen Fragen stehen in [`docs/fall.md` § 6](../fall.md#6-offene-fragen-an-den-dozenten).

| ID | Annahme | Offene Frage |
|---|---|---|
| A-1 | VoltCell bringt die Batterien selbst in Verkehr und ist damit der für den Pass verantwortliche Wirtschaftsakteur. | – |
| A-2 | Die Speichersysteme von VoltCell haben mehr als 2 kWh und sind damit passpflichtig. | – |
| A-3 | Für den Fall, dass VoltCell wegfällt, wird ein unabhängiger **Treuhänder** beauftragt, der eine aktuelle Kopie aller Pässe hält und den Betrieb übernimmt. | Nr. 1 |
| A-4 | VoltCell besitzt ein ERP-System, das Seriennummer und Modell jeder Batterie kennt und den Etikettendruck ansteuert. | Nr. 3 |
| A-5 | Die KI-Extraktion darf einen externen Dienst nutzen, sofern dieser in der EU betrieben wird. | Nr. 4 |
| A-6 | Werkstätten und Recycler registrieren sich und weisen ihr berechtigtes Interesse einmalig nach. Danach melden sie sich mit einem Konto an. | Nr. 5 |
| A-7 | Die KI-Extraktion erzeugt nur Vorschläge, die ein Mensch freigibt. Wir nehmen an, dass sie damit nicht als Hochrisiko-System nach dem EU AI Act gilt. | Nr. 4 |
