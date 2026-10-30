# 1. Einführung und Ziele

> **Status: Entwurf v0.1.** Annahmen sind mit A-x gekennzeichnet (siehe Kap. 2.4) und noch mit dem Dozenten zu klären.

<!-- arc42-Hilfe:
Beschreibt die wesentlichen Anforderungen und treibenden Kräfte: Geschäftsziele, wesentliche Aufgabenstellungen,
funktionale Anforderungen, Qualitätsziele für die Architektur, relevante Stakeholder und deren Erwartungshaltung.
Mehr: https://docs.arc42.org/section-1/
-->

**Betrieblicher Grund.** Die VoltCell GmbH stellt Batterien für E-Bikes und Speichersysteme her. Nach der EU-Batterieverordnung (VO (EU) 2023/1542, Art. 77) braucht ab dem **18.02.2027** jede neu in Verkehr gebrachte LV-Batterie (z. B. E-Bike-Akku) und jede Industriebatterie über 2 kWh einen **digitalen Batteriepass**, der über einen QR-Code auf der Batterie erreichbar ist. Ohne Pass darf VoltCell diese Batterien in der EU nicht mehr verkaufen.

Der Pass enthält Angaben zu Rohstoffherkunft, CO₂-Fußabdruck, Zustand und Recycling. Diese Daten stammen zu großen Teilen von Zulieferern, liegen in uneinheitlicher Qualität vor und ändern sich über die gesamte Lebensdauer der Batterie.

**VoltPass** ist die Plattform, die diese Daten einsammelt, prüft und als Batteriepass bereitstellt.

> **Architekturauftrag:** Aus unzuverlässigen Zulieferdaten einen verlässlichen Pass machen, der jedem genau das zeigt, was er sehen darf, und das noch in vielen Jahren.

## 1.1 Aufgabenstellung

Die folgenden Use Cases bilden die Hauptfunktionen von VoltPass. Die Spalte „Quelle“ verweist auf die Fallbeschreibung ([`docs/fall.md`](../fall.md), K-x = Knackpunkt, R-x = Randbedingung) oder auf die Verordnung.

| ID | Use Case | Hauptakteur | Beschreibung | Quelle |
|---|---|---|---|---|
| F-01 | Zulieferdaten einreichen | Zulieferer | Zulieferer übermitteln Daten zu Rohstoffen, Materialien und CO₂, entweder per Schnittstelle oder als Datei (PDF, CSV) bzw. Formular im Browser. | K-1, R-3 |
| F-02 | Daten extrahieren | VoltPass (automatisch) | Aus unstrukturierten Dokumenten werden die Passfelder KI-gestützt ausgelesen. Jeder Wert wird mit Fundstelle und Sicherheit markiert. | K-1 |
| F-03 | Daten prüfen und freigeben | Datenverantwortliche VoltCell | Extrahierte oder gelieferte Werte werden von einer Person geprüft, bei Bedarf korrigiert und freigegeben. Erst dann gelangen sie in einen Pass. | K-1 |
| F-04 | Pass anlegen und Kennung erzeugen | Produktion VoltCell | Pro gefertigter Batterie wird ein Pass mit eindeutiger Kennung angelegt. Die Kennung wird als QR-Code an den Etikettendruck übergeben und im EU-Register gemeldet. | R-1, R-2, Art. 77 |
| F-05 | Pass abrufen | Öffentlichkeit, Werkstatt, Recycler, Behörde | Nach dem Scannen des QR-Codes sieht jede Rolle genau die Felder, die ihr nach Anhang XIII zustehen. | K-2 |
| F-06 | Lebenszyklusdaten nachtragen | Werkstatt, Recycler | Berechtigte Rollen ergänzen Daten aus der Nutzung, z. B. Zustand (State of Health) oder den Status „wiederverwendet“ bzw. „recycelt“. | K-2, Art. 77 |
| F-07 | Änderungen nachweisen | Behörde, VoltCell | Für jede Angabe ist nachvollziehbar, wer sie wann aus welcher Quelle geändert hat. | K-3 |
| F-08 | Pass dauerhaft verfügbar halten | VoltCell, Treuhänder | Die Pässe bleiben erreichbar, auch wenn VoltCell nicht mehr existiert. | K-4, Art. 78 |

## 1.2 Qualitätsziele

