# 2. Randbedingungen

<!-- arc42-Hilfe:
Randbedingungen und Vorgaben, die die Freiheiten bei Entwurf, Implementierung oder Entwicklungsprozess einschränken.
Form: einfache Tabellen mit Erläuterungen, getrennt nach technisch, organisatorisch/rechtlich und Konventionen.
Mehr: https://docs.arc42.org/section-2/
-->

## 2.1 Technologische Randbedingungen

| ID | Randbedingung | Hintergrund / Motivation |
|---|---|---|
| | **Kennung und QR-Code** | |
| TR-1 | QR-Code unveränderlich | Der QR-Code wird aufgedruckt und ist danach nicht änderbar. Die Adresse darin muss die ganze Lebensdauer gültig bleiben, auch wenn VoltCell wegfällt. |
| TR-2 | Kennung nach ISO/IEC 15459 | Die Batterieverordnung VO (EU) 2023/1542 schreibt in Art. 77 diese Norm für die Kennung jeder Batterie vor. So ist jede Kennung weltweit eindeutig. |
| | **Daten und Formate** | |
| TR-3 | Offene Standards | Die Batterieverordnung verlangt maschinenlesbare Daten ohne Anbieterbindung. Das schränkt Formate und Technologiewahl ein. |
| TR-4 | Mengengerüst | Rund 200.000 neue Pässe pro Jahr, nach 10 Jahren rund 2 Mio. |
| TR-5 | Datenfelder vorgegeben | Anhang XIII der Batterieverordnung legt Felder und Zugriffsstufen fest. Das Datenmodell ist damit weitgehend vorgegeben. |
| | **Anbindung** | |
| TR-6 | Uneinheitliche Zulieferdaten | Zulieferer liefern in unterschiedlichen Formaten, von der API bis zum PDF-Datenblatt. |
| TR-7 | Teilnahme nur mit Browser | Auch Zulieferer ohne eigene IT müssen ohne Installation teilnehmen können. |
| TR-8 | Bestehende Systeme anbinden | Das ERP von VoltCell und das EU-Register werden angebunden, nicht ersetzt. Ihre Schnittstellen sind vorgegeben, ihre genaue Form nehmen wir an. |
| | **Projektrahmen** | |
| TR-9 | Kostengünstige, verbreitete Technik | Wegen begrenzten Budgets und Zeitaufwands werden kostenlose oder günstige Technologien bevorzugt, die verbreitet und gut dokumentiert sind. |
| TR-10 | Begrenzte Infrastruktur | Der Prototyp läuft möglichst kostenlos, z. B. auf HdM-Infrastruktur oder lokal. Langzeitbetrieb und hohe Lasten werden dort nicht berücksichtigt. |

## 2.2 Organisatorische Randbedingungen

| ID | Randbedingung | Hintergrund / Motivation |
|---|---|---|
| | **Gesetzliche Vorgaben** | |
| OR-1 | Fester Stichtag | Ab 18.02.2027 braucht jede neue E-Bike-Batterie und jede Industriebatterie über 2 kWh einen Pass. Der Termin ist gesetzlich fix, der Umfang der ersten Ausbaustufe richtet sich danach. |
| OR-2 | Drei Zugriffsstufen | Die Architektur muss die drei Zugriffsstufen der Batterieverordnung nach Art. 77 und Anhang XIII technisch durchsetzen: • öffentliche Daten • Daten für Personen mit berechtigtem Interesse • Daten für Behörden und EU-Kommission |
| OR-3 | 10 Jahre erreichbar | Die Batterieverordnung verlangt mindestens 10 Jahre Erreichbarkeit. Das muss auch bei Insolvenz oder Geschäftsaufgabe von VoltCell gelten. |
| OR-4 | Datenschutz | Nutzerkonten, Ansprechpartner der Zulieferer und die Änderungshistorie enthalten personenbezogene Daten und fallen unter die DSGVO. |
| | **Projektrahmen** | |
| OR-5 | Eigenentwicklung | Annahme: VoltPass wird von der internen IT-Abteilung von VoltCell entwickelt und betrieben. |
| OR-6 | Team | Das Entwicklungsteam erstellt Architektur und Prototyp neben dem Studium und mit sehr begrenztem Budget. |
| OR-7 | Zeitplan | Das Modul gibt zwei Abgaben vor: • Kap. 1–4 am 26.11.2026 • Vollständige Doku und Präsentation des Prototyps am 21.01.2027 |
| OR-8 | Vorgehen | Iterativ: Das Feedback zur ersten Abgabe fließt in die vollständige Doku ein. |
| OR-9 | Prototyp | Der Prototyp muss mindestens eine fachliche Anforderung lauffähig umsetzen. Plattform und Technologie sind frei wählbar. |

## 2.3 Konventionen

| ID | Konvention | Hintergrund / Motivation |
|---|---|---|
| KV-1 | Architekturdokumentation | Aufbau nach arc42, Abgabe als Word-Dokument. |
| KV-2 | Sprache | Deutsch, Fachbegriffe wie State of Health im Original. |
| KV-3 | Durchgehende IDs | Jedes Element hat eine ID, damit alle Kapitel aufeinander verweisen können. |
| KV-4 | Diagramme | Alle Diagramme einheitlich in D2, Schnittstellen mit ID. |
| KV-5 | Architekturentscheidungen | Als ADR in Kap. 9 mit Kontext, Alternativen, Begründung und Konsequenzen. |

## 2.4 Annahmen {.neue-seite}

| ID | Annahme | Hintergrund / Motivation |
|---|---|---|
| A-1 | Unabhängiger Treuhänder | Fällt VoltCell weg, übernimmt ein beauftragter Treuhänder die Pässe. Darauf bauen F-10, P-10 und ST-3 auf. |
| A-2 | Zielwerte für die Erreichbarkeit | 15 Jahre Erreichbarkeit und eine Übernahme durch den Treuhänder in 30 Tagen (QZ-2) sind unser Vorschlag. Die Verordnung verlangt mindestens 10 Jahre, nennt aber keine Übernahmefrist. |
| A-3 | ERP und Firmen-Login vorhanden | VoltCell hat ein ERP, das Seriennummer und Modell jeder Batterie kennt und den Etikettendruck steuert (P-01), sowie einen Firmen-Login über OpenID Connect (S7). Die Schnittstellen beider Systeme nehmen wir an. |
| A-4 | Betrieb in einer EU-Cloud | VoltCell erlaubt den Betrieb von VoltPass in einer EU-Cloud, auch für den KI-Dienst (TE-1, TE-2). |
| A-5 | Kein Hochrisiko-System nach EU AI Act | Die KI liefert nur Vorschläge, die ein Mensch freigibt (ST-1). Wir nehmen an, dass VoltPass damit nicht als Hochrisiko-System gilt. |
| A-6 | EU-Register mit REST-Schnittstelle | Das EU-Register nimmt Pass-Kennungen per REST entgegen (S4). Im Prototyp wird es simuliert (OE-2). |
| A-7 | Werkstatt-Einträge ohne weitere Freigabe | Einträge angemeldeter Werkstätten gelten ohne weitere Freigabe durch VoltCell als freigegeben (F-07). Die Werkstatt ist dabei verantwortliche Person und Quelle, damit gilt QZ-1 auch für diese Werte. |