Die fünf wichtigsten Qualitätsziele, nach Priorität geordnet. Die IDs (QZ-x) ziehen sich durch das gesamte Dokument. Die Szenarien mit Metriken folgen in Kap. 10.

| ID | Qualitätsziel | Merkmal (ISO/IEC 25010:2023) | Motivation | Bezug |
|---|---|---|---|---|
| QZ-1 | **Verlässliche Passdaten** | Funktionale Eignung → Funktionale Korrektheit | Fehler der KI-Extraktion landen sonst in einem rechtlich relevanten Dokument. Kein Wert wird ohne menschliche Freigabe und ohne Quellbeleg veröffentlicht. | K-1, F-02, F-03 |
| QZ-2 | **Langfristige Erreichbarkeit** | Zuverlässigkeit → Verfügbarkeit | Der aufgedruckte QR-Code muss 10 Jahre und länger zum richtigen Pass führen, auch ohne VoltCell. | K-4, R-2, F-08 |
| QZ-3 | **Rollengerechter Zugriff** | Sicherheit → Vertraulichkeit | Öffentlichkeit, Werkstatt, Recycler und Behörde dürfen Unterschiedliches sehen und ändern. Wirtschaftlich sensible Daten dürfen nicht öffentlich werden. | K-2, F-05, F-06 |
| QZ-4 | **Lückenlose Nachweisbarkeit** | Sicherheit → Verantwortlichkeit, Integrität | Für jede Angabe muss belegbar sein, wer sie wann geändert hat. Die Historie darf nachträglich nicht manipulierbar sein. | K-3, F-07 |
| QZ-5 | **Interoperabilität** | Kompatibilität → Interoperabilität | Die Verordnung verlangt offene Standards, maschinenlesbare Daten und keine Anbieterbindung. Nur so kann ein Dritter die Pässe später weiterbetreiben. | Art. 77/78, F-08 |

## 1.3 Stakeholder

| ID | Rolle | Beschreibung | Erwartung an VoltPass und die Architektur |
|---|---|---|---|
| SH-01 | Geschäftsführung VoltCell | Auftraggeber | Marktzugang ab 02/2027 sichern, überschaubare Betriebskosten |
| SH-02 | Compliance VoltCell | Verantwortlich für die Einhaltung der Batterieverordnung | Rechtssicherer Pass, prüfbare Historie bei Behördenanfragen |
| SH-03 | Datenverantwortliche VoltCell | Prüfen und geben Passdaten frei (F-03) | Wenig manuelle Arbeit, klare Hinweise auf unsichere Werte |
| SH-04 | Einkauf / Lieferantenmanagement | Steuert die Zulieferer | Einfacher Weg, Daten bei Zulieferern anzufordern |
| SH-05 | Produktion VoltCell | Fertigt die Batterien und druckt die QR-Codes | Kennung pro Batterie rechtzeitig vor dem Etikettendruck |
| SH-06 | IT-Betrieb VoltCell | Betreibt und überwacht VoltPass | Stabiler Betrieb, wenige Sonderlösungen |
| SH-07 | Zulieferer mit eigener IT | Liefern Daten automatisiert | Dokumentierte Schnittstelle, offenes Format |
| SH-08 | Zulieferer ohne eigene IT | Kleinbetriebe | Teilnahme nur mit Browser, ohne Installation und Schulung |
| SH-09 | Öffentlichkeit / Endkunde | Scannt den QR-Code | Verständliche öffentliche Angaben ohne Anmeldung |
| SH-10 | Werkstatt | Repariert und bewertet Batterien | Zugriff auf Reparatur- und Zustandsdaten, Zustand nachtragen |
| SH-11 | Recycler | Demontiert und recycelt Batterien | Zugriff auf Demontage- und Materialdaten, Status „recycelt“ setzen |
| SH-12 | Behörden | Marktaufsicht, notifizierte Stellen, EU-Kommission | Vollständiger Zugriff inkl. Änderungshistorie |
| SH-13 | Treuhänder (Annahme A-3) | Betreibt die Pässe nach Wegfall von VoltCell weiter | Vollständige, lesbare Datenkopie in offenem Format |
| SH-14 | Projektteam (wir) | Architektur und Prototyp | Nachvollziehbare Entscheidungen, machbarer Prototyp bis 01/2027 |
